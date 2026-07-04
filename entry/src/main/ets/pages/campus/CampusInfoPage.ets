import { router } from '@kit.ArkUI';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';
import { MockData } from '../../data/MockData';
import { Announcement, News } from '../../model/AnnouncementModel';

@Component
export struct CampusInfoPage {
  @State announcements: Announcement[] = [];
  @State newsList: News[] = [];
  @State selectedTab: number = 0;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;
  private tabs: string[] = ['公告', '资讯', '社团活动', '学术讲座', '校园地图'];

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    this.announcements = MockData.getAnnouncements().slice(0, 2);
    this.newsList = MockData.getNews().slice(0, 3);
  }

  build() {
    Scroll() {
      Column() {
        // 顶部标题
        Text('校园信息')
          .fontSize(FontSize.PAGE_TITLE)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding({ left: 16, top: 16, bottom: 8 })
          .fontColor(Theme.textColor(this.isDarkMode))

        // 横向滚动标签栏
        this.tabBar()

        // 标签内容区
        if (this.selectedTab === 0) {
          this.announcementContent()
        } else if (this.selectedTab === 1) {
          this.newsContent()
        } else if (this.selectedTab === 2) {
          this.placeholderContent('社团活动', '精彩社团活动即将上线，敬请期待！')
        } else if (this.selectedTab === 3) {
          this.placeholderContent('学术讲座', '学术讲座信息即将上线，敬请期待！')
        } else if (this.selectedTab === 4) {
          this.mapContent()
        }

        Blank().height(16)
      }
    }
    .scrollBar(BarState.Off)
    .backgroundColor(Theme.bgColor(this.isDarkMode))
  }

  @Builder
  tabBar() {
    Scroll() {
      Row() {
        ForEach(this.tabs, (tab: string, idx: number) => {
          this.navTab(tab, idx)
        })
      }
      .padding({ left: 16, right: 16 })
    }
    .scrollBar(BarState.Off)
    .width('100%')
  }

  @Builder
  navTab(title: string, index: number) {
    Column() {
      Text(title)
        .fontSize(FontSize.BODY)
        .fontWeight(this.selectedTab === index ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.selectedTab === index ? Theme.PRIMARY : Theme.textSecondColor(this.isDarkMode))
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      // 下划线
      if (this.selectedTab === index) {
        Text('')
          .width(20)
          .height(2)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(1)
          .margin({ top: 2 })
      }
    }
    .margin({ right: 4 })
    .onClick(() => {
      this.selectedTab = index;
    })
  }

  @Builder
  announcementContent() {
    Column() {
      // 公告区域
      this.sectionHeader('校园公告', Constants.PAGE_ANNOUNCEMENT_LIST)
      List() {
        ForEach(this.announcements, (item: Announcement) => {
          ListItem() {
            Row() {
              Text(`[${item.type}]`)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.PRIMARY)
              Text(item.title)
                .fontSize(FontSize.BODY)
                .fontColor(Theme.textColor(this.isDarkMode))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ left: 6 })
              Blank()
              Text(item.publishTime.substring(5, 10))
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .backgroundColor(Theme.cardColor(this.isDarkMode))
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_ANNOUNCEMENT_DETAIL, params: { id: item.id } });
            })
          }
        })
      }
      .width('100%')
      .divider({ strokeWidth: 0.5, color: Theme.BORDER })
    }
  }

  @Builder
  newsContent() {
    Column() {
      this.sectionHeader('校园资讯', Constants.PAGE_NEWS_LIST)
      List() {
        ForEach(this.newsList, (item: News) => {
          ListItem() {
            Column() {
              Text(item.title)
              .fontSize(FontSize.LIST_TITLE)
              .fontWeight(FontWeight.Medium)
              .fontColor(Theme.textColor(this.isDarkMode))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')
              Text(item.summary)
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 6 })
                .width('100%')
              Row() {
                Text(item.category)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.PRIMARY)
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .border({ width: 1, color: Theme.PRIMARY, radius: 8 })
                Text(item.publishTime)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ left: 12 })
              }
              .margin({ top: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Theme.cardColor(this.isDarkMode))
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_NEWS_DETAIL, params: { id: item.id } });
            })
          }
        })
      }
      .width('100%')
      .divider({ strokeWidth: 0.5, color: Theme.BORDER })
    }
  }

  @Builder
  placeholderContent(title: string, message: string) {
    Column() {
      Text(message)
        .fontSize(FontSize.BODY)
        .fontColor(Theme.textSecondColor(this.isDarkMode))
        .padding(32)
        .width('100%')
        .textAlign(TextAlign.Center)
    }
  }

  @Builder
  mapContent() {
    Column() {
      Row() {
        Column() {
          Text('🗺️')
            .fontSize(32)
          Text('校园地图')
            .fontSize(FontSize.BODY)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 6 })
            .fontColor(Theme.textColor(this.isDarkMode))
          Text('查看教学楼、图书馆等建筑位置')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .margin({ top: 4 })
        }
        .width('100%')
        .height(100)
        .justifyContent(FlexAlign.Center)
        .borderRadius(8)
        .backgroundColor(Theme.cardColor(this.isDarkMode))
        .onClick(() => {
          router.pushUrl({ url: Constants.PAGE_CAMPUS_MAP });
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    }
  }

  @Builder
  sectionHeader(title: string, targetPage: string) {
    Row() {
      Text(title)
        .fontSize(FontSize.MODULE_TITLE)
        .fontWeight(FontWeight.Medium)
        .fontColor(Theme.textColor(this.isDarkMode))
      Blank()
      Text('更多 >')
        .fontSize(FontSize.CAPTION)
        .fontColor(Theme.PRIMARY)
        .onClick(() => {
          router.pushUrl({ url: targetPage });
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 8 })
  }
}