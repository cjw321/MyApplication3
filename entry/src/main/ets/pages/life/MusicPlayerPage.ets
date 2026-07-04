import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Theme, FontSize } from '../../utils/Theme';
import { MediaHelper } from '../../utils/MediaHelper';

class Song {
  name: string;
  artist: string;

  constructor(name: string, artist: string) {
    this.name = name;
    this.artist = artist;
  }
}

@Entry
@Component
struct MusicPlayerPage {
  @State isPlaying: boolean = false;
  @State currentTime: number = 45;
  @State duration: number = 210;
  @State currentIndex: number = 0;
  @State volume: number = 70;
  @State localFiles: string[] = [];

  private playlist: Song[] = [
    new Song('晴天', '周杰伦'),
    new Song('起风了', '买辣椒也用券'),
    new Song('夜曲', '周杰伦'),
    new Song('年少有为', '李荣浩'),
    new Song('起风了(原版)', '高橋優'),
  ];

  get combinedPlaylist(): Song[] {
    const result: Song[] = [];
    for (let i = 0; i < this.playlist.length; i++) {
      result.push(this.playlist[i]);
    }
    for (let i = 0; i < this.localFiles.length; i++) {
      result.push(new Song(`本地音乐 #${i + 1}`, '本地文件'));
    }
    return result;
  }

  get currentSong(): Song {
    const combined = this.combinedPlaylist;
    if (this.currentIndex < combined.length) {
      return combined[this.currentIndex];
    }
    return this.playlist[0];
  }

  get progressPercent(): number {
    return this.duration > 0 ? (this.currentTime / this.duration) * 100 : 0;
  }

  formatTime(seconds: number): string {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
  }

  togglePlay(): void {
    this.isPlaying = !this.isPlaying;
  }

  prevSong(): void {
    if (this.currentIndex > 0) {
      this.currentIndex--;
      this.currentTime = 0;
      this.isPlaying = true;
    }
  }

  nextSong(): void {
    const combined = this.combinedPlaylist;
    if (this.currentIndex < combined.length - 1) {
      this.currentIndex++;
      this.currentTime = 0;
      this.isPlaying = true;
    }
  }

  async addLocalMusic(): Promise<void> {
    const uris = await MediaHelper.pickAudio(1);
    if (uris.length > 0) {
      this.localFiles.push(uris[0]);
      promptAction.showToast({ message: '已添加本地音乐', duration: 1500 });
      // 自动跳转到新添加的歌曲
      this.currentIndex = this.playlist.length + this.localFiles.length - 1;
      this.currentTime = 0;
      this.isPlaying = true;
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
        Text('音乐播放器')
          .fontSize(FontSize.MODULE_TITLE)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ left: 12 })
        Blank()
        Text('本地音乐')
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.PRIMARY)
          .onClick(() => this.addLocalMusic())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Theme.CARD)

      Column() {
        // 唱片封面
        Column() {
          Text('🎵')
            .fontSize(80)
        }
        .width(180)
        .height(180)
        .borderRadius(90)
        .backgroundColor(Theme.PRIMARY_BG)
        .justifyContent(FlexAlign.Center)
        .margin({ top: 40 })
        .rotate({ angle: this.isPlaying ? 360 : 0 })
        .animation({ duration: 30000, curve: Curve.Linear, iterations: this.isPlaying ? -1 : 1 })

        // 歌曲信息
        Text(this.currentSong.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ top: 32 })
        Text(this.currentSong.artist)
          .fontSize(FontSize.CAPTION)
          .fontColor(Theme.TEXT_SECOND)
          .margin({ top: 8 })

        // 进度条
        Row() {
          Text(this.formatTime(this.currentTime))
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .width(40)
          Slider({
            value: this.currentTime,
            min: 0,
            max: this.duration,
            step: 1
          })
            .blockColor(Theme.PRIMARY)
            .trackColor(Theme.BORDER)
            .selectedColor(Theme.PRIMARY)
            .layoutWeight(1)
            .margin({ left: 8, right: 8 })
            .onChange((value: number) => { this.currentTime = value as number; })
          Text(this.formatTime(this.duration))
            .fontSize(FontSize.CAPTION)
            .fontColor(Theme.TEXT_SECOND)
            .width(40)
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
        .margin({ top: 24 })

        // 播放控制
        Row() {
          Text('⏮')
            .fontSize(28)
            .fontColor(Theme.TEXT_SECOND)
            .onClick(() => this.prevSong())

          Text(this.isPlaying ? '⏸' : '▶')
            .fontSize(48)
            .fontColor(Theme.PRIMARY)
            .margin({ left: 36, right: 36 })
            .onClick(() => this.togglePlay())

          Text('⏭')
            .fontSize(28)
            .fontColor(Theme.TEXT_SECOND)
            .onClick(() => this.nextSong())
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: 28 })

        // 播放列表
        Text('播放列表')
          .fontSize(FontSize.BODY)
          .fontWeight(FontWeight.Medium)
          .fontColor(Theme.TEXT_PRIMARY)
          .width('100%')
          .padding({ left: 20, top: 32, bottom: 8 })
        List() {
          ForEach(this.combinedPlaylist, (song: Song, idx: number) => {
            ListItem() {
              Row() {
                Text(`${idx + 1}`)
                  .fontSize(FontSize.CAPTION)
                  .fontColor(idx === this.currentIndex ? Theme.PRIMARY : Theme.TEXT_SECOND)
                  .width(30)
                Column() {
                  Text(song.name)
                    .fontSize(FontSize.BODY)
                    .fontColor(idx === this.currentIndex ? Theme.PRIMARY : Theme.TEXT_PRIMARY)
                    .fontWeight(idx === this.currentIndex ? FontWeight.Medium : FontWeight.Normal)
                  Text(song.artist)
                    .fontSize(FontSize.CAPTION)
                    .fontColor(Theme.TEXT_SECOND)
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 8 })
                .layoutWeight(1)
                if (idx === this.currentIndex) {
                  Text('♪')
                    .fontSize(16)
                    .fontColor(Theme.PRIMARY)
                }
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 10, bottom: 10 })
              .onClick(() => {
                this.currentIndex = idx;
                this.currentTime = 0;
                this.isPlaying = true;
              })
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: Theme.BORDER })
      }
      .layoutWeight(1)
      .backgroundColor(Theme.CARD)
    }
    .width('100%')
    .height('100%')
  }
}