import Foundation
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate
import SafariServices

@objc(KakaoShareLink)
class KakaoShareLink: NSObject {
    var rootViewController : UIViewController?
    var safariViewController : SFSafariViewController?

    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }

    public override init() {
        let appKey: String? = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String
        let customScheme: String? = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_SCHEME") as? String
        if (customScheme != nil) {
            KakaoSDK.initSDK(appKey: appKey!, customScheme: customScheme!)
        } else {
            KakaoSDK.initSDK(appKey: appKey!)
        }
    }

    private func createExecutionParams(dict: NSDictionary, key: String) -> Dictionary<String, String>? {
        if let dictArr = dict[key] {
            var returnDict: [String: String] = [:]
            for item in (dictArr as! NSArray) {
                if let returnKey = (item as! NSDictionary)["key"], let returnValue = (item as! NSDictionary)["value"] {
                    returnDict[returnKey as! String] = (returnValue as! String)
                }
            }
            return returnDict
        }
        return nil
    }

    private func createURL(dict: NSDictionary, key: String) -> URL? {
        if let value = dict[key] {
            return URL(string: (value as! String))
        }
        return nil
    }

    private func createLink(dict: NSDictionary, key: String) -> Link {
        if let linkDict = dict[key] {
            let lDict = (linkDict as! NSDictionary)
            let webUrl = createURL(dict: lDict, key: "webUrl")
            let mobileWebUrl = createURL(dict: lDict, key: "mobileWebUrl")
            let iosExecutionParams = createExecutionParams(dict: lDict, key: "iosExecutionParams")
            let androidExecutionParams = createExecutionParams(dict: lDict, key: "androidExecutionParams")
            return Link(webUrl: webUrl, mobileWebUrl: mobileWebUrl, androidExecutionParams: androidExecutionParams, iosExecutionParams: iosExecutionParams)
        }
        return Link(webUrl: nil, mobileWebUrl: nil, androidExecutionParams: nil, iosExecutionParams: nil)
    }

    private func createButton(dict: NSDictionary) -> Button {
        let title = dict["title"] != nil ? dict["title"] : ""
        let link = createLink(dict: dict, key: "link")
        return Button(title: (title as! String), link: link)
    }

    private func createButtons(dict: NSDictionary) -> Array<Button>? {
        if let dictArr = dict["buttons"] {
            var buttons: [Button] = []
            for item in (dictArr as! NSArray) {
                buttons.append(createButton(dict: (item as! NSDictionary)))
            }
            return buttons
        }
        return nil
    }

    private func createSocial(dict: NSDictionary) -> Social? {
        if let socialDict = dict["social"] {
            let sDict = socialDict as! NSDictionary
            let commentCount = (sDict["commentCount"] as? Int)
            let likeCount = (sDict["likeCount"] as? Int)
            let sharedCount = (sDict["sharedCount"] as? Int)
            let subscriberCount = (sDict["subscriberCount"] as? Int)
            let viewCount = (sDict["viewCount"] as? Int)
            return Social(likeCount: likeCount, commentCount: commentCount, sharedCount: sharedCount, viewCount: viewCount, subscriberCount: subscriberCount)
        }
        return nil
    }

    private func createContent(dict: NSDictionary) -> Content {
        let title = dict["title"] != nil ? (dict["title"] as! String) : ""
        let imageUrl = dict["imageUrl"] != nil ? createURL(dict: dict, key: "imageUrl")! : URL(string: "http://monthly.chosun.com/up_fd/Mdaily/2017-09/bimg_thumb/2017042000056_0.jpg")!
        let link = createLink(dict: dict, key: "link")
        let description = (dict["description"] as? String)
        let imageWidth = (dict["imageWidth"] as? Int)
        let imageHeight = (dict["imageHeight"] as? Int)
        return Content(title: title, imageUrl: imageUrl, imageWidth: imageWidth, imageHeight: imageHeight, description: description, link: link)
    }

    private func createContents(dictArr: NSArray) -> Array<Content> {
        var contents: [Content] = []
        for item in dictArr {
            contents.append(createContent(dict: (item as! NSDictionary)))
        }
        return contents
    }

    private func createCommerce(dict: NSDictionary) -> CommerceDetail {
        let regularPrice = (dict["regularPrice"] as! Int)
        let discountPrice = (dict["discountPrice"] as? Int)
        let discountRate = (dict["discountRate"] as? Int)
        let fixedDiscountPrice = (dict["fixedDiscountPrice"] as? Int)
        return CommerceDetail(regularPrice: regularPrice, discountPrice: discountPrice, discountRate: discountRate, fixedDiscountPrice: fixedDiscountPrice)
    }
    
    private func openLinkWebview(url: URL, callback: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.main.async {
            self.safariViewController = SFSafariViewController(url: url)
            self.safariViewController?.modalPresentationStyle = .pageSheet

            self.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            self.rootViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController?.present(self.safariViewController!, animated: true, completion: {
                    callback(true, nil)
                })
            })
        }
    }

    private func shareDefaultTemplate(templateObject: [String: Any], callback: @escaping (Bool, Error?) -> Void) {
        if ShareApi.isKakaoTalkSharingAvailable() == true {
            ShareApi.shared.shareDefault(templateObject: templateObject) {(linkResult, error) in
                if let error = error {
                    callback(false, error)
                }
                else {
                    //do something
                    guard let linkResult = linkResult else { return }
                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                    callback(true, nil)
                }
            }
        } else {
            if let url = ShareApi.shared.makeDefaultUrl(templateObject: templateObject) {
                openLinkWebview(url: url, callback: callback)
            }
        }
    }

    @objc(sendCommerce:withResolver:withRejecter:)
    func sendCommerce(dict:NSDictionary,resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        let buttons = createButtons(dict: dict)
        let buttonTitle = (dict["buttonTitle"] as? String)
        let commerceTemplate = CommerceTemplate(content: createContent(dict: (dict["content"] as! NSDictionary)), commerce: createCommerce(dict: (dict["commerce"] as! NSDictionary)), buttonTitle: buttonTitle, buttons: buttons)
        if let commerceTemplateJsonData = (try? SdkJSONEncoder.custom.encode(commerceTemplate)) {
            if let templateJsonObject = SdkUtils.toJsonObject(commerceTemplateJsonData) {
                shareDefaultTemplate(templateObject: templateJsonObject) {(result, error) in
                    if let error = error {
                        reject("E_Kakao_Link", error.localizedDescription, nil)
                    } else {
                        resolve(["result": result])
                    }
                }
            }
        }
    }
    @objc(sendList:withResolver:withRejecter:)
    func sendList(dict:NSDictionary,resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        let buttons = createButtons(dict: dict)
        let buttonTitle = (dict["buttonTitle"] as? String)
        let headerTitle = (dict["headerTitle"] as! String)
        let listTemplate = ListTemplate(headerTitle: headerTitle, headerLink: createLink(dict: dict, key: "headerLink"), contents: createContents(dictArr: (dict["contents"] as! NSArray)), buttonTitle: buttonTitle, buttons: buttons)
        if let listTemplateJsonData = (try? SdkJSONEncoder.custom.encode(listTemplate)) {
            if let templateJsonObject = SdkUtils.toJsonObject(listTemplateJsonData) {
                shareDefaultTemplate(templateObject: templateJsonObject) {(result, error) in
                    if let error = error {
                        reject("E_Kakao_Link", error.localizedDescription, nil)
                    } else {
                        resolve(["result": result])
                    }
                }
            }
        }
    }
    @objc(sendFeed:withResolver:withRejecter:)
    func sendFeed(dict:NSDictionary,resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        let buttons = createButtons(dict: dict)
        let buttonTitle = (dict["buttonTitle"] as? String)
        let feedTemplate = FeedTemplate(content: createContent(dict: (dict["content"] as! NSDictionary)), social: createSocial(dict: dict), buttonTitle: buttonTitle, buttons: buttons)
        if let feedTemplateJsonData = (try? SdkJSONEncoder.custom.encode(feedTemplate)) {
            if let templateJsonObject = SdkUtils.toJsonObject(feedTemplateJsonData) {
                shareDefaultTemplate(templateObject: templateJsonObject) {(result, error) in
                    if let error = error {
                        reject("E_Kakao_Link", error.localizedDescription, nil)
                    } else {
                        resolve(["result": result])
                    }
                }
            }
        }
    }
    @objc(sendLocation:withResolver:withRejecter:)
    func sendLocation(dict:NSDictionary,resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        let buttons = createButtons(dict: dict)
        let buttonTitle = (dict["buttonTitle"] as? String)
        let locationTemplate = LocationTemplate(address: (dict["address"] as! String), addressTitle: (dict["addressTitle"] as? String), content: createContent(dict: (dict["content"] as! NSDictionary)), social: createSocial(dict: dict), buttonTitle: buttonTitle, buttons: buttons)
        if let locationTemplateJsonData = (try? SdkJSONEncoder.custom.encode(locationTemplate)) {
            if let templateJsonObject = SdkUtils.toJsonObject(locationTemplateJsonData) {
                shareDefaultTemplate(templateObject: templateJsonObject) {(result, error) in
                    if let error = error {
                        reject("E_Kakao_Link", error.localizedDescription, nil)
                    } else {
                        resolve(["result": result])
                    }
                }
            }
        }
    }
    @objc(sendText:withResolver:withRejecter:)
    func sendText(dict:NSDictionary,resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        let buttons = createButtons(dict: dict)
        let buttonTitle = (dict["buttonTitle"] as? String)
        let textTemplate = TextTemplate(text: (dict["text"] as! String), link: createLink(dict: dict, key: "link"), buttonTitle: buttonTitle, buttons: buttons)
        if let textTemplateJsonData = (try? SdkJSONEncoder.custom.encode(textTemplate)) {
            if let templateJsonObject = SdkUtils.toJsonObject(textTemplateJsonData) {
                shareDefaultTemplate(templateObject: templateJsonObject) {(result, error) in
                    if let error = error {
                        reject("E_Kakao_Link", error.localizedDescription, nil)
                    } else {
                        resolve(["result": result])
                    }
                }
            }
        }
    }
    @objc(sendCustom:withResolver:withRejecter:)
    func sendCustom(dict:NSDictionary,resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        let templateId = Int64(dict["templateId"] as! Int)
        let templateArgs = createExecutionParams(dict: dict, key: "templateArgs")
        if ShareApi.isKakaoTalkSharingAvailable() == true {
            ShareApi.shared.shareCustom(templateId: templateId, templateArgs: templateArgs) {(linkResult, error) in
                if let error = error {
                    reject("E_Kakao_Link", error.localizedDescription, nil)
                }
                else {
                    //do something
                    guard let linkResult = linkResult else { return }
                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                    resolve(["result": true])
                }
            }
        } else {
            if let url = ShareApi.shared.makeCustomUrl(templateId: templateId, templateArgs:templateArgs) {
                openLinkWebview(url: url) {(result, error) in
                    if let error = error {
                        reject("E_Kakao_Link", error.localizedDescription, nil)
                    } else {
                        resolve(["result": true])
                    }
                }
            }
        }
    }
}
