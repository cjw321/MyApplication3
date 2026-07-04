import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Announcement } from '../../model/AnnouncementModel';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct AnnouncementListPage {
  @State announcements: Announcement[] = [];
  @State selectedType: string = '全部';
  @State pageOffset: number = 0;
  @State hasMore: boolean = true;
  @State isRefreshing: boolean = false;
  private pageSize: number = 5;
  private types: string[] = ['全部', '学校通知', '学院通知', '社团通知'];

  aboutToAppear(): void {
    this.resetAndLoad();
  }

  resetAndLoad(): void {
    this.pageOffset = 0;
    this.hasMore = true;
    this.announcements = [];
    this.loadMore();
  }

  loadMore(): void {
    if (!this.hasMore) return;
    let all = MockData.getAnnouncements();
    if (this.selectedType !== '全部') {
      all = all.filter(a => a.type === this.selectedType);
    }
    const page = all.slice(this.pageOffset, this.pageOffset + this.pageSize);
    this.announcements = this.announcements.concat(page);
    this.pageOffset += this.pageSize;
    if (this.pageOffset >= all.length) {
      this.hasMore = false;
    }
  }

  filterData(): void {
    this.resetAndLoad();
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('校园公告')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 分类筛选
      Row() {
        ForEach(this.types, (type: string) => {
          Text(type)
            .fontSize(FontSize.CAPTION)
            .fontColor(this.selectedType === type ? Theme.WHITE : Theme.TEXT_SECOND)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(16)
            .backgroundColor(this.selectedType === type ? Theme.PRIMARY : Theme.BG)
            .margin({ right: 8 })
            .onClick(() => {
              this.selectedType = type;
              this.filterData();
            })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 列表 with Refresh
      Refresh({ refreshing: this.isRefreshing }) {
        List() {
          ForEach(this.announcements, (item: Announcement) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.title)
                    .fontSize(FontSize.LIST_TITLE)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(Theme.TEXT_PRIMARY)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .layoutWeight(1)
                }
                Row() {
                  Text(item.type)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.PRIMARY)
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .border({ width: 1, color: Theme.PRIMARY, radius: 8 })
                  Text(item.publisher)
                    .fontSize(FontSize.CAPTION)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ left: 8 })
                  Text(item.publishTime)
                    .fontSize(FontSize.CAPTION)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ left: 8 })
                }
                .margin({ top: 8 })
              }
              .width('100%')
              .padding(16)
              .onClick(() => {
                router.pushUrl({ url: Constants.PAGE_ANNOUNCEMENT_DETAIL, params: { id: item.id } });
              })
            }
          })

          // 加载更多提示
          if (this.announcements.length > 0) {
            ListItem() {
              Text(this.hasMore ? '上拉加载更多' : '— 已加载全部 —')
                .fontSize(FontSize.CAPTION)
                .fontColor(Theme.TEXT_SECOND)
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding(16)
            }
          }
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Theme.BORDER })
        .backgroundColor(Theme.CARD)
        .onReachEnd(() => {
          if (this.hasMore) {
            this.loadMore();
          }
        })
      }
      .onRefreshing(() => {
        this.isRefreshing = true;
        this.resetAndLoad();
        this.isRefreshing = false;
      })
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.CARD)
  }
}