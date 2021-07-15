import { NativeModules } from 'react-native';

type KakaoShareLinkType = {
  multiply(a: number, b: number): Promise<number>;
};

const { KakaoShareLink } = NativeModules;

export default KakaoShareLink as KakaoShareLinkType;
