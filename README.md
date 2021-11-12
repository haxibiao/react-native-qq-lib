# react-native-qq-lib

[![npm version](https://badge.fury.io/js/react-native-qq-lib.svg?v=3.0.5)](https://badge.fury.io/js/react-native-qq-lib)

React Native bridging library that integrates QQ SDKs. QQ 登陆 分享，集成 QQ SDK react-native 版本需要 0.40.0 及以上

## 前言

首先向各位声明，本库是在 [react-native-qq](https://github.com/reactnativecn/react-native-qq) 基础上进行重写。  

本身是维护给自己使用的，考虑到自身使用和其它开发者的需要，最终决定开一个新仓库，提供给新项目使用。  

最后，感谢 [lvbingru](https://github.com/lvbingru)，[tdzl2003](https://github.com/tdzl2003) 和各位开发者为 react-native-qq 做出的贡献。

### 集成 QQ SDK 包版本

> Android SDK 版本：v3.5.4.11（2021-04-27）

> IOS SDK 版本：v3.3.9（2020-04-27）

## 如何安装

### 首先安装 npm 包

```bash
yarn add github:haxibiao/react-native-qq-lib
```

或

```bash
npm install -D github:haxibiao/react-native-qq-lib
```

然后执行

```bash
cd ios && pod install && cd ..
```

### 安装 iOS 工程

在工程 plist 文件中加入 qq 白名单：(ios9 以上必须)
请以文本方式打开 Info.plist，在其中添加

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <!-- QQ、Qzone URL Scheme 白名单-->
    <string>mqqapi</string>
    <string>mqq</string>
    <string>mqqOpensdkSSoLogin</string>
    <string>mqqconnect</string>
    <string>mqqopensdkdataline</string>
    <string>mqqopensdkgrouptribeshare</string>
    <string>mqqopensdkfriend</string>
    <string>mqqopensdkapi</string>
    <string>mqqopensdkapiV2</string>
    <string>mqqopensdkapiV3</string>
    <string>mqzoneopensdk</string>
    <string>wtloginmqq</string>
    <string>wtloginmqq2</string>
    <string>mqqwpa</string>
    <string>mqzone</string>
    <string>mqzonev2</string>
    <string>mqzoneshare</string>
    <string>wtloginqzone</string>
    <string>mqzonewx</string>
    <string>mqzoneopensdkapiV2</string>
    <string>mqzoneopensdkapi19</string>
    <string>mqzoneopensdkapi</string>
    <string>mqzoneopensdk</string>
 </array>
```

在`Info->URL Types` 中增加 QQ 的 scheme： `Identifier` 设置为`qq`, `URL Schemes` 设置为你注册的 QQ 开发者账号中的 APPID，需要加前缀`tencent`，例如`tencent1104903684`

在你工程的`AppDelegate.m`文件中添加如下代码：

```
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  if ([TencentOAuth CanHandleOpenURL:url]) {
    return [TencentOAuth HandleOpenURL:url];
  }
  return  YES;
}

- (BOOL)application:(UIApplication *)application
  continueUserActivity:(NSUserActivity *)userActivity
  restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable
  restorableObjects))restorationHandler {
  // 触发回调方法
  [RCTLinkingManager application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
  NSURL *url = userActivity.webpageURL;
  if (url && [TencentOAuth CanHandleUniversalLink:url]) {
    return [TencentOAuth HandleUniversalLink:url];
  }
  return YES;
}

```

### 安装 Android 工程

在`android/app/build.gradle`里，defaultConfig 栏目下添加如下代码：

```
manifestPlaceholders = [
    QQ_APPID: "<平台申请的APPID>"
]
```

以后如果需要修改 APPID，只需要修改此一处。

## 如何使用

### 引入包

```
import * as QQAPI from 'react-native-qq-lib';
```

### API

#### QQAPI.init()

初始化，调用其他api时请先调用该api（3.1.0以前版本无需调用此方法,会自动初始化）


#### QQAPI.login([scopes])

- scopes: 登录所申请的权限，默认为 get_simple_userinfo。 需要多个权限时，以逗号分隔。

调用 QQ 登录，可能会跳转到 QQ 应用或者打开一个网页浏览器以供用户登录。在本次 login 返回前，所有接下来的 login 调用都会直接失败。

返回一个`Promise`对象。成功时的回调为一个类似这样的对象：

```javascript
{
	"access_token": "CAF0085A2AB8FDE7903C97F4792ECBC3",
	"openid": "0E00BA738F6BB55731A5BBC59746E88D"
	"expires_in": "1458208143094.6"
	"oauth_consumer_key": "12345"
}
```

#### QQAPI.shareToQQ(data)

分享到 QQ 好友，参数同 QQAPI.shareToQzone，返回一个`Promise`对象

#### QQAPI.shareToQzone(data)

分享到 QZone，参数为一个 object，可以有如下的形式：

```javascript
// 分享图文消息
{
	type: 'news',
	title: 分享标题,
	description: 描述,
	webpageUrl: 网页地址,
	imageUrl: 远程图片地址,
}

// 分享文本消息
{
	type: 'text',
	text: 分享内容,
}

// 分享图片
// By：这里的 imageUrl 和 imageLocalUrl 都要传而且保持一致（别问我为啥埋这个坑，问就是腾讯的 SDK 这样搞的）
// 支持的路径如：  file://      content://     /data/user/0/com.xxxxx/cache/
{
    type: 'image',
    imageUrl: 图片路径,
    imageLocalUrl: 图片路径,
}


// 其余格式尚未实现。
```

图片路径不支持 http 和 https 网络地址（网络地址的先自己下载图片，这里推荐[rn-fetch-blob](https://github.com/joltup/rn-fetch-blob#readme)库）。

```
import RNFetchBlob from 'rn-fetch-blob';


const _image = 图片地址或路径;

if (RegExp(/http:\/\//).exec(_image) || RegExp(/https:\/\//).exec(_image)) {
  // 判断是网络地址的话先下载图片，然后再分享图片

  RNFetchBlob.config({
    fileCache: true,
    appendExt: "png",
  })
    .fetch("GET", _image)
    .then((res) => {
      const qq = QQAPI.shareToQzone({
        type: "image",
        imageUrl: res.path(),
        imageLocalUrl: res.path(),
      });
      qq.then(() => {
        __onSucceed();
      }).catch(() => {
      });
    })
    .catch((error) => {
    });
} else {
  const qq = QQAPI.shareToQzone({
    type: "image",
    imageUrl: _image,
    imageLocalUrl: _image,
  });
  qq.then(() => {
  }).catch(() => {
  });
}

```


## 常见问题

#### Android: 调用 QQAPI.login()没有反应

通常出现这个原因是因为 Manifest 没有配置好，检查 Manifest 中有关 Activity 的配置。

#### Android: 已经成功激活 QQ 登录，但回调没有被执行

通常出现这个原因是因为 MainActivity.java 中缺少 onActivityResult 的调用。

#### Android: 应用商店检测到未授权前获取隐私信息

出现这个原因是因为sdk在同意隐私政策之前就自动初始化了，目前3.1.0版本已将初始化api暴露，取消了自动初始化，可在RN端自由调整初始化时机。
