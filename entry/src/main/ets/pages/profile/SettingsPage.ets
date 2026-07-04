import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { PreferencesHelper } from '../../data/PreferencesHelper';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';

class FontSizeOption {
  label: string;
  value: string;

  constructor(label: string, value: string) {
    this.label = label;
    this.value = value;
  }
}

@Entry
@Component
struct SettingsPage {
  @State themeMode: string = Constants.THEME_LIGHT;
  @State fontSize: string = Constants.FONT_SIZE_MEDIUM;
  @State notifyCourse: boolean = true;
  @State notifyAnnouncement: boolean = true;
  @State notifyTodo: boolean = true;
  @State cacheSize: string = '12.5 MB';

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadSettings();
  }

  async loadSettings(): Promise<void> {
    this.themeMode = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_THEME, Constants.THEME_LIGHT);
    this.fontSize = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_FONT_SIZE, Constants.FONT_SIZE_MEDIUM);
    this.notifyCourse = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_NOTIFY_COURSE, true);
    this.notifyAnnouncement = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_NOTIFY_ANNOUNCEMENT, true);
    this.notifyTodo = await PreferencesHelper.getBoolean(this.context, Constants.PREF_KEY_NOTIFY_TODO, true);
  }

  async setTheme(mode: string): Promise<void> {
    this.themeMode = mode;
    await PreferencesHelper.putString(this.context, Constants.PREF_KEY_THEME, mode);
    AppStorage.setOrCreate('isDarkMode', mode === Constants.THEME_DARK);
  }

  async setFontSize(size: string): Promise<void> {
    this.fontSize = size;
    await PreferencesHelper.putString(this.context, Constants.PREF_KEY_FONT_SIZE, size);
    let scale = 1.0;
    if (size === Constants.FONT_SIZE_SMALL) scale = 0.85;
    else if (size === Constants.FONT_SIZE_LARGE) scale = 1.3;
    AppStorage.setOrCreate('currentFontScale', scale);
  }

  async toggleNotify(key: string, value: boolean): Promise<void> {
    await PreferencesHelper.putBoolean(this.context, key, value);
  }

  clearCache(): void {
    promptAction.showToast({ message: '缓存已清理', duration: 1500 });
    this.cacheSize = '0 MB';
  }

  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('应用设置')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      Scroll() {
        Column() {
          // 通用设置
          Text('通用设置')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .width('100%')
            .padding({ left: 16, top: 16, bottom: 8 })

          Column() {
            // 主题切换
            Row() {
              Text('主题模式')
                .fontSize(FontSize.BODY)
                .fontColor(Theme.TEXT_PRIMARY)
              Blank()
              Row() {
                Text('浅色')
                  .fontSize(FontSize.CAPTION)
                  .fontColor(this.themeMode === Constants.THEME_LIGHT ? Theme.WHITE : Theme.TEXT_SECOND)
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(10)
                  .backgroundColor(this.themeMode === Constants.THEME_LIGHT ? Theme.PRIMARY : Theme.BG)
                  .onClick(() => this.setTheme(Constants.THEME_LIGHT))
                Text('深色')
                  .fontSize(FontSize.CAPTION)
                  .fontColor(this.themeMode === Constants.THEME_DARK ? Theme.WHITE : Theme.TEXT_SECOND)
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(10)
                  .backgroundColor(this.themeMode === Constants.THEME_DARK ? Theme.PRIMARY : Theme.BG)
                  .margin({ left: 8 })
                  .onClick(() => this.setTheme(Constants.THEME_DARK))
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 14, bottom: 14 })
            .backgroundColor(Theme.CARD)

            Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })

            // 字体大小
            Row() {
              Text('字体大小')
                .fontSize(FontSize.BODY)
                .fontColor(Theme.TEXT_PRIMARY)
              Blank()
              Row() {
                ForEach([
                  new FontSizeOption('小', Constants.FONT_SIZE_SMALL),
                  new FontSizeOption('中', Constants.FONT_SIZE_MEDIUM),
                  new FontSizeOption('大', Constants.FONT_SIZE_LARGE)
                ], (item: FontSizeOption) => {
                  Text(item.label)
                    .fontSize(FontSize.CAPTION)
                    .fontColor(this.fontSize === item.value ? Theme.WHITE : Theme.TEXT_SECOND)
                    .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                    .borderRadius(10)
                    .backgroundColor(this.fontSize === item.value ? Theme.PRIMARY : Theme.BG)
                    .margin({ left: 4 })
                    .onClick(() => this.setFontSize(item.value))
                })
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 14, bottom: 14 })
            .backgroundColor(Theme.CARD)
          }
          .borderRadius(8)
          .margin({ left: 16, right: 16 })

          // 通知设置
          Text('通知设置')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .width('100%')
            .padding({ left: 16, top: 20, bottom: 8 })

          Column() {
            this.toggleRow('课程提醒', this.notifyCourse, (v: boolean) => {
              this.notifyCourse = v;
              this.toggleNotify(Constants.PREF_KEY_NOTIFY_COURSE, v);
            })
            Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })
            this.toggleRow('公告提醒', this.notifyAnnouncement, (v: boolean) => {
              this.notifyAnnouncement = v;
              this.toggleNotify(Constants.PREF_KEY_NOTIFY_ANNOUNCEMENT, v);
            })
            Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })
            this.toggleRow('待办提醒', this.notifyTodo, (v: boolean) => {
              this.notifyTodo = v;
              this.toggleNotify(Constants.PREF_KEY_NOTIFY_TODO, v);
            })
          }
          .borderRadius(8)
          .margin({ left: 16, right: 16 })

          // 清理缓存
          Text('数据管理')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .width('100%')
            .padding({ left: 16, top: 20, bottom: 8 })

          Row() {
            Text('清理缓存')
              .fontSize(FontSize.BODY)
              .fontColor(Theme.TEXT_PRIMARY)
            Blank()
            Text(this.cacheSize)
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
              .margin({ right: 8 })
            Text('›')
              .fontSize(18)
              .fontColor(Theme.BORDER)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 14, bottom: 14 })
          .borderRadius(8)
          .backgroundColor(Theme.CARD)
          .margin({ left: 16, right: 16 })
          .onClick(() => this.clearCache())

          // 关于我们
          Text('关于')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .width('100%')
            .padding({ left: 16, top: 20, bottom: 8 })

          Column() {
            this.infoRow('应用版本', 'V1.0.0')
            Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })
            this.infoRow('开发团队', '校园助手开发组')
            Divider().strokeWidth(0.5).color(Theme.BORDER).margin({ left: 16 })
            this.infoRow('课程相关', 'HarmonyOS应用开发课程设计')
          }
          .borderRadius(8)
          .margin({ left: 16, right: 16 })

          Blank().height(30)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor(Theme.BG)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  toggleRow(label: string, value: boolean, onChange: (v: boolean) => void) {
    Row() {
      Text(label)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_PRIMARY)
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: value })
        .selectedColor(Theme.PRIMARY)
        .onChange(onChange)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Theme.CARD)
  }

  @Builder
  infoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.TEXT_PRIMARY)
      Blank()
      Text(value)
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.TEXT_SECOND)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Theme.CARD)
  }
}
