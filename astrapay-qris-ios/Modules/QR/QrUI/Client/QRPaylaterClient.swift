//
// Created by Gilbert on 01/01/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation
import Alamofire


//public protocol QRClientProtocol{
//    func getAuthToken() -> String
//    func getUserToken() -> String
//}
public struct QRPaylaterClient {


    var jasonToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIwODc3ODU0NTEyODkiLCJyb2xlcyI6WyJMT0dJTiJdLCJpc3MiOiJBc3RyYVBheS1EZXYiLCJ0eXBlIjoiQUNDRVNTIiwidXNlcklkIjo1ODEsImRldmljZUlkIjoiMGE3MTU0YWEtOGVlMS00ZDU3LWIwZmEtYmEzNDU5YTI4MWI4IiwidHJhbnNhY3Rpb25JZCI6IiIsInRyYW5zYWN0aW9uVHlwZSI6IiIsIm5iZiI6MTYzNzkxMDgzNywiZXhwIjoxNjM3OTE0NDM3LCJpYXQiOjE2Mzc5MTA4MzcsImp0aSI6ImE5NDU5NGJjLTg0Y2YtNGUxNS1hYjZhLTAzNWFlYjY5MWE4NiIsImVtYWlsIjpbImphc29ubmF0aGFuYWVsMThAZ21haWwuY29tIl19.afmMnXTbxPrpcz-jcdkoCttDVVHxMT3Nd2n46UF02di7b2zTnbRBUG3Rm7qoLpXmP5fXYtI63sZhfc-CJFtnbYiY1HvufPZczf5TxlPq_mLsZVXGY9w61bwzKVJTtDNlgcKFWN3R3HWAyyRj4mSpE1SS8ecnFWaEN6L0Hml8gwbcMcoMlmREDOQ_CNJp3AITkTu5jhkfHhZuVb768_hyJ8chXdTu9BLloVcejKuqL3OS9KUrX5bRX81XJ2WzmY190TdlSMoGfycxPqfSODexxdBfxcP4gwo_dv8OHT25VmbErcUDiidU_kbebbmR3uAD85RWPTZFy622WptEEizUAg"

    //baseUrlMobileGatewayQr kalo sudah siap gateway sementara pake biasa aja dulu

//    let urlBaseQrisService = "https://qris-sit-api.astrapay.com/qris-service"
    var urlBaseQrisService = QRConstant.QRIS_SIT_API

    init(){
        switch (BuildModeEndpoint.buildMode){
        case .cygnus:
            urlBaseQrisService = QRConstant.QRIS_SIT_API
            break
        case .vega:
            urlBaseQrisService = QRConstant.QRIS_UAT_API
            break
        case .orion:
            urlBaseQrisService = "https://frontend-.astrapay.com/qris-service"
            break

        }

    }

    struct ClientProperty{
        static let AUTH_TOKEN = Prefs.getAuthNewAccessToken()
    }

    var urlTenorTrxQrisTPLMC : String = "\(QRConstant.baseUrlMobileGatewaySIT)/paylater-service/partners/maucash/tenor?merchantCode="


    public func constructHeaderGeneral() -> HTTPHeaders {
        let header: HTTPHeaders = [
            QRConstant.HEADER_X_APPLICATION_TOKEN: "\(Prefs.getUser()!.accessToken)", //hardcode aja dulu nanti
            "Authorization": "Bearer \(ClientProperty.AUTH_TOKEN)",
            "Content-Type": "application/json"
        ]
        return header
    }
}
extension QRPaylaterClient{
func getInquiryPaylater(requestTransactionToken: String, requestBasicAmount: String, completion: @escaping(_:QRResponse<QRPaylaterResponseDto>) -> Void) -> DataRequest {

        let getInquiryPaylaterUrl: String = "\(urlBaseQrisService)/inquiries/\(requestTransactionToken)/paymentMethods/payLater?amount=\(requestBasicAmount)"
        var header = self.constructHeaderGeneral()

        let request = AF.request(getInquiryPaylaterUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
                .responseDecodable(of: QRPaylaterResponseDto.self) {
                    response in

                    debugPrint(response)

                    switch response.result {
                    case .failure(let error):
                        completion(QRResponse(status: false, message: error.localizedDescription, data: nil))
                    case .success(let data):
                        completion(QRResponse(status: true, message: "OK", data: data))
                    }
                }
        return request
    }
}

extension QRPaylaterClient{
    func getQrisTenorTrxPLMC(merchantCode: String,goodsCode: String,mobile: String,amount:String,transType:String, completion:@escaping(_:QRResponse<QRTenorQrisTrxPLMCResp>) -> Void) -> DataRequest {
        let goodsCodeUrl : String = "&goodsCode=" + goodsCode
        let mobileUrl : String = "&mobile=" + mobile
        let amountUrl : String = "&amount=" + amount
        let transTypeUrl : String = "&transType=" + transType

        var urlRequest = urlTenorTrxQrisTPLMC + merchantCode + goodsCodeUrl + mobileUrl + amountUrl + transTypeUrl
        let request = AF.request(urlRequest, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.constructHeaderGeneral())
        {$0.timeoutInterval = 60}.responseDecodable(of: QRTenorQrisTrxPLMCResp.self) {
            response in

            debugPrint(response)

            switch response.result {
            case .failure(let error):
                switch error._code{
                case QRErrorConstant.TIMEOUT_ERROR_CODE:
                    completion(QRResponse(status: false, message: error.localizedDescription, data: nil, errorData: nil, isTimeOut: true, responseCode: response.response?.statusCode))
                    break
                default:
                    completion(QRResponse(status: false, message: error.localizedDescription, data: nil, errorData: nil, isTimeOut: false, responseCode: response.response?.statusCode))
                    break

                }
            case .success(let data):
                completion(QRResponse(status: true, message: "OK", data: data))
            }
        }
        return request
    }
}



