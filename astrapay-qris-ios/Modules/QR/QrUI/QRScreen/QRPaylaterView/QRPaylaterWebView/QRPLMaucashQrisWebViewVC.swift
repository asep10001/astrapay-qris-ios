//
//  PLMaucashQrisWebViewVC.swift
//  astrapay
//
//  Created by user on 04/01/22.
//  Copyright © 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class QRPLMaucashQrisWebViewVC: UIViewController, WKUIDelegate{
    
    @IBOutlet weak var viewActivityIndicator: UIView!
    @IBOutlet weak var viewWebKit: UIView!

    struct VCProperty{
        static let identifierVC : String = "PLMaucashQrisWebViewVCIdentifier"
        static let navigationTitle : String = "Maupaylater"
        static let navigationTitleBeta : String = "Maupaylater Beta"
    }


    var router: QRNewRouter?
    var viewModel = QRPLMaucashQrisWebViewVM()
    static let identifier : String = VCProperty.identifierVC
    var resourceType: QRPLMaucashQrisWebViewVMType?
    var webView: WKWebView!
    let webViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-110)
    var hasNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
    
    var isFlagBeta : Bool =  UserDefaults.standard.bool(forKey: "flagBeta")
    
    var tagNavigate: Int = 0

    //init
    public convenience init(payload: QRPLMaucasQrisWebViewPayload){
        self.init()
        self.viewModel = QRPLMaucashQrisWebViewVM(payload: payload)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVm()
        setWebview()
        setupNavigation(conditionBeta:isFlagBeta)
        setRoutes()
        setActions()
    }
    
    func setVm(){
        self.viewModel.delegate = self
        self.viewModel.setupUserData()
    }
    
    func setupNavigation(conditionBeta:Bool) {
        if isFlagBeta {
            self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitleBeta, navigator: .back, navigatorCallback: nil)
        } else {
            self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
        }
    }
    
    func setViewUI(){
        self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .back, navigatorCallback: nil)
    }
    
    func setWebview(){
        let sourceInject = """
    window.addEventListener('message', function(e) {
        window.webkit.messageHandlers.jsListener.postMessage(JSON.stringify(e.data));
    });
    """
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        let script = WKUserScript(source:sourceInject, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webConfiguration.userContentController.addUserScript(script)
        webConfiguration.userContentController.add(self, name: "jsListener")
        
        if hasNotch {
            webView = WKWebView(frame: CGRect( x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-110), configuration: webConfiguration)
        } else {
            webView = WKWebView(frame: webViewFrame, configuration: webConfiguration)
        }
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.scrollView.delegate = self
        
        self.resourceType = viewModel.resourceType
        loadWebview()
        self.viewWebKit.addSubview(webView)
    }
    
    func setRoutes(){
        self.router = QRNewRouter(viewController: self)
    }
    
    func setActions(){
    }
}

extension QRPLMaucashQrisWebViewVC {
    
    func loadWebview() {
        if let resource = resourceType {
            webView.load(resource)
            showActivityIndicator()
        } else {
            fatalError("please set resourceType variable!")
        }
    }
    
    func showActivityIndicator() {
        self.viewActivityIndicator.isHidden = false
        self.viewWebKit.isHidden = true
    }

    func hideActivityIndicator(){
        self.viewActivityIndicator.isHidden = true
        self.viewWebKit.isHidden = false
    }
    
    func openSafari(_ withUrl : URL){
         UIApplication.shared.open(withUrl)
    }
}

extension QRPLMaucashQrisWebViewVC: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

extension QRPLMaucashQrisWebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            if let urlToLoad = navigationAction.request.url {
                self.openSafari(urlToLoad)
            }
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
    }
}

extension WKWebView {
    func load(_ resourceType: QRPLMaucashQrisWebViewVMType) {
        switch resourceType {
        case .file(let url):
            let request = resourceType.loadResourceFile(url)
            self.loadFileURL(request, allowingReadAccessTo: request.deletingLastPathComponent())
        case .web(let url):
            let request = resourceType.loadResourceWeb(url)
            self.load(request)
        case .contentHTML(let url):
            self.loadHTMLString(url, baseURL: nil)
        }
    }
}

extension QRPLMaucashQrisWebViewVC : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let data = "\(message.body)"
        if data == "\"close\"" {
            print("---> closing the view")
            self.setTextNavigation(theme: .normal, title: VCProperty.navigationTitle, navigator: .none, navigatorCallback: nil)
            if tagNavigate == 0 {
                self.tagNavigate = 1
                //call api patch
                self.stateLoading(state: .show)
                self.viewModel.patchQrisTransactionsPLMC(id: self.viewModel.idTrx)
            }
        }
    }
}

extension QRPLMaucashQrisWebViewVC : QRPLMaucashQrisWebViewVMProtocol {
    func didSuccesPatchQris() {
        DispatchQueue.main.async {
            self.viewModel.getDetailTransaksi(idTransaksi: String(self.viewModel.idTrx))
            self.stateLoadingQR(state: .dismiss)
        }
    }
    
    func didFailurePatchQris() {
        DispatchQueue.main.async {
            self.stateLoading(state: .dismiss)
            var payloadData = QRGetDetailTransaksiByIdDtoViewData(status: "VOID")
            self.router?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: payloadData)
        }
    }
    
    func didErrorPatchQris() {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                self.stateLoadingQR(state: .dismiss)
            }
            var payloadData = QRGetDetailTransaksiByIdDtoViewData(status: "VOID")
            self.router?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: payloadData)
        }
    }

       func didSuccessGetDetailTransaksiById(qrGetDetailTransaksiByIdResponse: QRGetDetailTransaksiByIdResponse){
           var qrGetDetailTransaksiDtoViewData = QRGetDetailTransaksiByIdDtoViewData(qrGetDetailTransaksiResponse: qrGetDetailTransaksiByIdResponse)
           self.router?.navigateToResulPaymentAfterClickBayarAndInputPin(qrGetDetailTransaksiByIdDtoViewData: qrGetDetailTransaksiDtoViewData, isPaylater: true)
       }
}
