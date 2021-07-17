# react-native-kakao-share-link

React Native 카카오 링크 라이브러리 입니다. 아직 안정적인 버전은 아니니 유의해주시고 문제가 있으면 issue에 남겨주시기 바랍니다.

## [주의 사항]

- 안드로이드 minSdkVersion 19 이상
- iOS 11.0 이상

# Getting started

해당 라이브러리는 [kakao sdk v2](https://developers.kakao.com/docs/latest/ko/getting-started/app)를 사용하므로 안드로이드 minSdkVersion 19이상, iOS 11.0 이상만 지원합니다.

## Installation

```sh
npm install react-native-kakao-share-link
cd ios
pod install
```

### React Native Link

### RN >= 0.60

---

자동으로 링크가 진행됩니다.

### RN < 0.60

---

react-native link를 사용하시면 빠른 링크가 가능합니다.

```sh
react-native link react-native-kakao-share-link
```

### 수동 링크

#### iOS

---

1. In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name]
2. Go to node_modules ➜ react-native-kakao-share-link and add KakaoShareLink.xcodeproj
3. In XCode, in the project navigator, select your project. Add libKakaoShareLink.a to your project's Build Phases ➜ Link Binary With Libraries
4. Run your project (Cmd+R)<

#### Android

---

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
   - Add import com.reactnativekakaosharelink.KakaoShareLinkPackage; to the imports at the top of the file
   - Add new KakaoShareLinkPackage() to the list returned by the getPackages() method
2. Append the following lines to `android/settings.gradle`

```gradle
// android/settings.gradle

...

include ':react-native-kakao-share-link'
project(':react-native-kakao-share-link').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-kakao-share-link/android')
```

3. nsert the following lines inside the dependencies block in `android/app/build.gradle`

```gradle
// android/app/build.gradle

...

compile project(':react-native-kakao-share-link')
```

## Setting

Kakao 개발자 홈페이지에서 iOS와 Android 각각을 등록하고 네이티브 앱키를 발급받았다고 가정하고 진행하겠습니다.

### iOS

---

