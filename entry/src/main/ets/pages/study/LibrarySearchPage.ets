import { router } from '@kit.ArkUI';
import { MockData } from '../../data/MockData';
import { Book } from '../../model/BookModel';
import { Constants } from '../../utils/Constants';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct LibrarySearchPage {
  @State searchKeyword: string = '';
  @State searchType: number = 0;
  @State books: Book[] = [];
  @State hasSearched: boolean = false;

  aboutToAppear(): void {
    // 初始显示所有图书
    this.books = MockData.getBooks();
  }

  doSearch(): void {
    this.hasSearched = true;
    const kw = this.searchKeyword.trim().toLowerCase();
    if (kw === '') {
      this.books = MockData.getBooks();
      return;
    }
    const all = MockData.getBooks();
    if (this.searchType === 0) {
      this.books = all.filter(b => b.name.toLowerCase().includes(kw));
    } else if (this.searchType === 1) {
      this.books = all.filter(b => b.author.toLowerCase().includes(kw));
    } else {
      this.books = all.filter(b => b.isbn.includes(kw));
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor(Theme.PRIMARY)
          .onClick(() => router.back())
        Text('图书馆检索')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      // 搜索区域
      Column() {
        Row() {
          Select([{ value: '书名' }, { value: '作者' }, { value: 'ISBN' }])
            .selected(this.searchType)
            .value('书名')
            .width(80)
            .height(36)
            .onSelect((index: number, value: string) => {
              this.searchType = index;
            })
          TextInput({ text: this.searchKeyword, placeholder: '请输入搜索关键词...' })
            .fontSize(FontSize.BODY)
            .fontColor(Theme.TEXT_PRIMARY)
            .height(36)
            .layoutWeight(1)
            .backgroundColor(Theme.BG)
            .borderRadius(18)
            .padding({ left: 12 })
            .margin({ left: 8 })
            .onChange((v: string) => this.searchKeyword = v)
            .onSubmit(() => this.doSearch())
          Button('搜索')
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.WHITE)
            .height(36)
            .backgroundColor(Theme.PRIMARY)
            .borderRadius(18)
            .margin({ left: 8 })
            .onClick(() => this.doSearch())
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      List() {
        ForEach(this.books, (book: Book) => {
          ListItem() {
            Row() {
              Column() {
                Text('📖')
                  .fontSize(32)
              }
              .width(50)
              .height(60)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Theme.PRIMARY_BG)
              .borderRadius(8)

              Column() {
                Text(book.name)
                  .fontSize(FontSize.LIST_TITLE)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Theme.TEXT_PRIMARY)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(`作者: ${book.author}`)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(Theme.TEXT_SECOND)
                  .margin({ top: 4 })
                Row() {
                  Text(`位置: ${book.location}`)
                    .fontSize(FontSize.TAG)
                    .fontColor(Theme.TEXT_SECOND)
                  Text(`可借: ${book.availableCount}/${book.totalCount}`)
                    .fontSize(FontSize.TAG)
                    .fontColor(book.availableCount > 0 ? Theme.ACCENT_GREEN : Theme.RED_DOT)
                    .margin({ left: 12 })
                }
                .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Text('›')
                .fontSize(20)
                .fontColor(Theme.BORDER)
            }
            .width('100%')
            .padding(16)
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_BOOK_DETAIL, params: { id: book.id } });
            })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 0.5, color: Theme.BORDER })
      .backgroundColor(Theme.CARD)

      if (this.hasSearched && this.books.length === 0) {
        Text('未找到相关图书')
          .fontSize(FontSize.BODY)
          .fontColor(Theme.TEXT_SECOND)
          .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
  }
}
