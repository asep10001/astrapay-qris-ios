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
    var baseURLMobileNoGateway = "https://qris-sit-api.astrapay.com"
    let urlBaseQrisService = "https://qris-sit-api.astrapay.com/qris-service"

    public func constructHeaderGeneral() -> HTTPHeaders {
        let header: HTTPHeaders = [
//            "X-Application-Token": cacheAuth.getLoginCredential()?.token ?? embedKey,
            "X-Application-Token": "\(Prefs.getUser()!.accessToken)", //hardcode aja dulu nanti
            //untuk dapetin token Prefs.getAuthNewAccessToken()
            "Authorization": "Bearer \(jasonToken)",
            "Content-Type": "application/json"
        ]
        return header
    }

    public func constructHeaderForInquiryApi() -> HTTPHeaders {
        let header: HTTPHeaders = [
            "X-Application-Token": "\(Prefs.getUser()!.accessToken)", //hardcode aja dulu nanti
            "X-SDK-Token": "XTOKEN",
            "Authorization": "Bearer \(jasonToken)",
            "Content-Type": "application/qris",
            "x-user-id": "1177"
        ]
        return header
    }
}
//MARK: Get transaction detail by id
extension QRPaylaterClient{
func getInquiryPaylater(requestTransactionToken: String, requestBasicAmount: String, completion: @escaping(_:QRResponse<QRPaylaterResponseDto>) -> Void) -> DataRequest {
        let getInquiryPaylaterUrl: String = "\(urlBaseQrisService)/inquiries/\(requestTransactionToken)/paymentMethods/payLater?amount=\(requestBasicAmount)"


        let request = AF.request(getInquiryPaylaterUrl, method: .get, parameters: nil, encoding: URLEncoding.default)
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
