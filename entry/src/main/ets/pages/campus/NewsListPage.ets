import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { News } from '../../model/AnnouncementModel';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct NewsListPage {
  @State newsList: News[] = [];
  @State searchKeyword: string = '';
  @State selectedCategory: string = '全部';
  @State pageOffset: number = 0;
  @State hasMore: boolean = true;
  @State isRefreshing: boolean = false;
  private pageSize: number = 5;
  private categories: string[] = ['全部', '校园新闻', '社团活动', '讲座信息'];

  aboutToAppear(): void {
    this.resetAndLoad();
  }

  resetAndLoad(): void {
    this.pageOffset = 0;
    this.hasMore = true;
    this.newsList = [];
    this.loadMore();
  }

  loadMore(): void {
    if (!this.hasMore) return;
    let all = MockData.getNews();
    if (this.selectedCategory !== '全部') {
      all = all.filter(n => n.category === this.selectedCategory);
    }
    if (this.searchKeyword.trim() !== '') {
      const kw = this.searchKeyword.trim().toLowerCase();
      all = all.filter(n => n.title.toLowerCase().includes(kw) || n.summary.toLowerCase().includes(kw));
    }
    const page = all.slice(this.pageOffset, this.pageOffset + this.pageSize);
    this.newsList = this.newsList.concat(page);
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
        Text('校园资讯')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 搜索栏
      Row() {
        TextInput({ text: this.searchKeyword, placeholder: '搜索资讯...' })
          .fontSize(FontSize.BODY)
          .height(36)
          .layoutWeight(1)
          .backgroundColor(Theme.BG)
          .borderRadius(18)
          .padding({ left: 12 })
          .onChange((value: string) => {
            this.searchKeyword = value;
            this.filterData();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 分类筛选
      Row() {
        ForEach(this.categories, (cat: string) => {
          Text(cat)
            .fontSize(FontSize.CAPTION)
            .fontColor(this.selectedCategory === cat ? Theme.WHITE : Theme.TEXT_SECOND)
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(14)
            .backgroundColor(this.selectedCategory === cat ? Theme.PRIMARY : Theme.BG)
            .margin({ right: 8 })
            .onClick(() => {
              this.selectedCategory = cat;
              this.filterData();
            })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 4, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 列表 with Refresh
      Refresh({ refreshing: this.isRefreshing }) {
        List() {
          ForEach(this.newsList, (item: News) => {
            ListItem() {
              Column() {
                Text(item.title)
                  .fontSize(FontSize.LIST_TITLE)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Theme.TEXT_PRIMARY)
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
                  Text(item.source)
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
                router.pushUrl({ url: Constants.PAGE_NEWS_DETAIL, params: { id: item.id } });
              })
            }
          })

          if (this.newsList.length > 0) {
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