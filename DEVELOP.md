# 開発ガイド

このリポジトリの Dockerfile, entrypoint.sh, nginx.conf を更新した場合は、 VSCode のソース管理からコミット後に以下のコマンドでバージョンを設定してください。

```sh title="バージョンを更新する"
npm version patch
git push --follow-tags
```

```sh title="バージョンをRC版で更新する"
npm version prerelease --preid rc
git push --follow-tags
```
