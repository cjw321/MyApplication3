import { Constants } from '../utils/Constants';
import { Theme } from '../utils/Theme';
import { common } from '@kit.AbilityKit';
import { PreferencesHelper } from '../data/PreferencesHelper';
import { HomePage } from './home/HomePage';
import { CampusInfoPage } from './campus/CampusInfoPage';
import { StudyHomePage } from './study/StudyHomePage';
import { LifeServicePage } from './life/LifeServicePage';
import { ProfilePage } from './profile/ProfilePage';

@Entry
@Component
struct Index {
  @State currentTab: number = Constants.TAB_HOME;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;
  @State fontSizeLevel: string = Constants.FONT_SIZE_MEDIUM;
  @StorageLink('currentFontScale') fontScale: number = 1.0;

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadSettings();
  }

  async loadSettings(): Promise<void> {
    const theme = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_THEME, Constants.THEME_LIGHT);
    AppStorage.setOrCreate('isDarkMode', theme === Constants.THEME_DARK);
    const fontSize = await PreferencesHelper.getString(this.context, Constants.PREF_KEY_FONT_SIZE, Constants.FONT_SIZE_MEDIUM);
    this.fontSizeLevel = fontSize;
    this.updateFontScale();
  }

  updateFontScale(): void {
    switch (this.fontSizeLevel) {
      case Constants.FONT_SIZE_SMALL:
        AppStorage.setOrCreate('currentFontScale', 0.85);
        break;
      case Constants.FONT_SIZE_LARGE:
        AppStorage.setOrCreate('currentFontScale', 1.3);
        break;
      default:
        AppStorage.setOrCreate('currentFontScale', 1.0);
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentTab }) {
        TabContent() {
          HomePage()
        }.tabBar(this.tabBarBuilder(0, '首页', $r('sys.symbol.ohos_star')))

        TabContent() {
          CampusInfoPage()
        }.tabBar(this.tabBarBuilder(1, '校园', $r('sys.symbol.school')))

        TabContent() {
          StudyHomePage()
        }.tabBar(this.tabBarBuilder(2, '学习', $r('sys.symbol.bookmark')))

        TabContent() {
          LifeServicePage()
        }.tabBar(this.tabBarBuilder(3, '生活', $r('sys.symbol.heart')))

        TabContent() {
          ProfilePage()
        }.tabBar(this.tabBarBuilder(4, '我的', $r('sys.symbol.circle')))
      }
      .barHeight(56)
      .barWidth('100%')
      .barBackgroundColor(this.isDarkMode ? Theme.CARD_DARK : Theme.CARD)
      .animationDuration(200)
      .onChange((index: number) => {
        this.currentTab = index;
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? Theme.BG_DARK : Theme.BG)
  }

  @Builder
  tabBarBuilder(index: number, title: string, icon: Resource) {
    Column() {
      SymbolGlyph(icon)
        .fontSize(24)
        .fontColor([this.currentTab === index ? Theme.PRIMARY : Theme.TEXT_SECOND])
      Text(title)
        .fontSize(11)
        .fontColor(this.currentTab === index ? Theme.PRIMARY : Theme.TEXT_SECOND)
        .margin({ top: 2 })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}
