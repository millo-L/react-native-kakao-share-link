#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(KakaoShareLink, NSObject)

RCT_EXTERN_METHOD(sendCommerce:(NSDictionary *)dict withResolver:(RCTPromiseResolveBlock *)resolve withRejecter:(RCTPromiseRejectBlock *)reject)
RCT_EXTERN_METHOD(sendList:(NSDictionary *)dict withResolver:(RCTPromiseResolveBlock *)resolve withRejecter:(RCTPromiseRejectBlock *)reject)
RCT_EXTERN_METHOD(sendFeed:(NSDictionary *)dict withResolver:(RCTPromiseResolveBlock *)resolve withRejecter:(RCTPromiseRejectBlock *)reject)
RCT_EXTERN_METHOD(sendLocation:(NSDictionary *)dict withResolver:(RCTPromiseResolveBlock *)resolve withRejecter:(RCTPromiseRejectBlock *)reject)
RCT_EXTERN_METHOD(sendText:(NSDictionary *)dict withResolver:(RCTPromiseResolveBlock *)resolve withRejecter:(RCTPromiseRejectBlock *)reject)
RCT_EXTERN_METHOD(sendCustom:(NSDictionary *)dict withResolver:(RCTPromiseResolveBlock *)resolve withRejecter:(RCTPromiseRejectBlock *)reject)
@end
