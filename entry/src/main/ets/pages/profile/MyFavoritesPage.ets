import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Theme, FontSize } from '../../utils/Theme';

class FavoriteItem {
  id: number;
  type: string;
  title: string;
  date: string;

  constructor(id: number, type: string, title: string, date: string) {
    this.id = id;
    this.type = type;
    this.title = title;
    this.date = date;
  }
}

@Entry
@Component
struct MyFavoritesPage {
  @State selectedType: string = '全部';
  private types: string[] = ['全部', '公告', '资讯', '图书', '美食'];

  getFavoriteList(): FavoriteItem[] {
    const list: FavoriteItem[] = [];

    // 从 MockData 中获取收藏数据
    const announcements = MockData.getAnnouncements().filter(a => a.isCollected);
    announcements.forEach(a => {
      list.push(new FavoriteItem(a.id, '公告', a.title, a.publishTime));
    });

    const news = MockData.getNews().filter(n => n.isCollected);
    news.forEach(n => {
      list.push(new FavoriteItem(n.id, '资讯', n.title, n.publishTime));
    });

    const books = MockData.getBooks().filter(b => b.isCollected);
    books.forEach(b => {
      list.push(new FavoriteItem(b.id, '图书', b.name, ''));
    });

    const foods = MockData.getFoods().filter(f => f.isCollected);
    foods.forEach(f => {
      list.push(new FavoriteItem(f.id, '美食', f.name, f.location));
    });

    if (this.selectedType !== '全部') {
      return list.filter(i => i.type === this.selectedType);
    }
    return list;
  }

  getTypeColor(type: string): string {
    switch (type) {
      case '公告': return Theme.PRIMARY;
      case '资讯': return Theme.ACCENT_GREEN;
      case '图书': return Theme.ACCENT_ORANGE;
      case '美食': return Theme.RED_DOT;
      default: return Theme.TEXT_SECOND;
    }
  }

  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('我的收藏')
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
            })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      if (this.getFavoriteList().length === 0) {
        Column() {
          Text('📭')
            .fontSize(48)
          Text('暂无收藏内容')
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_SECOND)
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Theme.CARD)
      } else {
        List() {
          ForEach(this.getFavoriteList(), (item: FavoriteItem) => {
            ListItem() {
              Row() {
                Text(item.type)
                  .fontSize(FontSize.TAG)
                  .fontColor(Theme.WHITE)
                  .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                  .borderRadius(8)
                  .backgroundColor(this.getTypeColor(item.type))
                Text(item.title)
                  .fontSize(FontSize.BODY)
                  .fontColor(Theme.TEXT_PRIMARY)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ left: 10 })
                  .layoutWeight(1)
                Text(item.date)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.TEXT_SECOND)

                SymbolGlyph($r('sys.symbol.ohos_trash'))
                  .fontSize(18)
                  .fontColor([Theme.TEXT_SECOND])
                  .margin({ left: 10 })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14, bottom: 14 })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Theme.BORDER })
        .backgroundColor(Theme.CARD)
      }
    }
    .width('100%')
    .height('100%')
  }
}
