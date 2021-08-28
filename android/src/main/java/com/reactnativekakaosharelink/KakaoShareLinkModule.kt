package com.reactnativekakaosharelink

import com.facebook.react.bridge.*
import com.kakao.sdk.common.KakaoSdk
import com.kakao.sdk.link.LinkClient
import com.kakao.sdk.template.model.*

class KakaoShareLinkModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "KakaoShareLink"
  }

  private fun getS(dict: ReadableMap, key: String): String? {
    return if (dict.hasKey(key)) dict.getString(key) else null
  }

  private fun getI(dict: ReadableMap, key: String): Int? {
    return if (dict.hasKey(key)) dict.getInt(key) else null
  }

  private fun createExecutionParams(dictArr: ReadableArray?): Map<String, String>? {
    if (dictArr == null) return null
    val length = dictArr.size() - 1
    if (length == -1) return null
    var map = mutableMapOf<String, String>();
    for (i in 0..length) {
      val dict: ReadableMap = dictArr.getMap(i)!!
      val key = getS(dict, "key")!!
      val value = getS(dict, "value")!!
      map.put(key, value)
    }
    return map.toMap()
  }

  private fun createLink(dict: ReadableMap): Link {
    val webURL: String? = getS(dict, "webUrl")
    val mobileWebURL: String? = getS(dict, "mobileWebUrl")
    val iosExecutionParams: Map<String, String>? = createExecutionParams(dict.getArray("iosExecutionParams"))
    val androidExecutionParams: Map<String, String>? = createExecutionParams(dict.getArray("androidExecutionParams"))
    return Link(webUrl = webURL, mobileWebUrl = mobileWebURL, iosExecutionParams = iosExecutionParams, androidExecutionParams = androidExecutionParams)
  }

  private fun createButton(dict: ReadableMap): Button {
    val title: String = getS(dict, "title")!!
    val link: Link = createLink(dict.getMap("link")!!)
    return Button(title, link)
  }

  private fun createButtons(dictArr: ReadableArray): List<Button>? {
    val length = dictArr.size() - 1
    val buttons = mutableListOf<Button>()
    if (length < 0) return null
    for (i in 0..length) {
      buttons.add(createButton(dictArr.getMap(i)!!))
    }
    return buttons.toList()
  }

  private fun createContent(dict: ReadableMap): Content {
    val title: String = getS(dict, "title")!!
    val url: String = getS(dict,"imageUrl")!!
    val link: Link = createLink(dict.getMap("link")!!)
    val desc: String? = getS(dict,"description")
    val imgWidth: Int? = getI(dict,"imageWidth")
    val imgHeight: Int? = getI(dict,"imageHeight")
    return Content(title, description = desc, imageUrl = url, imageWidth = imgWidth, imageHeight = imgHeight, link = link)
  }

  private fun createContents(dictArr: ReadableArray): List<Content> {
    val length = dictArr.size() - 1
    val contents = mutableListOf<Content>();
    if (length < 0) return contents
    for (i in 0..length) {
      contents.add(createContent(dictArr.getMap(i)!!))
    }
    return contents.toList()
  }

  private fun createCommerce(dict: ReadableMap): Commerce {
    val regularPrice: Int = getI(dict,"regularPrice")!!
    val discountPrice: Int? = getI(dict, "discountPrice")
    val discountRate: Int? = getI(dict, "discountRate")
    val fixedDiscountPrice: Int? = getI(dict,"fixedDiscountPrice")
    val productName: String? = getS(dict,"productName")
    return Commerce(regularPrice, discountPrice, fixedDiscountPrice, discountRate, productName)
  }

  private fun createSocial(dict: ReadableMap): Social {
    val commentCount: Int? = getI(dict, "commentCount")
    val likeCount: Int? = getI(dict,"likeCount")
    val sharedCount: Int? = getI(dict, "sharedCount")
    val subscriberCount: Int? = getI(dict, "subscriberCount")
    val viewCount: Int? = getI(dict, "viewCount")
    return Social(likeCount, commentCount, sharedCount, viewCount, subscriberCount)
  }

  private fun sendWithTemplate(template: DefaultTemplate, promise: Promise) {
    val serverCallbackArgs = HashMap<String, String>()
    serverCallbackArgs["user_id"] = "\${current_user_id}"
    serverCallbackArgs["product_id"] = "\${shared_product_id}"
    if (LinkClient.instance.isKakaoLinkAvailable(this.reactContext)) {
      LinkClient.instance.defaultTemplate(reactContext, template, serverCallbackArgs) { linkResult, error ->
        if (error != null) {
          promise.reject("E_KAKAO_ERROR", error.message, error)
          return@defaultTemplate
        } else {
          val map = Arguments.createMap()
          map.putBoolean("result", true)
          map.putString("intent", linkResult?.intent.toString())
          linkResult?.intent?.let { intent -> reactContext.startActivity(intent, null) }
          map.putString("warning", linkResult?.warningMsg.toString())
          map.putString("argument", linkResult?.argumentMsg.toString())
          map.putString("callback", serverCallbackArgs.toString())
          promise.resolve(map)
          return@defaultTemplate
        }
      }
    } else promise.reject("E_KAKAOTALK_NOT_INSTALLED", "카카오톡이 설치되어있지 않습니다.", Throwable("no kakao app"))
  }

  @ReactMethod
  private fun sendCommerce(dict: ReadableMap, promise: Promise) {
    val commerce = CommerceTemplate(
      content = createContent(dict.getMap("content")!!),
      commerce = createCommerce(dict.getMap("commerce")!!),
      buttons = if (dict.hasKey("buttons")) createButtons(dict.getArray("buttons")!!) else null,
      buttonTitle = getS(dict, "buttonTitle")
    )
    sendWithTemplate(commerce, promise)
  }

  @ReactMethod
  private fun sendList(dict: ReadableMap, promise: Promise) {
    val list = ListTemplate(
      headerTitle = if (dict.hasKey("headerTitle")) dict.getString("headerTitle")!! else "",
      headerLink = createLink(dict.getMap("headerLink")!!),
      contents = createContents(dict.getArray("contents")!!),
      buttons = if (dict.hasKey("buttons")) createButtons(dict.getArray("buttons")!!) else null,
      buttonTitle = getS(dict, "buttonTitle")
    )
    sendWithTemplate(list, promise)
  }

  @ReactMethod
  private fun sendFeed(dict: ReadableMap, promise: Promise) {
    val feed = FeedTemplate(
      content = createContent(dict.getMap("content")!!),
      social = if (dict.hasKey("social")) createSocial(dict.getMap("social")!!) else null,
      buttons = if (dict.hasKey("buttons")) createButtons(dict.getArray("buttons")!!) else null,
      buttonTitle = getS(dict, "buttonTitle")
    )
    sendWithTemplate(feed, promise)
  }

  @ReactMethod
  private fun sendLocation(dict: ReadableMap, promise: Promise) {
    val location = LocationTemplate(
      address = if (dict.hasKey("address")) dict.getString("address")!! else "",
      addressTitle = if (dict.hasKey("addressTitle")) dict.getString("addressTitle")!! else null,
      content = createContent(dict.getMap("content")!!),
      social = if (dict.hasKey("social")) createSocial(dict.getMap("social")!!) else null,
      buttons = if (dict.hasKey("buttons")) createButtons(dict.getArray("buttons")!!) else null,
      buttonTitle = getS(dict, "buttonTitle")
    )
    sendWithTemplate(location, promise)
  }

  @ReactMethod
  private fun sendText(dict: ReadableMap, promise: Promise) {
    val text = TextTemplate(
      text = if (dict.hasKey("text")) dict.getString("text")!! else "",
      link = createLink(dict.getMap("link")!!),
      buttons = if (dict.hasKey("buttons")) createButtons(dict.getArray("buttons")!!) else null,
      buttonTitle = getS(dict, "buttonTitle")
    )
    sendWithTemplate(text, promise)
  }

  init {
    val kakaoAppKey = reactContext.resources.getString(
      reactContext.resources.getIdentifier("kakao_app_key", "string", reactContext.packageName))
    KakaoSdk.init(reactContext, kakaoAppKey)
  }
}
