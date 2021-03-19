# SwiftCloudKit

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

