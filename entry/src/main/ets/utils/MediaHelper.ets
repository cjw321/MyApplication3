/**
 * 媒体选择辅助类（封装 PhotoViewPicker）
 * 无需额外权限，系统选择器托管返回 URI
 */
import { picker } from '@kit.CoreFileKit';

export class MediaHelper {
  /**
   * 选择图片
   * @param max 最大选择数量
   * @returns URI 数组
   */
  static async pickImage(max: number = 1): Promise<string[]> {
    try {
      const p = new picker.PhotoViewPicker();
      const r = await p.select({
        MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: max
      });
      return r.photoUris;
    } catch (err) {
      return [];
    }
  }

  /**
   * 选择音频
   * @param max 最大选择数量
   * @returns URI 数组
   */
  static async pickAudio(max: number = 1): Promise<string[]> {
    try {
      const p = new picker.PhotoViewPicker();
      const r = await p.select({
        maxSelectNumber: max
      });
      return r.photoUris;
    } catch (err) {
      return [];
    }
  }
}