import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { LostFoundItem } from '../../model/LostFoundModel';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct LostFoundListPage {
  @State items: LostFoundItem[] = [];
  @State selectedType: string = '全部';
  @State selectedCategory: string = '全部';
  @State searchKeyword: string = '';
  @State pageOffset: number = 0;
  @State hasMore: boolean = true;
  @State isRefreshing: boolean = false;
  private pageSize: number = 5;
  private categories: string[] = ['全部', '校园卡', '书包', '电子产品', '其他'];

  aboutToAppear(): void {
    this.resetAndLoad();
  }

  resetAndLoad(): void {
    this.pageOffset = 0;
    this.hasMore = true;
    this.items = [];
    this.loadMore();
  }

  loadMore(): void {
    if (!this.hasMore) return;
    let all = MockData.getLostFoundItems();
    if (this.selectedType !== '全部') {
      all = all.filter(i => i.type === this.selectedType);
    }
    if (this.selectedCategory !== '全部') {
      all = all.filter(i => i.category === this.selectedCategory);
    }
    if (this.searchKeyword.trim() !== '') {
      const kw = this.searchKeyword.trim().toLowerCase();
      all = all.filter(i => i.title.toLowerCase().includes(kw) || i.description.toLowerCase().includes(kw));
    }
    const page = all.slice(this.pageOffset, this.pageOffset + this.pageSize);
    this.items = this.items.concat(page);
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
        Text('失物招领')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        Button('+ 发布')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.WHITE)
          .height(36)
          .backgroundColor(Theme.PRIMARY)
          .borderRadius(8)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_LOST_FOUND_PUBLISH });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 搜索
      Row() {
        TextInput({ text: this.searchKeyword, placeholder: '搜索失物/拾物信息...' })
          .fontSize(FontSize.BODY)
          .fontColor(Theme.TEXT_PRIMARY)
          .height(36)
          .layoutWeight(1)
          .backgroundColor(Theme.BG)
          .borderRadius(18)
          .padding({ left: 12 })
          .onChange((v: string) => {
            this.searchKeyword = v;
            this.filterData();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 类型筛选
      Row() {
        ForEach(['全部', '失物', '拾物'], (type: string) => {
          Text(type)
            .fontSize(FontSize.CAPTION)
            .fontColor(this.selectedType === type ? Theme.WHITE : Theme.TEXT_SECOND)
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
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
      .padding({ left: 16, right: 16, top: 4, bottom: 4 })
      .backgroundColor(Theme.CARD)

      // 分类筛选
      Row() {
        ForEach(this.categories, (cat: string) => {
          Text(cat)
            .fontSize(FontSize.TAG)
            .fontColor(this.selectedCategory === cat ? Theme.WHITE : Theme.TEXT_SECOND)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(10)
            .backgroundColor(this.selectedCategory === cat ? Theme.ACCENT_ORANGE : Theme.BG)
            .margin({ right: 6 })
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
          ForEach(this.items, (item: LostFoundItem) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.type === '失物' ? '🔴 失物' : '🟢 拾物')
                    .fontSize(FontSize.CAPTION)
                    .fontColor(item.type === '失物' ? Theme.RED_DOT : Theme.ACCENT_GREEN)
                    .padding({ left: 10, right: 10, top: 3, bottom: 3 })
                    .border({ width: 1, color: item.type === '失物' ? Theme.RED_DOT : Theme.ACCENT_GREEN, radius: 10 })
                  Text(item.title)
                    .fontSize(FontSize.LIST_TITLE)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(Theme.TEXT_PRIMARY)
                    .margin({ left: 8 })
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')

                Text(item.description)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.TEXT_SECOND)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8 })
                  .width('100%')

                Row() {
                  Text(`📍 ${item.location}`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                  Text(`🕐 ${item.lostTime}`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ left: 12 })
                  Text(`📞 ${item.contactPhone}`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.PRIMARY)
                    .margin({ left: 12 })
                }
                .margin({ top: 6 })
              }
              .width('100%')
              .padding(16)
            }
          })

          if (this.items.length > 0) {
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
  }
}