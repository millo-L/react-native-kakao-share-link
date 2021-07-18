import React from 'react';
import KakaoShareLink from 'react-native-kakao-share-link';
import {StyleSheet, View, Text, TouchableOpacity} from 'react-native';

const App = () => {
  const sendCommerce = async () => {
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
          discountPrice: 80000,
          discountRate: 20,
        },
        buttons: [
          {
            title: '웹에서 보기',
            link: {
              webUrl: 'https://developers.kakao.com/',
              mobileWebUrl: 'https://developers.kakao.com/',
            },
          },
        ],
      });
      console.log(response);
    } catch (e) {
      console.error(e);
      console.error(e.message);
    }
  };

  const sendList = async () => {
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
  };

  const sendFeed = async () => {
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
            link: {
              androidExecutionParams: [{key: 'key1', value: 'value1'}],
              iosExecutionParams: [
                {key: 'key1', value: 'value1'},
                {key: 'key2', value: 'value2'},
              ],
            },
          },
        ],
      });
      console.log(response);
    } catch (e) {
      console.error(e);
      console.error(e.message);
    }
  };

  const sendLocation = async () => {
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
  };

  const sendText = async () => {
    try {
      const response = await KakaoShareLink.sendText({
        text: 'text',
        link: {
          webUrl: 'https://developers.kakao.com/',
          mobileWebUrl: 'https://developers.kakao.com/',
        },
        buttons: [
          {
            title: '앱에서 보기',
            link: {
              androidExecutionParams: [{key: 'key1', value: 'value1'}],
              iosExecutionParams: [
                {key: 'key1', value: 'value1'},
                {key: 'key2', value: 'value2'},
              ],
            },
          },
        ],
      });
      console.log(response);
    } catch (e) {
      console.error(e);
      console.error(e.message);
    }
  };

  return (
    <View style={styles.screen}>
      <TouchableOpacity style={styles.box} onPress={sendCommerce}>
        <Text>커머스 링크</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.box} onPress={sendList}>
        <Text>리스트 링크</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.box} onPress={sendFeed}>
        <Text>피드 링크</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.box} onPress={sendLocation}>
        <Text>위치 링크</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.box} onPress={sendText}>
        <Text>텍스트 링크</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: 'white',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 30,
  },
  box: {
    width: '100%',
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    marginVertical: 10,
  },
});

export default App;
