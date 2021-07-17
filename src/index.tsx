import { NativeModules } from 'react-native';
const { KakaoShareLink } = NativeModules;

export declare type ContentType = {
  title: string;
  imageUrl: string;
  link: LinkType;
  description?: string;
  imageWidth?: number;
  imageHeight?: number;
};

export declare type ExecutionParamType = {
  key: string;
  value: string;
};

export declare type LinkType = {
  webUrl: string;
  mobileWebUrl: string;
  iosExecutionParams?: ExecutionParamType[];
  androidExecutionParams?: ExecutionParamType[];
};

export declare type CommerceType = {
  regularPrice: number;
  discountPrice?: number;
  discountRate?: number;
  fixedDiscountPrice?: number;
  productName?: string;
};

export declare type ButtonType = {
  title: string;
  link: LinkType;
};

export declare type SocialType = {
  commentCount?: number;
  likeCount?: number;
  sharedCount?: number;
  subscriberCount?: number;
  viewCount?: number;
};

export declare type SendResultType = {
  result: boolean;
  intent?: string;
  warning?: string;
  argument?: string;
  callback?: string;
};

export declare type CallbackType = (
  error?: Error,
  result?: SendResultType
) => void;

export declare type CommerceTemplateType = {
  content: ContentType;
  commerce: CommerceType;
  buttons?: ButtonType[];
  buttonTitle?: String;
};

export declare type ListTemplateType = {
  headerTitle: string;
  headerLink: LinkType;
  contents: ContentType[];
  buttons?: ButtonType[];
  buttonTitle?: string;
};

export declare type FeedTemplateType = {
  content: ContentType;
  social?: SocialType;
  buttons?: ButtonType[];
  buttonTitle?: String;
};

export declare type LocationTemplateType = {
  address: string;
  addressTitle?: string;
  content: ContentType;
  social?: SocialType;
  buttons?: ButtonType[];
  buttonTitle?: string;
};

export declare type TextTemplateType = {
  text: string;
  link: LinkType;
  buttons?: ButtonType[];
  buttonTitle?: string;
};

/**
 * sendCommerce
 * @param {CommerceTemplateType} commerceTemplate CommerceTemplate Item
 * @param {CallbackType} [callback] callback function
 * @returns {Promise<SendResultType>}
 */
export const sendCommerce = (
  commerceTemplate: CommerceTemplateType,
  callback?: CallbackType
): Promise<SendResultType> => {
  return KakaoShareLink.sendCommerce(commerceTemplate)
    .then((result: SendResultType) => {
      if (callback && typeof callback === 'function') {
        callback(undefined, result);
      }
      return result;
    })
    .catch((error: Error) => {
      if (callback && typeof callback === 'function') {
        callback(error, undefined);
      }
      throw error;
    });
};
/**
 * sendList
 * @param {ListTemplateType} listTemplate ListTemplate Item
 * @param {CallbackType} [callback] callback function
 * @returns {Promise<SendResultType>}
 */
export const sendList = (
  listTemplate: ListTemplateType,
  callback?: CallbackType
): Promise<SendResultType> => {
  return KakaoShareLink.sendList(listTemplate)
    .then((result: SendResultType) => {
      if (callback && typeof callback === 'function') {
        callback(undefined, result);
      }
      return result;
    })
    .catch((error: Error) => {
      if (callback && typeof callback === 'function') {
        callback(error, undefined);
      }
      throw error;
    });
};
/**
 * sendFeed
 * @param {FeedTemplateType} feedTemplate FeedTemplate Item
 * @param {CallbackType} [callback] callback function
 * @returns {Promise<SendResultType>}
 */
export const sendFeed = (
  feedTemplate: FeedTemplateType,
  callback?: CallbackType
): Promise<SendResultType> => {
  return KakaoShareLink.sendFeed(feedTemplate)
    .then((result: SendResultType) => {
      if (callback && typeof callback === 'function') {
        callback(undefined, result);
      }
      return result;
    })
    .catch((error: Error) => {
      if (callback && typeof callback === 'function') {
        callback(error, undefined);
      }
      throw error;
    });
};
/**
 * sendText
 * @param {TextTemplateType} textTemplate TextTemplate Item
 * @param {CallbackType} [callback] callback function
 * @returns {Promise<SendResultType>}
 */
export const sendText = (
  textTemplate: TextTemplateType,
  callback?: CallbackType
): Promise<SendResultType> => {
  return KakaoShareLink.sendText(textTemplate)
    .then((result: SendResultType) => {
      if (callback && typeof callback === 'function') {
        callback(undefined, result);
      }
      return result;
    })
    .catch((error: Error) => {
      if (callback && typeof callback === 'function') {
        callback(error, undefined);
      }
      throw error;
    });
};
/**
 * sendLocation
 * @param {LocationTemplateType} locationTemplate LocationTemplate Item
 * @param {CallbackType} [callback] callback function
 * @returns {Promise<SendResultType>}
 */
export const sendLocation = (
  locationTemplate: LocationTemplateType,
  callback?: CallbackType
): Promise<SendResultType> => {
  return KakaoShareLink.sendLocation(locationTemplate)
    .then((result: SendResultType) => {
      if (callback && typeof callback === 'function') {
        callback(undefined, result);
      }
      return result;
    })
    .catch((error: Error) => {
      if (callback && typeof callback === 'function') {
        callback(error, undefined);
      }
      throw error;
    });
};

export declare type KakaoShareLinkType = {
  sendCommerce: typeof sendCommerce;
  sendList: typeof sendList;
  sendFeed: typeof sendFeed;
  sendText: typeof sendText;
  sendLocation: typeof sendLocation;
};

export default KakaoShareLink as KakaoShareLinkType;
