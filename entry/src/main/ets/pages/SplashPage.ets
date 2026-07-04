import { router } from '@kit.ArkUI';
import { Constants } from '../utils/Constants';
import { Theme } from '../utils/Theme';

/**
 * 启动页：停留 3 秒后无条件跳转到登录页
 */
@Entry
@Component
struct SplashPage {
  @State opacityValue: number = 0;
  @State scaleValue: number = 0.8;

  aboutToAppear(): void {
    this.opacityValue = 1;
    this.scaleValue = 1;

    setTimeout(() => {
      router.replaceUrl({ url: 'pages/LoginPage' });
    }, 3000);
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

      // 底部
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
      router.replaceUrl({ url: 'pages/LoginPage' });
    })
  }
}
