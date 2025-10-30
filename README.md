# 老园丁之家 (Home of Elderly Gardeners)

本仓库是一个 Flutter 移动应用原型，目标为老年园艺爱好者提供视频教学、商场购物、学习课程、社区互动与个人中心等功能。

以下 `README` 描述当前已实现的功能、关键文件路径、如何在本地运行与如何继续开发／修改各功能模块的步骤与路径。

---

## 已实现的主要功能（截至当前）

- 注册流程：支持用户在注册页选择“跳过”直接进入主应用（作为访客），跳过会在 `UserProvider` 中写入最小访客信息。
- 底部五栏导航：`首页`、`商场`、`学习中心`、`社区`、`我的`（等分布局、统一样式）。
- 首页（视频）：短视频 + 直播教学的 Tab，已取消爬虫抓取，改为使用 `ApiService.fetchFeaturedVideos()` 返回本地/示例视频并支持下拉刷新。
- 通用搜索占位：视频/学习中心可打开通用搜索页面（占位实现）。
- 学习中心：有购买课程与咨询的占位入口（`pages/learning/learning_page.dart`）。
- 社区：包含用户分享、提问入口以及“赛博种树”小游戏占位（`pages/community/*`）。
- 我的：个人资料、我的发布、观看历史、我的订单、我的店铺与设置；`设置`页含“联系客服”弹窗，显示两个邮箱并支持复制。
- 订单页：在 AppBar 右上角添加图片按钮，点击显示本地 asset 中的二维码 `assets/icon/QR_code.png`（`order_image_page.dart`）。

---

## 项目结构（关键文件与说明）

- `lib/main.dart` — 应用入口；常驻 Providers（`ThemeProvider`、`UserProvider`、`CartProvider`）；路由注册。
- `lib/pages/main/main_page.dart` — 底部导航实现（五栏）。
- `lib/pages/video/video_page.dart` — 视频首页（短视频/直播），现在从 `ApiService.fetchFeaturedVideos()` 加载视频列表。
- `lib/services/api_service.dart` — API 层；包含 `fetchFeaturedVideos()`、`fetchVideosFromScraper()`（现已不用于首页视频）。
- `lib/providers/user_provider.dart` — 简单的用户状态管理（访客或登录用户）。
- `lib/pages/auth/register_page.dart` — 注册页，包含“跳过”功能。
- `lib/pages/profile/*` — 我的页面以及子页面：`profile_detail_page.dart`、`my_videos_page.dart`、`watch_history_page.dart`、`my_shop_page.dart`、`settings_page.dart` 等。
- `lib/pages/shopping/order_page.dart` — 我的订单（含右上图片按钮）。
- `lib/pages/shopping/order_image_page.dart` — 展示订单图片（使用 asset `assets/icon/QR_code.png`）。
- `lib/pages/community/*` — 社区与小游戏占位页面。
- `lib/pages/learning/learning_page.dart` — 学习中心占位页面。
- `lib/pages/common/search_page.dart` — 通用搜索占位页。
- `pubspec.yaml` — 依赖与 asset 注册（已注册 `assets/icon/QR_code.png`）。

---

## 如何在本地运行

确保你本地安装并配置了 Flutter 环境（推荐 Flutter >=2.10 / Dart >=2.18 兼容）。

在项目根目录执行：

```bash
flutter pub get
flutter clean
flutter run
```

如果你在 Android 模拟器中运行并且需要访问宿主机器服务（如某些后端），请注意网络地址（例如 10.0.2.2）。

---

## 资源（assets）注意事项

- 本项目使用 `assets/icon/QR_code.png` 在订单图片页面展示二维码。请确认该文件存在于项目路径 `assets/icon/QR_code.png`。
- 若添加其他资源，请在 `pubspec.yaml` 的 `flutter.assets` 下注册路径，然后运行 `flutter pub get`。

---

## 常见开发修改场景与对应路径

1. 修改“跳过注册”逻辑
   - 文件：`lib/pages/auth/register_page.dart`
   - 说明：`_skipRegister()` 中创建访客 `User` 并调用 `UserProvider.setUser()`；如需持久化或创建临时 token，请在 `services/storage_service.dart` 或 `auth_service.dart` 中扩展。

2. 修改底部导航（添加/调整栏目）
   - 文件：`lib/pages/main/main_page.dart`
   - 说明：更新 `_pages` 列表以及 `BottomNavigationBarItem`，并确保对应页面存在。

3. 更改首页视频来源（取消爬虫）
   - 文件：`lib/pages/video/video_page.dart`、`lib/services/api_service.dart`
   - 说明：目前 `VideoListPage` 使用 `ApiService.fetchFeaturedVideos()`；要接后端请在 `ApiService` 中实现真实接口（例如 `GET {AppConstants.baseUrl}/videos/featured`），并在 `VideoListPage` 处替换。可考虑实现 `VideoProvider` 以集中管理视频数据与缓存。

4. 商场（商品、二手、商家）
   - 相关路径：`lib/pages/shopping/`、`lib/models/product_model.dart`、`lib/providers/cart_provider.dart`
   - 说明：建议创建 `product_model` 扩展字段（isSecondHand、sellerId 等），并在 `pages/shopping/*` 中添加筛选与商家入口。下单逻辑与购物车在 `cart_provider.dart`。

5. 学习中心（课程购买 / 咨询）
   - 文件：`lib/pages/learning/learning_page.dart`
   - 说明：目前是占位，建议新增 `models/course_model.dart`、课程详情页与购买流程（可复用购物流程或单独接入支付）。

6. 我的页面（发布、订单、店铺）
   - 文件：`lib/pages/profile/*`、`lib/pages/shopping/order_page.dart`
   - 说明：`MyVideosPage` / `WatchHistoryPage` 为占位。要显示真实数据，接入 `UserProvider` 与后端 API（或本地 `storage_service`）来获取用户发布与观看记录。

7. 客服邮箱与设置
   - 文件：`lib/pages/profile/settings_page.dart`（已实现弹窗显示两个邮箱并支持复制）。

8. 订单图片
   - 文件：`lib/pages/shopping/order_image_page.dart`（现在使用 `Image.asset('assets/icon/QR_code.png')`）。如需动态加载订单图片，请在 `OrderPage` 中传入图片 URL 并在 `OrderImagePage` 使用 `Image.network` 或 `Image.file`。

---

## 代码风格与测试建议

- 推荐使用 `provider` 管理简单状态（当前项目已有 `UserProvider`、`CartProvider`、`ThemeProvider`）。
- 建议为关键页面写 2-3 个 widget 测试（例如：`RegisterPage` 跳过后导航、`MainPage` 底部导航切换、`VideoListPage` 列表渲染）。

运行测试：

```bash
flutter test
```

---

## 后续优先开发建议（可作为迭代计划）

1. 商城完整化：商品模型、分类、商家中心、二手市场、支付与订单管理。
2. 学习中心：课程数据模型、购买/付费流程、咨询(聊天)功能。
3. 社区交互：发布/评论/点赞、搜索、问题广场、举报与内容审核策略。
4. 用户体验：离线缓存、播放历史同步、视频缓存与预加载、Accessibility（无障碍）优化。
5. 测试覆盖：添加关键路径的单元与集成测试并在 CI 中运行。

---

如果你希望我把 `README.md` 的某一部分扩展为更详细的开发指南（比如把“商场整合”扩展为具体的接口定义和数据库/后端契约），告诉我优先项和你想要的细节级别，我会接着写出具体改动计划与演示代码片段。

谢谢！
# home_of_elderly_gardeners

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
