import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Constants } from '../../utils/Constants';
import { PreferencesHelper } from '../../data/PreferencesHelper';
import { MockData } from '../../data/MockData';
import { UserInfo } from '../../model/UserModel';
import { Theme, FontSize, Dimens } from '../../utils/Theme';

@Component
export struct ProfilePage {
  @State userInfo: UserInfo = MockData.getDefaultUser();
  @State fontSizeLevel: string = Constants.FONT_SIZE_MEDIUM;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    const saved = await PreferencesHelper.getObject<UserInfo>(this.context, Constants.PREF_KEY_USER_INFO, MockData.getDefaultUser());
    this.userInfo = saved;
    this.fontSizeLevel = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_FONT_SIZE, Constants.FONT_SIZE_MEDIUM);
  }

  async setFontSize(size: string): Promise<void> {
    this.fontSizeLevel = size;
    await PreferencesHelper.putString(this.context, Constants.PREF_KEY_FONT_SIZE, size);
    let scale = 1.0;
    if (size === Constants.FONT_SIZE_SMALL) scale = 0.85;
    else if (size === Constants.FONT_SIZE_LARGE) scale = 1.3;
    AppStorage.setOrCreate('currentFontScale', scale);
  }

  build() {
    Scroll() {
      Column() {
        // 用户信息卡片
        Row() {
          Column() {
            if (this.userInfo.avatarUri) {
              Image(this.userInfo.avatarUri)
                .width(56)
                .height(56)
                .borderRadius(28)
            } else {
              Text('👤')
                .fontSize(36)
            }
          }
          .width(64)
          .height(64)
          .borderRadius(32)
          .backgroundColor(Theme.PRIMARY_BG)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text(this.userInfo.nickname)
              .fontSize(FontSize.LIST_TITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Theme.textColor(this.isDarkMode))
            Text(`${this.userInfo.college} · ${this.userInfo.major}`)
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 14 })
          .layoutWeight(1)

          Text('›')
            .fontSize(20)
            .fontColor(Theme.BORDER)
        }
        .width('100%')
        .padding(20)
        .borderRadius(8)
        .backgroundColor(Theme.cardColor(this.isDarkMode))
        .margin({ left: 16, right: 16, top: 16 })
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_PERSONAL_INFO });
        })

        // 功能列表
        Column() {
          this.menuItem('❤️', '我的收藏', Constants.PAGE_MY_FAVORITES)
          this.menuItem('✅', '我的待办', Constants.PAGE_TODO_MANAGE)
          this.menuItem('📅', '我的课程', Constants.PAGE_COURSE_SCHEDULE)
          this.menuItem('📊', '我的成绩', Constants.PAGE_GRADE_QUERY)
          this.menuItem('🔍', '失物发布', Constants.PAGE_LOST_FOUND_PUBLISH)
          this.menuItemAction('❓', '帮助中心', () => {
            promptAction.showToast({ message: '帮助中心功能开发中', duration: 1500 });
          })
          this.menuItemAction('💬', '意见反馈', () => {
            promptAction.showToast({ message: '感谢您的反馈！', duration: 1500 });
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12 })

        // 内嵌设置模块
        Text('设置')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 8 })

        Column() {
          // 深色模式
          Row() {
            Text('深色模式')
              .fontSize(FontSize.BODY)
              .fontColor(Theme.textColor(this.isDarkMode))
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
              .selectedColor(Theme.PRIMARY)
              .onChange((v: boolean) => {
                AppStorage.setOrCreate('isDarkMode', v);
                const mode = v ? Constants.THEME_DARK : Constants.THEME_LIGHT;
                PreferencesHelper.putString(this.context, Constants.PREF_KEY_THEME, mode);
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .backgroundColor(Theme.cardColor(this.isDarkMode))

          Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })

          // 字体大小
          Row() {
            Text('字体大小')
              .fontSize(FontSize.BODY)
              .fontColor(Theme.textColor(this.isDarkMode))
            Blank()
            Row() {
              Text('小')
                .fontSize(FontSize.TAG)
                .fontColor(this.fontSizeLevel === Constants.FONT_SIZE_SMALL ? Theme.WHITE : Theme.textSecondColor(this.isDarkMode))
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .borderRadius(10)
                .backgroundColor(this.fontSizeLevel === Constants.FONT_SIZE_SMALL ? Theme.PRIMARY : Theme.cardColor(this.isDarkMode))
                .onClick(() => this.setFontSize(Constants.FONT_SIZE_SMALL))
              Text('中')
                .fontSize(FontSize.TAG)
                .fontColor(this.fontSizeLevel === Constants.FONT_SIZE_MEDIUM ? Theme.WHITE : Theme.textSecondColor(this.isDarkMode))
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .borderRadius(10)
                .backgroundColor(this.fontSizeLevel === Constants.FONT_SIZE_MEDIUM ? Theme.PRIMARY : Theme.cardColor(this.isDarkMode))
                .margin({ left: 4 })
                .onClick(() => this.setFontSize(Constants.FONT_SIZE_MEDIUM))
              Text('大')
                .fontSize(FontSize.TAG)
                .fontColor(this.fontSizeLevel === Constants.FONT_SIZE_LARGE ? Theme.WHITE : Theme.textSecondColor(this.isDarkMode))
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .borderRadius(10)
                .backgroundColor(this.fontSizeLevel === Constants.FONT_SIZE_LARGE ? Theme.PRIMARY : Theme.cardColor(this.isDarkMode))
                .margin({ left: 4 })
                .onClick(() => this.setFontSize(Constants.FONT_SIZE_LARGE))
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .backgroundColor(Theme.cardColor(this.isDarkMode))

          Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })

          // 清理缓存
          Row() {
            Text('清理缓存')
              .fontSize(FontSize.BODY)
              .fontColor(Theme.textColor(this.isDarkMode))
            Blank()
            Text('›')
              .fontSize(18)
              .fontColor(Theme.BORDER)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .backgroundColor(Theme.cardColor(this.isDarkMode))
          .onClick(() => {
            promptAction.showToast({ message: '缓存已清理', duration: 1500 });
          })

          Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })

          // 关于
          Row() {
            Text('关于')
              .fontSize(FontSize.BODY)
              .fontColor(Theme.textColor(this.isDarkMode))
            Blank()
            Text('V1.0.0')
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
            Text('›')
              .fontSize(18)
              .fontColor(Theme.BORDER)
              .margin({ left: 8 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .backgroundColor(Theme.cardColor(this.isDarkMode))
        }
        .borderRadius(8)
        .margin({ left: 16, right: 16 })

        // 退出登录
        Button('退出登录')
          .width('100%')
          .height(Dimens.BTN_HEIGHT)
          .fontSize(FontSize.BODY)
          .fontColor(Theme.RED_DOT)
          .backgroundColor(Theme.cardColor(this.isDarkMode))
          .borderRadius(Dimens.RADIUS)
          .margin({ left: 16, right: 16, top: 24 })
          .onClick(() => {
            promptAction.showDialog({
              title: '提示',
              message: '确定退出登录吗？',
              buttons: [
                { text: '取消', color: Theme.TEXT_SECOND },
                { text: '退出', color: Theme.RED_DOT }
              ]
            }).then(() => {
              PreferencesHelper.putBoolean(this.context, Constants.PREF_KEY_LOGGED_IN, false);
              PreferencesHelper.putObject(this.context, Constants.PREF_KEY_USER_INFO, MockData.getDefaultUser());
              router.replaceUrl({ url: Constants.PAGE_LOGIN });
            }).catch(() => {});
          })

        // 底部
        Blank().height(20)
        Text('高校校园助手 V1.0')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
        Text('校园助手开发组')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
          .margin({ top: 4 })
        Text('© 2026 All Rights Reserved')
          .fontSize(FontSize.TAG)
          .fontColor(Theme.TEXT_SECOND)
          .margin({ top: 4, bottom: 30 })
      }
    }
    .scrollBar(BarState.Off)
    .backgroundColor(Theme.bgColor(this.isDarkMode))
  }

  @Builder
  menuItem(icon: string, title: string, page: string) {
    Row() {
      Text(icon)
        .fontSize(22)
      Text(title)
        .fontSize(FontSize.BODY)
        .fontWeight(FontWeight.Medium)
        .fontColor(Theme.textColor(this.isDarkMode))
        .margin({ left: 12 })
      Blank()
      Text('›')
        .fontSize(20)
        .fontColor(Theme.BORDER)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .borderRadius(8)
    .backgroundColor(Theme.cardColor(this.isDarkMode))
    .margin({ bottom: 6 })
    .onClick(() => {
      router.pushUrl({ url: page });
    })
  }

  @Builder
  menuItemAction(icon: string, title: string, action: () => void) {
    Row() {
      Text(icon)
        .fontSize(22)
      Text(title)
        .fontSize(FontSize.BODY)
        .fontWeight(FontWeight.Medium)
        .fontColor(Theme.textColor(this.isDarkMode))
        .margin({ left: 12 })
      Blank()
      Text('›')
        .fontSize(20)
        .fontColor(Theme.BORDER)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .borderRadius(8)
    .backgroundColor(Theme.cardColor(this.isDarkMode))
    .margin({ bottom: 6 })
    .onClick(() => {
      action();
    })
  }
}