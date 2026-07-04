import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Constants } from '../utils/Constants';
import { Theme, FontSize, Dimens } from '../utils/Theme';
import { PreferencesHelper } from '../data/PreferencesHelper';

class GuideSlide {
  title: string;
  desc: string;
  icon: string;

  constructor(title: string, desc: string, icon: string) {
    this.title = title;
    this.desc = desc;
    this.icon = icon;
  }
}

/**
 * 引导页（首次打开 APP 显示）
 * 文档2 §2.2：3 页左右滑动，上 60% 引导图区，下 40% 标题+说明+页码指示器，
 * 第三页含「立即进入」按钮，点击跳转登录/注册页。
 */
@Entry
@Component
struct GuidePage {
  @State currentIndex: number = 0;

  private slides: GuideSlide[] = [
    new GuideSlide('校园信息，实时掌握', '校园公告、资讯、地图，一手了解校园动态', '🏫'),
    new GuideSlide('学习助手，高效备考', '课程表、成绩查询、图书馆检索，助力学业提升', '📚'),
    new GuideSlide('生活服务，贴心相伴', '失物招领、校园美食、音乐播放，丰富校园生活', '🍜'),
  ];

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  enterApp(): void {
    // 标记已看过引导页
    PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_FIRST_OPEN, false);
    router.replaceUrl({ url: Constants.PAGE_LOGIN });
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.slides, (slide: GuideSlide, idx: number) => {
          Column() {
            // 上 60%：引导图区
            Column() {
              Text(slide.icon)
                .fontSize(120)
            }
            .width('100%')
            .layoutWeight(6)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Theme.PRIMARY_BG)

            // 下 40%：标题 + 说明
            Column() {
              Text(slide.title)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor(Theme.PRIMARY)
              Text(slide.desc)
                .fontSize(FontSize.BODY)
                .fontColor(Theme.TEXT_PRIMARY)
                .lineHeight(24)
                .textAlign(TextAlign.Center)
                .margin({ top: 16, left: 32, right: 32 })
            }
            .width('100%')
            .layoutWeight(4)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .height('100%')
          .backgroundColor(Theme.BG)
        })
      }
      .width('100%')
      .layoutWeight(1)
      .index(this.currentIndex)
      .indicator(false) // 自定义页码指示器
      .loop(false)
      .duration(400)
      .onChange((index: number) => {
        this.currentIndex = index;
      })

      // 底部：页码指示器 + 进入按钮
      Column() {
        Row() {
          ForEach(this.slides, (slide: GuideSlide, idx: number) => {
            Circle()
              .width(this.currentIndex === idx ? 24 : 8)
              .height(8)
              .fill(this.currentIndex === idx ? Theme.PRIMARY : Theme.BORDER)
              .margin({ left: idx === 0 ? 0 : 8 })
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 16, bottom: 16 })

        if (this.currentIndex === this.slides.length - 1) {
          Button('立即进入')
            .width('80%')
            .height(Dimens.BTN_HEIGHT)
            .fontSize(FontSize.BODY)
            .fontColor(Theme.WHITE)
            .backgroundColor(Theme.PRIMARY)
            .borderRadius(Dimens.RADIUS)
            .margin({ bottom: 40 })
            .onClick(() => this.enterApp())
        } else {
          Blank().height(Dimens.BTN_HEIGHT + 40)
        }
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BG)
  }
}
