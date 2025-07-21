# 開発ガイド

このリポジトリの Dockerfile, entrypoint.sh, nginx.conf を更新した場合は、以下のコマンドでバージョンを設定してください。

```sh title="バージョンを更新する"
npm version patch
```

```sh title="バージョンをRC版で更新する"
npm version prerelease --preid rc
```

その後、 VSCode のソース管理からコミットし、プッシュしてください。