1. iOS 설정 관련 사항은 [공식문서 - 메시지 - 카카오링크:iOS](https://developers.kakao.com/docs/latest/ko/message/ios-link)에서 확인하실 수 있습니다.

2. `Podfile`에서 iOS 버전을 11.0 이상으로 설정합니다.

```ruby
# Podfile

...

platform :ios, '11.0' # 혹은 그 이상
```

3. Xcode 상에서 `iOS Deployment Target`을 모두 11.0 이상으로 변경합니다.

4. `Info.plist`에 카카오 네이티브앱 키를 추가합니다.

```diff
<!-- ios/{ProjectName}/Info.plist -->

  <key>CFBundleURLTypes</key>
  <array>
+   <dict>
+     <key>CFBundleTypeRole</key>
+     <string>Editor</string>
+     <key>CFBundleURLSchemes</key>
+     <array>
+       <string>kakao{카카오 네이티브앱 키}</string>
+     </array>
+   </dict>
  </array>
  <key>CFBundleVersion</key>
  <string>1</string>
+ <key>KAKAO_APP_KEY</key>
+ <string>{카카오 네이티브앱 키}</string>
+ <key>LSApplicationQueriesSchemes</key>
+ <array>
+     <!-- 카카오톡으로 로그인 -->
+     <string>kakaokompassauth</string>
+     <!-- 카카오링크 -->
+     <string>kakaolink</string>
+ </array>
```

5. Xcode -> Build Settings -> Search Paths -> Library Search Paths 에서 `"$(TOOLCHAIN_DIR)/usr/lib/swift-5.0/$(PLATFORM_NAME)"` 를 제거합니다.

### Android

---

1. Android 설정 관련 사항은 [공식문서 - 메시지 - 카카오링크:Android](https://developers.kakao.com/docs/latest/ko/message/android-link#before-you-begin)에서 확인하실 수 있습니다.

2. 카카오 SDK 경로를 `android/build.gradle`에 추가합니다.

```gradle
// android/build.gradle

...

allprojects {
    repositories {
        ...

        maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }
    }
}

```

3. AndroidManifest.xml을 수정합니다.

```diff
  <manifest>

    ...

+   <uses-permission android:name="android.permission.INTERNET" />

    ...

    <application
+     android:allowBackup="true"

    ...

  </manifest>
```

4. `app/src/main/res/values/string.xml` 을 열어 다음을 추가합니다.

```diff
  <resources>

    ...

+   <string name="kakao_app_key">{카카오 네이티브 앱키}</string>

    ...

  </resources>

```

## Usage

### 현재 지원하는 기능

- [`커머스 템플릿`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#CommerceTemplateType)
- [`리스트 템플릿`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ListTemplateType)
- [`피드 템플릿`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#FeedTemplateType)
- [`위치 템플릿`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#LocationTemplateType)
- [`텍스트 템플릿`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#TextTemplateType)

#### `[주의사항]`

- 링크 URL은 카카오 디벨로퍼에서 등록한 도메인으로만 설정 가능합니다. 그 외에는 오류가 납니다.
- 링크 실행 우선순위는 `(android/ios)ExecutionParams > mobileWebURL > webURL` 입니다.
- 전송하는 모든 이미지는 최소 200px \* 200px 이상, 2MB 이하여야합니다.

### 예제 코드

#### `ContentType`

| 이름        | 설명                              | 타입                                                                                                  | 필수 |
| ----------- | --------------------------------- | ----------------------------------------------------------------------------------------------------- | ---- |
| title       | 콘텐츠의 타이틀                   | string                                                                                                | O    |
| link        | 콘텐츠 클릭 시 이동할 링크 정보   | [`LinkType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#LinkType) | O    |
| imageURL    | 콘텐츠의 이미지 URL               | string                                                                                                | O    |
| desc        | 콘텐츠의 상세 설명                | string                                                                                                | X    |
| imageWidth  | 콘텐츠의 이미지 너비 (단위: 픽셀) | number                                                                                                | X    |
| imageHeight | 콘텐츠의 이미지 높이 (단위: 픽셀) | number                                                                                                | X    |

#### `LinkType`

| 이름                   | 설명                                                            | 타입                                   | 필수 |
| ---------------------- | --------------------------------------------------------------- | -------------------------------------- | ---- |
| webUrl                 | PC버전 카카오톡에서 사용하는 웹 링크 URL                        | string                                 | X    |
| mobileWebUrl           | 모바일 카카오톡에서 사용하는 웹 링크 URL                        | string                                 | X    |
| androidExecutionParams | 안드로이드 카카오톡에서 사용하는 앱 링크 URL에 사용될 파라미터. | Array<{ key: string; value: string; }> | X    |
| iosExecutionParams     | iOS 카카오톡에서 사용하는 앱 링크 URL에 사용될 파라미터.        | Array<{ key: string; value: string; }> | X    |

#### `SocialType`

| 이름            | 설명               | 타입   | 필수 |
| --------------- | ------------------ | ------ | ---- |
| likeCount       | 콘텐츠의 좋아요 수 | number | X    |
| commentCount    | 콘텐츠의 댓글 수   | number | X    |
| sharedCount     | 콘텐츠의 공유 수   | number | X    |
| viewCount       | 콘텐츠의 조회 수   | number | X    |
| subscriberCount | 콘텐츠의 구독 수   | number | X    |

#### `CommerceType`

| 이름               | 설명           | 타입   | 필수 |
| ------------------ | -------------- | ------ | ---- |
| regularPrice       | 정상가격       | number | O    |
| discountPrice      | 할인된 가격    | number | X    |
| discountRate       | 할인율         | number | X    |
| fixedDiscountPrice | 정액 할인 가격 | number | X    |

#### `ButtonType`

| 이름  | 설명                           | 타입                                                                                                  | 필수 |
| ----- | ------------------------------ | ----------------------------------------------------------------------------------------------------- | ---- |
| title | 버튼의 타이틀                  | string                                                                                                | O    |
| link  | 버튼 클릭시 이동하는 링크 정보 | [`LinkType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#LinkType) | O    |

### `CommerceTemplateType`

| 이름        | 설명                                                                                         | 타입                                                                                                          | 필수 |
| ----------- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ---- |
| content     | 메시지의 메인 콘텐츠 정보                                                                    | [`ContentType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ContentType)   | O    |
| commerce    | 상품에 대한 가격 정보                                                                        | [`CommerceType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#CommerceType) | O    |
| buttonTitle | 기본 버튼 타이틀("자세히 보기")을 변경하고 싶을 때 설정                                      | string                                                                                                        | X    |
| buttons     | 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용.(최대 2개) | [`ButtonType[]`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ButtonType)   | X    |

```ts
try {
  const response = await KakaoShareLink.sendCommerce({
    content: {
      title: 'title',
      imageUrl:
        'http://t1.daumcdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a50476.jpg',
      link: {
        webUrl: 'https://developers.kakao.com/',
        mobileWebUrl: 'https://developers.kakao.com/',
      },
      description: 'description',
    },
    commerce: {
      regularPrice: 100000,
      discountPrice: 20000,
      discountRate: 20,
    },
    buttons: [
      {
        title: '앱에서 보기',
        androidExecutionParams: [{ key: 'key1', value: 'value1' }],
        iosExecutionParams: [
          { key: 'key1', value: 'value1' },
          { key: 'key2', value: 'value2' },
        ],
      },
      {
        title: '웹에서 보기',
        webUrl: 'https://developers.kakao.com/',
        mobileWebUrl: 'https://developers.kakao.com/',
      },
    ],
  });
  console.log(response);
} catch (e) {
  console.error(e);
  console.error(e.message);
}
```

### `ListTemplateType`

| 이름        | 설명                                                                                         | 타입                                                                                                          | 필수 |
| ----------- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ---- |
| headerTitle | 리스트 상단에 노출되는 헤더 타이틀                                                           | string                                                                                                        | O    |
| headerLink  | 헤더 타이틀 내용에 해당하는 링크 정보                                                        | [`LinkType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#LinkType)         | O    |
| contents    | 리스트에 노출되는 콘텐츠 목록. 최소 2개, 최대 3개                                            | [`ContentType[]`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ContentType) | O    |
| buttonTitle | 기본 버튼 타이틀("자세히 보기")을 변경하고 싶을 때 설정                                      | string                                                                                                        | X    |
| buttons     | 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용.(최대 2개) | [`ButtonType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ButtonType)     | X    |

```ts
try {
  const response = await KakaoShareLink.sendList({
    headerTitle: 'headerTitle',
    headerLink: {
      webUrl: 'https://developers.kakao.com/',
      mobileWebUrl: 'https://developers.kakao.com/',
    },
    contents: [
      {
        title: 'title1',
        imageUrl:
          'http://t1.daumcdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a50476.jpg',
        link: {
          webUrl: 'https://developers.kakao.com/',
          mobileWebUrl: 'https://developers.kakao.com/',
        },
        description: 'description1',
      },
      {
        title: 'title2',
        imageUrl:
          'http://t1.daumcdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a50476.jpg',
        link: {
          webUrl: 'https://developers.kakao.com/',
          mobileWebUrl: 'https://developers.kakao.com/',
        },
        description: 'description2',
      },
      {
        title: 'title3',
        imageUrl:
          'http://t1.daumcdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a50476.jpg',
        link: {
          webUrl: 'https://developers.kakao.com/',
          mobileWebUrl: 'https://developers.kakao.com/',
        },
        description: 'description3',
      },
    ],
  });
  console.log(response);
} catch (e) {
  console.error(e);
  console.error(e.message);
}
```

### `LocationTemplateType`

| 이름         | 설명                                                                                                              | 타입                                                                                                        | 필수 |
| ------------ | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ---- |
| content      | 위치에 대해 설명하는 콘텐츠 정보                                                                                  | [`ContentType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ContentType) | O    |
| address      | 공유할 위치의 주소<br /> 예) 경기 성남시 분당구 판교역로 235                                                      | string                                                                                                      | O    |
| addressTitle | 카카오톡 내의 지도 뷰에서 사용되는 타이틀<br /> 예) 카카오판교오피스                                              | string                                                                                                      | X    |
| social       | 메인 콘텐츠의 부가 소셜 정보                                                                                      | [`SocialType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#SocialType)   | X    |
| buttonTitle  | 기본 버튼 타이틀<br />("자세히 보기")을 변경하고 싶을 때 설정                                                     | string                                                                                                      | X    |
| buttons      | 버튼 목록. 기본 버튼의 타이틀 외에 링크도 변경하고 싶을 때 설정. <br />(최대 1개, 오른쪽 "위치 보기" 버튼은 고정) | [`ButtonType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ButtonType)   | X    |

```ts
try {
  const response = await KakaoShareLink.sendLocation({
    address: '경기 성남시 분당구 판교역로',
    addressTitle: '카카오판교오피스',
    content: {
      title: 'title',
      imageUrl:
        'http://t1.daumcdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a50476.jpg',
      link: {
        webUrl: 'https://developers.kakao.com/',
        mobileWebUrl: 'https://developers.kakao.com/',
      },
      description: 'description',
    },
  });
  console.log(response);
} catch (e) {
  console.error(e);
  console.error(e.message);
}
```

### `FeedTemplateType`

| 이름        | 설명                                                                              | 타입                                                                                                        | 필수 |
| ----------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ---- |
| content     | 메시지의 메인 콘텐츠 정보                                                         | [`ContentType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ContentType) | O    |
| social      | 콘텐츠에 대한 소셜 정보                                                           | [`SocialType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#SocialType)   | X    |
| buttonTitle | 기본 버튼 타이틀("자세히 보기")을 변경하고 싶을 때 설정                           | string                                                                                                      | X    |
| buttons     | 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용 | [`ButtonType[]`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ButtonType) | X    |

```ts
try {
  const response = await KakaoShareLink.sendFeed({
    content: {
      title: 'title',
      imageUrl:
        'http://t1.daumcdn.net/friends/prod/editor/dc8b3d02-a15a-4afa-a88b-989cf2a50476.jpg',
      link: {
        webUrl: 'https://developers.kakao.com/',
        mobileWebUrl: 'https://developers.kakao.com/',
      },
      description: 'description',
    },
    social: {
      commentCount: 10,
      likeCount: 5,
    },
    buttons: [
      {
        title: '앱에서 보기',
        androidExecutionParams: [{ key: 'key1', value: 'value1' }],
        iosExecutionParams: [
          { key: 'key1', value: 'value1' },
          { key: 'key2', value: 'value2' },
        ],
      },
    ],
  });
  console.log(response);
} catch (e) {
  console.error(e);
  console.error(e.message);
}
```

### `TextTemplateType`

| 이름        | 설명                                                                                                               | 타입                                                                                                        | 필수 |
| ----------- | ------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- | ---- |
| text        | 최대 200자의 텍스트 정보                                                                                           | string                                                                                                      | O    |
| link        | 해당 컨텐츠 클릭 시 이동 할 링크 정보                                                                              | [`LinkType`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#LinkType)       | O    |
| buttonTitle | 기본 버튼 타이틀<br/>("자세히 보기")을 변경하고 싶을 때 설정                                                       | string                                                                                                      | X    |
| buttons     | 메시지 하단에 추가되는 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용. 최대 2개 | [`ButtonType[]`](https://github.com/millo-L/react-native-kakao-share-link/blob/master/README.md#ButtonType) | X    |

```ts
import KakaoShareLink from 'react-native-kakao-share-link';

// ...
try {
  const response = await KakaoShareLink.sendFeed({
    text: 'text',
    link: {
      webUrl: 'https://developers.kakao.com/',
      mobileWebUrl: 'https://developers.kakao.com/',
    },
  });
  console.log(response);
} catch (e) {
  console.error(e);
  console.error(e.message);
}
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
