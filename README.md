# SwiftCloudKit

[![Version](https://img.shields.io/cocoapods/v/SwiftCloudKit.svg?style=flat)](http://cocoapods.org/pods/SwiftCloudKit)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg)
![iOS 11.0+](https://img.shields.io/badge/iOS-11.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)

独立开发者都会遇到的问题：就是APP总不能一直本地存数据到数据库吧，得请求接口，云端存数据。要是自己会后端开发，搭建个PHP/Java或者Python的服务，可能会有点时间成本，但好在自己都可以控制。如果实力不济，倒也无妨，可以使用第三方的云数据库，也是简单方便。

经过一段时间的使用Severless云服务，做了个对比：

| 名称                                                         | 通用性      | 上手难度                                     | 费用                                                      |
| ------------------------------------------------------------ | ----------- | -------------------------------------------- | --------------------------------------------------------- |
| [LeanCloud](https://www.leancloud.cn)                        | 全平台可用  | 中文文档，简单易用,上手简单                  | 开发版免费，[定价标准](https://www.leancloud.cn/pricing/) |
| iCloud                                                       | 苹果系、web | 教程较少，有一定学习成本，容易上手           | 开发者账号，688                                           |
| [Amplify](https://docs.amplify.aws/lib/auth/signin/q/platform/ios) | 全平台可用  | 新东西，SDK先进，教程少，中等难度            | [定价标准](https://aws.amazon.com/cn/amplify/pricing/)    |
| [Firebase](https://firebase.google.com/?hl=zh-cn)            | 全平台可用  | 谷歌出品，某些文档可能需要穿越火线，中等难度 | [定价标准](https://firebase.google.com/pricing?hl=zh-cn)  |
| 各种云                                                       | 全平台可用  | 自己搭建服务器，如果本身会搭建，会更加容易   | 便宜，参见各种云收费                                      |

鉴于自己不想搭建后端服务的情况，如果是iOS开发，使用OC，倒是建议LeanCloud、iCloud，如果是swift可以使用LeanCloud、iCloud、Amolify。LeanCloud和Amolify都支持全平台，只要接入SDK就可以用了，iCloud倒是单纯的iOS开发十分的好用，封装一下即用。

我自己写了个APP，使用的LeanCloud的开发者免费服务，小众APP倒也足够API请求3万次每天。后来又写了个APP考虑试试iCloud，毕竟已经交费了嘛，不用就白瞎了，所以就封装了这个，方便快速接入使用。

## 安装

### cocoapods

1.在 Podfile 中添加 `pod ‘SwiftCloudKit’`

2.执行 `pod install 或 pod update`

3.导入 `import SwiftCloudKit`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftCloudKit 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Pacakage Dependency`，然后在搜索栏输入

`https://github.com/jackiehu/SwiftCloudKit`，即可完成集成

### 手动集成

SwiftCloudKit 也支持手动集成，只需把Sources文件夹中的SwiftCloudKit文件夹拖进需要集成的项目即可



## 更多砖块工具加速APP开发

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftBrick&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftShow&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftShow)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftLog&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftLog)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftyForm&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftyForm)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftEmptyData&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftEmptyData)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftPageView&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftPageView)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=JHTabBarController&theme=radical&locale=cn)](https://github.com/jackiehu/JHTabBarController)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMesh&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNotification&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNotification)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftButton&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftButton)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftDatePicker&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftDatePicker)
