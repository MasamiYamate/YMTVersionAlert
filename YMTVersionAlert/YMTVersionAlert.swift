//
//  YMTVersionAlert.swift
//  YMTVersionAlert
//
//  Copyright © 2018年 MasamiYamate. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person a copy
// of this software and related documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice is be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

@objcMembers open class YMTVersionAlert {
    
    fileprivate var defaultTitle:String = "New version released"
    fileprivate var defaultBody :String = "To use the application comfortably please update it."
    
    fileprivate var nowInstallTitle  :String = "Now install"
    fileprivate var laterInstallTitle:String = "Later"
    
    var debugMode:Bool = false
    
    public init() {
        print("\(self) Initialize")
    }
    
    ///　Set the text of the title , body , button
    ///
    /// - Parameters:
    ///   - setTitle        :Title Text
    ///   - setBody         :Body Text
    ///   - setNowInstall   :Now install Button Text
    ///   - setLaterInstall :Later Button Text
    @nonobjc public func setAlertText (setTitle:String? , setBody:String? , setNowInstall:String? , setLaterInstall:String?) {
        if let tmpTitle:String = setTitle {
            defaultTitle = tmpTitle
        }
        
        if let tmpBody:String = setBody {
            defaultBody = tmpBody
        }
        
        if let tmpNowInstall:String = setNowInstall {
            nowInstallTitle = tmpNowInstall
        }
        
        if let tmpLaterInstall:String = setLaterInstall {
            laterInstallTitle = tmpLaterInstall
        }
    }
    
    /// Set the text of the alert title
    ///
    /// - Parameter title: Title Text
    @objc public func setAlertTitle (_ title:String) {
        defaultTitle = title
    }
    
    /// Set the text of the alert body
    ///
    /// - Parameter body: Body Text
    @objc public func setAlertBody (_ body:String) {
        defaultBody = body
    }
    
    /// Set the text of the now install button title
    ///
    /// - Parameter btnText: Button title
    @objc public func setAlertInstallBtnTitle (_ btnText:String) {
        nowInstallTitle = btnText
    }
    
    /// Set the text of the later button title
    ///
    /// - Parameter btnText: Button title
    @objc public func setAlertLaterBtnTitle (_ btnText:String) {
        laterInstallTitle = btnText
    }
    
    /// Switch debug mode
    ///
    /// - Parameter flg: Bool
    @objc public func setDebugFlg(_ flg:Bool) {
        self.debugMode = flg
    }
    
    /// Get Store Version
    ///
    /// - Parameter storeId : AppStore app page id
    /// - Returns           : Latest app version
    @objc public func getStoreVersion (_ storeId:String) -> String? {
        guard let storeData:String = self.getStoreAppStatus(storeId) else {
            return nil
        }
        return self.extractionAppVersionNo(storeData)
    }
    
    /// Get device installed app version
    ///
    /// - Returns: Installed app version
    @objc public func getLocalVersion () -> String? {
        if let infoDic = Bundle.main.infoDictionary {
            if let tmpVersionObj = infoDic["CFBundleShortVersionString"] {
                if let tmpVersionNo:String = tmpVersionObj as? String {
                    return tmpVersionNo
                }
            }
        }
        return nil
    }
    
    /// Open version alert
    ///
    /// - Parameters:
    ///   - parentvc: Parent view controller
    ///   - storeId: AppStore app page id
    ///   - forceUpdate: Forced update flag
    ///   - callback: Callback method
    @objc public func openVersionAlert (_ parentvc:UIViewController , storeId:String , forceUpdate:Bool , callback: (() ->Void)? ) {
        guard let storeVersion:String = self.getStoreVersion(storeId) else {
            print("\(self) StoreVersion Get Err")
            callback?()
            return
        }
        guard let localVersion:String = self.getLocalVersion() else {
            print("\(self) LocalVersion Get Err")
            callback?()
            return
        }
        
        if self.versionCheck(storeVer: storeVersion, localVer: localVersion) || self.debugMode {
            self.createVersionAlert(parentvc, storeId: storeId, forceUpdate: forceUpdate, callback: callback)
        }else{
            print("Version Alert None")
            callback?()
        }
    }
    
    fileprivate func createVersionAlert (_ parentvc:UIViewController , storeId:String , forceUpdate:Bool , callback: (() ->Void)?) {
        let alert:UIAlertController = UIAlertController(title: defaultTitle, message: defaultBody, preferredStyle: .alert)
        
        let nowInstallAct:UIAlertAction = UIAlertAction(title: nowInstallTitle, style: .default, handler: { _ in
            self.openStorePage(storeId)
            if !forceUpdate {
                callback?()
            }
        })
        
        let laterInstallAct:UIAlertAction = UIAlertAction(title: laterInstallTitle, style: .default, handler: { _ in
            print("\(self) Later Install Select")
            callback?()
        })
        
        alert.addAction(nowInstallAct)
        
        if !forceUpdate {
            alert.addAction(laterInstallAct)
        }
        
        DispatchQueue.main.async {
            parentvc.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func openStorePage (_ storeId:String) {
        let storeBaseUrl:String = "itms-apps://itunes.apple.com/app/id"
        let reqStoreUrl:String = "\(storeBaseUrl)\(storeId)"
        if let openUrl:URL = URL(string: reqStoreUrl) {
            UIApplication.shared.openURL(openUrl)
        }
    }
    
    fileprivate func getStoreAppStatus (_ storeId:String) -> String? {
        let semaphore = DispatchSemaphore.init(value: 0)
        let baseUrl:String = "https://itunes.apple.com/lookup?id="
        var retStr:String?
        if let url:URL = URL(string: "\(baseUrl)\(storeId)") {
            let urlReq:URLRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 60
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlReq) {
                data , response , error in
                if let getErr = error {
                    print("\(self) StoreVersion Get Error")
                    print("ErrorCode:\(getErr)")
                    semaphore.signal()
                }else if let getResponse = response , let getData = data{
                    print("\(self) \(getResponse)")
                    if let tmpUtf8Str:String = String.init(data: getData, encoding: String.Encoding.utf8) {
                        retStr = tmpUtf8Str
                    }
                    semaphore.signal()
                }else {
                    semaphore.signal()
                }
            }
            task.resume()
            semaphore.wait()
        }
        return retStr
    }
    
    fileprivate func extractionAppVersionNo (_ resultStr:String) -> String? {
        if let jsonData:Data = resultStr.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
                
                guard let item:[String:Any] = json as? [String:Any] else {
                    return nil
                }
                guard let storeDatas:[[String:Any]] = item["results"] as? [[String:Any]] else {
                    return nil
                }
                guard let storeData:[String:Any] = storeDatas.first else {
                    return nil
                }
                guard let tmpVersionNo:String = storeData["version"] as? String else {
                    return nil
                }
                return tmpVersionNo
            } catch {
                print("\(self) Parse Err : \(error)")
            }
        }
        return nil
    }
    
    fileprivate func versionCheck (storeVer:String , localVer:String) -> Bool {
        let type = storeVer.compare(localVer, options: .numeric, range: nil, locale: nil)
        switch type {
        case .orderedAscending:
            break
        case .orderedDescending:
            return true
        case .orderedSame:
            break
        }
        return false
    }
    
}
