import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

export class PreferencesHelper {
  private static storeName: string = 'campus_assistant_press';

  static async getStore(context: common.Context): Promise<preferences.Preferences> {
    return preferences.getPreferences(context, PreferencesHelper.storeName);
  }

  static async getString(context: common.Context, key: string, defaultVal: string = ''): Promise<string> {
    const store = await PreferencesHelper.getStore(context);
    return store.get(key, defaultVal) as Promise<string>;
  }

  static async putString(context: common.Context, key: string, value: string): Promise<void> {
    const store = await PreferencesHelper.getStore(context);
    await store.put(key, value);
    await store.flush();
  }

  static async getBoolean(context: common.Context, key: string, defaultVal: boolean = true): Promise<boolean> {
    const store = await PreferencesHelper.getStore(context);
    return store.get(key, defaultVal) as Promise<boolean>;
  }

  static async putBoolean(context: common.Context, key: string, value: boolean): Promise<void> {
    const store = await PreferencesHelper.getStore(context);
    await store.put(key, value);
    await store.flush();
  }

  static async getNumber(context: common.Context, key: string, defaultVal: number = 0): Promise<number> {
    const store = await PreferencesHelper.getStore(context);
    return store.get(key, defaultVal) as Promise<number>;
  }

  static async putNumber(context: common.Context, key: string, value: number): Promise<void> {
    const store = await PreferencesHelper.getStore(context);
    await store.put(key, value);
    await store.flush();
  }

  static async getObject<T>(context: common.Context, key: string, defaultVal: T): Promise<T> {
    const store = await PreferencesHelper.getStore(context);
    const str = await store.get(key, '') as string;
    if (str === '') {
      return defaultVal;
    }
    return JSON.parse(str) as T;
  }

  static async putObject(context: common.Context, key: string, value: Object): Promise<void> {
    const store = await PreferencesHelper.getStore(context);
    await store.put(key, JSON.stringify(value));
    await store.flush();
  }
}
