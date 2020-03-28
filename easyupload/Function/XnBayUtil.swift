//
//  CallFileApi.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import Alamofire

class XnBayUtil {

    enum Errno:Int {
        case ERR_EMPTY_RESULT = -1
        case ERR_JSON_DECODE = -2
        case ERR_NO_DATA = -3
        case ERR_PARAMETERS = -4
        case ERR_ACCESSTOKEN = -5
        case ERR_TIMEOUT = -6
        case ERR_NO_NETWORK = -7
        case ERR_CONNECTION = -8
        case ERR_UNKNOWN = -99
        
        case ERR_ERROR = -999
        
        // ==== Errno from XnBay
        case ERR_SUCCESS = 0
        case ERR_WRONG_PASSWORD = 50
        case ERR_BANNED_IP_ADDR = 51
        case ERR_ACCESSTOKEN_EXPIRED = 60
        case ERR_ACCESSTOKEN_NOTEXISTS = 61
        
        case ERR_BACKUP = 80
        
    }
    
    public static let shared = XnBayUtil()
    private var _connectUrl: String = ""
    private var connectUrl: String {
        get {
            return self._connectUrl
        }
        
        set {
            if let last = newValue.last, last != "/" {
                self._connectUrl = newValue + "/"
            } else {
                self._connectUrl = newValue
            }
        }
    }
    
    private var invokeApiUrl: String {
        get {
            return self.connectUrl + "invoke_api.php"
        }
        set {}
    }
    
    private var accessToken: String? = nil
    private let clientId = "com.xnbay.xnfun"
    
    init() {
    }
    
    func login(id: String, ip: String, email: String, password: String, completionHandler: @escaping (Int)->()) {
        self.connectUrl = ip
        
        let encriptedPwd = CryptoUtil.sha512Hex(string: password)
        let parameters: [String : Any] = ["RouteName": "common",
                                          "Type": "login",
                                          "UserId": id,
                                          "UserEmail": email,
                                          "Password": encriptedPwd,
                                          "ClientId": self.clientId]
        
        self.requestXnBayApi(parameters: parameters) { (responseValue, error) in
            
            guard error == .ERR_SUCCESS else {
                print("Error: getXnBayAccessToken() error = \(error)")
                completionHandler(Errno.ERR_ERROR.rawValue)
                return
            }
            
            guard responseValue != nil else {
                print("Error: getXnBayAccessToken() Empty responseValue")
                completionHandler(Errno.ERR_ERROR.rawValue)
                return
            }
            
            var dataResult: FileApiResult.GetAccessTokenResult? = nil
            do {
                dataResult = try JSONDecoder().decode(FileApiResult.GetAccessTokenResult.self, from: responseValue!)
            } catch {
                print("Error: getXnBayAccessToken() Failed to decode, \(error)")
                completionHandler(Errno.ERR_JSON_DECODE.rawValue)
                return
            }
            
            let errorNo = dataResult?.errno ?? Errno.ERR_ERROR.rawValue
            guard errorNo == 0 else {
                print("Error: getXnBayAccessToken() errno = \(dataResult?.errno ?? -1), \(dataResult?.msg ?? "NA")")
                completionHandler(errorNo)
                return
            }
            
            if let obj = dataResult?.object {
                self.accessToken = obj.AccessToken
                completionHandler(Errno.ERR_SUCCESS.rawValue)
            } else {
                completionHandler(Errno.ERR_NO_DATA.rawValue)
            }
        }
        
    }
    
    private func getErrno(_ error: Error?) -> Errno {
        var errno = Errno.ERR_UNKNOWN
        
        guard let _ = error else {
            return errno
        }
        
        let err = "\(String(describing: error))"
        if err.contains("Code=-1001") {
            // Code=-1001 "The request timed out."
            errno = Errno.ERR_TIMEOUT
        } else if err.contains("Code=-1002") {
            // Code=-1002 "unsupported URL"...前面因timeout沒讀取到URL of API
            errno = Errno.ERR_PARAMETERS
        } else if err.contains("Code=-1003") {
            // Code=-1003 "A server with the specified hostname could not be found."
            errno = Errno.ERR_TIMEOUT
        } else if err.contains("Code=-1004") {
            // Code=-1004 "無法連接伺服器
            errno = Errno.ERR_TIMEOUT
        } else if err.contains("Code=-1005") {
            // Code=-1005 "The network connection was lost.",Code=-1005 "網路連線中斷"。
            errno = Errno.ERR_NO_NETWORK
        } else if err.contains("Code=-1009") {
            // Code=-1009 "Internet 連線已斷開
            errno = Errno.ERR_NO_NETWORK
        }
        
        return errno
    }
    
    private func requestXnBayApi(parameters: Parameters, completionHandler: @escaping (Data?, Errno)->()) {
        var hasCompleted: Bool = false
        let timeout: Int = 30
        
        Alamofire.request(self.invokeApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                if !hasCompleted {
                    hasCompleted = true
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: [])
                        completionHandler(data, Errno.ERR_SUCCESS)
                    } catch {
                        print("Error: normalCallInvokePhpWithDataResp() 轉換Data錯誤, \(value)")
                        completionHandler(nil, Errno.ERR_JSON_DECODE)
                    }
                }
                break
            case .failure(let error):
                print("Error: normalCallInvokePhpWithDataResp(), FAILURE:",error)
                if !hasCompleted {
                    hasCompleted = true
                    completionHandler(nil, self.getErrno(error))
                }
                break
            }
        }
        
        // 等待n(timeoutSecond)秒
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(timeout)) {
            if !hasCompleted {
                hasCompleted = true
                completionHandler(nil, .ERR_TIMEOUT)
            }
        }
    }
}
