import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Constants } from '../utils/Constants';
import { Theme } from '../utils/Theme';
import { PreferencesHelper } from '../data/PreferencesHelper';

/**
 * 启动页（文档2 §2.1 / §6.1）
 * 渐变鸿蒙蓝全屏背景 + Logo + 名称 + 副标题 + 底部团队名 + 加载动画。
 * 停留 3 秒后：
 *   - 首次打开（未看过引导页）→ 引导页
 *   - 已登录 → 首页
 *   - 否则 → 登录/注册页
 * 支持点击屏幕任意位置跳过。
 */
@Entry
@Component
struct SplashPage {
  @State opacityValue: number = 0;
  @State scaleValue: number = 0.8;

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.opacityValue = 1;
    this.scaleValue = 1;

    setTimeout(() => {
      this.decideNext();
    }, 3000);
  }

  async decideNext(): Promise<void> {
    const firstOpen = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_FIRST_OPEN, true);
    if (firstOpen) {
      router.replaceUrl({ url: Constants.PAGE_GUIDE });
      return;
    }
    const loggedIn = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_LOGGED_IN, false);
    if (loggedIn) {
      router.replaceUrl({ url: Constants.PAGE_INDEX });
    } else {
      router.replaceUrl({ url: Constants.PAGE_LOGIN });
    }
  }

  build() {
    Column() {
      // 中心区域
      Column() {
        Image($r('app.media.startIcon'))
          .width(120)
          .height(120)
          .borderRadius(24)
          .opacity(this.opacityValue)
          .scale({ x: this.scaleValue, y: this.scaleValue })
          .animation({ duration: 800, curve: Curve.EaseOut })

        Text(Constants.APP_NAME)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor(Theme.WHITE)
          .margin({ top: 24 })
          .opacity(this.opacityValue)
          .animation({ duration: 800, curve: Curve.EaseOut, delay: 200 })

        Text(Constants.APP_SUBTITLE)
          .fontSize(24)
          .fontColor(Theme.WHITE)
          .opacity(0.9)
          .margin({ top: 8 })
          .animation({ duration: 800, curve: Curve.EaseOut, delay: 400 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 底部：开发团队 + 加载动画
      Column() {
        Text('校园助手开发团队')
          .fontSize(22)
          .fontColor(Theme.WHITE)
          .opacity(0.85)
        LoadingProgress()
          .width(48)
          .height(48)
          .color(Theme.WHITE)
          .margin({ top: 12 })
      }
      .margin({ bottom: 60 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [[Theme.PRIMARY, 0.0], [Theme.PRIMARY_LIGHT_END, 1.0]]
    })
    .onClick(() => {
      this.decideNext();
    })
  }
}
