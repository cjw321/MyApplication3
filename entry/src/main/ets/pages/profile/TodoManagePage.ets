import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { TodoItem } from '../../model/TodoModel';
import { MockData } from '../../data/MockData';
import { Constants } from '../../utils/Constants';
import { PreferencesHelper } from '../../data/PreferencesHelper';
import { Theme, FontSize } from '../../utils/Theme';

@Entry
@Component
struct TodoManagePage {
  @State todos: TodoItem[] = [];
  @State selectedCategory: string = '全部';
  @State isBatchMode: boolean = false;
  @State selectedIds: number[] = [];
  @State showAddDialog: boolean = false;
  @State newTodoContent: string = '';
  @State newTodoCategory: string = '学习';
  @State newTodoRemindTime: string = '';

  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.loadTodos();
  }

  async loadTodos(): Promise<void> {
    const saved = await PreferencesHelper.getObject<TodoItem[]>(this.context, Constants.PREF_KEY_TODOS, []);
    this.todos = saved.length > 0 ? saved : MockData.getTodos();
  }

  async saveTodos(): Promise<void> {
    await PreferencesHelper.putObject(this.context, Constants.PREF_KEY_TODOS, this.todos);
  }

  get filteredTodos(): TodoItem[] {
    if (this.selectedCategory === '全部') return this.todos;
    if (this.selectedCategory === '已完成') return this.todos.filter(t => t.isCompleted);
    return this.todos.filter(t => t.category === this.selectedCategory);
  }

  toggleTodo(id: number): void {
    const todo = this.todos.find(t => t.id === id);
    if (todo) {
      todo.isCompleted = !todo.isCompleted;
      this.saveTodos();
    }
  }

  deleteTodo(id: number): void {
    this.todos = this.todos.filter(t => t.id !== id);
    this.saveTodos();
  }

  toggleSelect(id: number): void {
    const idx = this.selectedIds.indexOf(id);
    if (idx >= 0) {
      this.selectedIds.splice(idx, 1);
    } else {
      this.selectedIds.push(id);
    }
  }

  batchDelete(): void {
    if (this.selectedIds.length === 0) {
      promptAction.showToast({ message: '请选择待办事项', duration: 1500 });
      return;
    }
    this.todos = this.todos.filter(t => !this.selectedIds.includes(t.id));
    this.selectedIds = [];
    this.saveTodos();
    promptAction.showToast({ message: '批量删除成功', duration: 1500 });
  }

  batchComplete(): void {
    if (this.selectedIds.length === 0) {
      promptAction.showToast({ message: '请选择待办事项', duration: 1500 });
      return;
    }
    this.todos.forEach(t => {
      if (this.selectedIds.includes(t.id)) {
        t.isCompleted = true;
      }
    });
    this.selectedIds = [];
    this.saveTodos();
    promptAction.showToast({ message: '批量标记完成', duration: 1500 });
  }

  addTodo(): void {
    if (!this.newTodoContent.trim()) {
      promptAction.showToast({ message: '请输入待办内容', duration: 1500 });
      return;
    }
    const newItem: TodoItem = {
      id: Date.now(),
      content: this.newTodoContent.trim(),
      category: this.newTodoCategory,
      isCompleted: false,
      remindTime: this.newTodoRemindTime || '',
      createTime: new Date().toISOString().substring(0, 16)
    };
    this.todos.unshift(newItem);
    this.saveTodos();
    this.newTodoContent = '';
    this.newTodoRemindTime = '';
    this.showAddDialog = false;
    promptAction.showToast({ message: '添加成功', duration: 1500 });
  }

  // 分类色：学习=蓝、生活=绿、其他=橙
  getCategoryColor(cat: string): string {
    switch (cat) {
      case '学习': return Theme.PRIMARY;
      case '生活': return Theme.ACCENT_GREEN;
      default: return Theme.ACCENT_ORANGE;
    }
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('‹')
            .fontSize(28)
            .fontColor(Theme.PRIMARY)
            .onClick(() => router.back())
          Text('待办事项管理')
            .fontSize(FontSize.MODULE_TITLE)
            .fontWeight(FontWeight.Medium)
            .fontColor(Theme.TEXT_PRIMARY)
            .margin({ left: 12 })
          Blank()
          Button(this.isBatchMode ? '取消' : '批量')
            .fontSize(FontSize.CAPTION)
            .height(36)
            .backgroundColor(this.isBatchMode ? Theme.ACCENT_ORANGE : Theme.BG)
            .fontColor(this.isBatchMode ? Theme.WHITE : Theme.TEXT_SECOND)
            .borderRadius(8)
            .onClick(() => {
              this.isBatchMode = !this.isBatchMode;
              this.selectedIds = [];
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(Theme.CARD)

        // 分类
        Row() {
          ForEach(['全部', '学习', '生活', '其他', '已完成'], (cat: string) => {
            Text(cat)
              .fontSize(FontSize.CAPTION)
              .fontColor(this.selectedCategory === cat ? Theme.WHITE : Theme.TEXT_SECOND)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .borderRadius(14)
              .backgroundColor(this.selectedCategory === cat ? Theme.PRIMARY : Theme.BG)
              .margin({ right: 6 })
              .onClick(() => {
                this.selectedCategory = cat;
                this.isBatchMode = false;
                this.selectedIds = [];
              })
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(Theme.CARD)

        // 批量操作栏
        if (this.isBatchMode) {
          Row() {
            Text(`已选 ${this.selectedIds.length} 项`)
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
              .layoutWeight(1)
            Button('批量完成')
              .fontSize(FontSize.CAPTION)
              .height(36)
              .backgroundColor(Theme.ACCENT_GREEN)
              .borderRadius(8)
              .margin({ right: 8 })
              .onClick(() => this.batchComplete())
            Button('批量删除')
              .fontSize(FontSize.CAPTION)
              .height(36)
              .backgroundColor(Theme.RED_DOT)
              .borderRadius(8)
              .onClick(() => this.batchDelete())
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 6, bottom: 6 })
          .backgroundColor('#FFF7E8')
        }

        List() {
          ForEach(this.filteredTodos, (item: TodoItem) => {
            ListItem() {
              Row() {
                if (this.isBatchMode) {
                  Checkbox()
                    .select(this.selectedIds.includes(item.id))
                    .selectedColor(Theme.PRIMARY)
                    .margin({ right: 8 })
                    .onChange((val: boolean) => {
                      this.toggleSelect(item.id);
                    })
                }
                Checkbox()
                  .select(item.isCompleted)
                  .selectedColor(Theme.PRIMARY)
                  .onChange((val: boolean) => {
                    if (!this.isBatchMode) {
                      this.toggleTodo(item.id);
                    }
                  })
                Column() {
                  Text(item.content)
                    .fontSize(FontSize.BODY)
                    .fontColor(item.isCompleted ? Theme.TEXT_SECOND : Theme.TEXT_PRIMARY)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .decoration({ type: item.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None })
                  Row() {
                    Text(item.category)
                      .fontSize(FontSize.TAG)
                      .fontColor(Theme.WHITE)
                      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                      .borderRadius(6)
                      .backgroundColor(this.getCategoryColor(item.category))
                    if (item.remindTime) {
                      Text(`⏰ ${item.remindTime}`)
                        .fontSize(FontSize.TAG)
                        .fontColor(Theme.TEXT_SECOND)
                        .margin({ left: 8 })
                    }
                  }
                  .margin({ top: 4 })
                }
                .margin({ left: 8 })
                .layoutWeight(1)

                SymbolGlyph($r('sys.symbol.ohos_trash'))
                  .fontSize(18)
                  .fontColor([Theme.TEXT_SECOND])
                  .onClick(() => {
                    this.deleteTodo(item.id);
                  })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Theme.BORDER })
        .backgroundColor(Theme.CARD)
      }
      .width('100%')
      .height('100%')

      // 新增按钮
      Button('+ 新增待办')
        .fontSize(FontSize.BODY)
        .height(44)
        .width('60%')
        .backgroundColor(Theme.PRIMARY)
        .borderRadius(22)
        .position({ bottom: 24 })
        .shadow({ radius: 8, color: Theme.PRIMARY, offsetY: 4 })
        .onClick(() => {
          this.showAddDialog = true;
        })

      // 新增弹窗
      if (this.showAddDialog) {
        Column() {
          Column() {
            Text('新增待办')
              .fontSize(FontSize.MODULE_TITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Theme.TEXT_PRIMARY)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 20, bottom: 16 })

            TextArea({ text: this.newTodoContent, placeholder: '请输入待办内容...' })
              .fontSize(FontSize.BODY)
              .height(80)
              .backgroundColor(Theme.BG)
              .borderRadius(8)
              .padding(12)
              .margin({ left: 20, right: 20 })

            Text('分类')
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
              .width('100%')
              .padding({ left: 20, top: 12, bottom: 6 })
            Row() {
              ForEach(['学习', '生活', '其他'], (cat: string) => {
                Text(cat)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(this.newTodoCategory === cat ? Theme.WHITE : Theme.TEXT_SECOND)
                  .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                  .borderRadius(12)
                  .backgroundColor(this.newTodoCategory === cat ? Theme.PRIMARY : Theme.BG)
                  .margin({ right: 8 })
                  .onClick(() => { this.newTodoCategory = cat; })
              })
            }
            .width('100%')
            .padding({ left: 20, right: 20 })

            Text('提醒时间（选填）')
              .fontSize(FontSize.CAPTION)
              .fontColor(Theme.TEXT_SECOND)
              .width('100%')
              .padding({ left: 20, top: 12, bottom: 6 })
            TextInput({ text: this.newTodoRemindTime, placeholder: '如 2026-06-16 20:00' })
              .fontSize(FontSize.BODY)
              .height(36)
              .backgroundColor(Theme.BG)
              .borderRadius(8)
              .padding({ left: 10 })
              .margin({ left: 20, right: 20 })
              .onChange((v: string) => this.newTodoRemindTime = v)

            Row() {
              Button('取消')
                .fontSize(FontSize.BODY)
                .height(40)
                .layoutWeight(1)
                .backgroundColor(Theme.BG)
                .fontColor(Theme.TEXT_SECOND)
                .borderRadius(20)
                .margin({ right: 8 })
                .onClick(() => {
                  this.showAddDialog = false;
                })
              Button('确认添加')
                .fontSize(FontSize.BODY)
                .height(40)
                .layoutWeight(1)
                .backgroundColor(Theme.PRIMARY)
                .fontColor(Theme.WHITE)
                .borderRadius(20)
                .onClick(() => this.addTodo())
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          }
          .width('85%')
          .borderRadius(8)
          .backgroundColor(Theme.CARD)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#80000000')
        .onClick(() => {
          this.showAddDialog = false;
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
