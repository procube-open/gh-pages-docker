# gh-pages-docker

GitHub PagesのコンテンツをGitHubリポジトリから自動取得してNginxで配信するDockerコンテナイメージです。

## 概要

このDockerイメージは以下の機能を提供します：

- 指定されたGitHubリポジトリの`gh_pages`ブランチからコンテンツを自動ダウンロード
- ダウンロードしたコンテンツをNginxで配信
- GitHub Personal Access Token (PAT) による認証をサポート
- コンテナ起動時の自動コンテンツ更新

## 特徴

- **軽量**: Alpine Linuxベースで最小限のパッケージのみ使用
- **自動化**: コンテナ起動時にコンテンツの取得とWebサーバー起動を自動実行
- **セキュア**: GitHub PATによる認証でプライベートリポジトリにも対応
- **シンプル**: 環境変数による簡単な設定

## 必要な環境変数

以下の環境変数を設定する必要があります：

| 環境変数 | 説明 | 例 |
|---------|------|-----|
| `GITHUB_REPO_OWNER` | GitHubリポジトリのオーナー名 | `procube-open` |
| `GITHUB_REPO_NAME` | GitHubリポジトリ名 | `my-website` |
| `GITHUB_TOKEN` | GitHub Personal Access Token | `ghp_xxxxxxxxxxxxxxxxxxxx` |

## クイックスタート

### 1. Dockerイメージの取得

```bash
docker pull procube/gh-pages-nginx:latest
```

### 2. コンテナの実行

```bash
docker run -d \
  -p 8080:80 \
  -e GITHUB_REPO_OWNER=your-username \
  -e GITHUB_REPO_NAME=your-repo-name \
  -e GITHUB_TOKEN=your-github-token \
  --name gh-pages-server \
  procube/gh-pages-nginx:latest
```

### 3. Webサイトへのアクセス

ブラウザで `http://localhost:8080` にアクセスしてください。

## GitHub Personal Access Token (PAT) の設定

1. GitHubの設定画面で「Developer settings」→「Personal access tokens」→「Tokens (classic)」を選択
2. 「Generate new token (classic)」をクリック
3. 以下の権限を設定：
   - `repo` (プライベートリポジトリの場合)
   - `public_repo` (パブリックリポジトリのみの場合)
4. 生成されたトークンを`GITHUB_TOKEN`環境変数に設定

## Docker Compose での使用例

```yaml
version: '3.8'
services:
  gh-pages:
    image: procube/gh-pages-nginx:latest
    ports:
      - "8080:80"
    environment:
      GITHUB_REPO_OWNER: your-username
      GITHUB_REPO_NAME: your-repo-name
      GITHUB_TOKEN: your-github-token
    restart: unless-stopped
```

## 開発環境

### 前提条件

- Docker
- VS Code（推奨）
- Git

### ローカル開発

1. リポジトリをクローン：

   ```bash
   git clone https://github.com/procube-open/gh-pages-docker.git
   cd gh-pages-docker
   ```

2. VS Codeで開発コンテナを起動：

   ```bash
   code .
   # VS Codeで「Dev Containers: Reopen in Container」を実行
   ```

3. Dockerイメージをビルド：

   ```bash
   docker build -t gh-pages-nginx .
   ```

4. ローカルでテスト：

   ```bash
   docker run -d -p 8080:80 \
     -e GITHUB_REPO_OWNER=your-username \
     -e GITHUB_REPO_NAME=your-repo-name \
     -e GITHUB_TOKEN=your-github-token \
     gh-pages-nginx
   ```

## アーキテクチャ

```mermaid
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Repo   │    │   Docker Image   │    │   Web Browser   │
│   (gh_pages)    │───▶│                  │───▶│                 │
│                 │    │ ┌──────────────┐ │    │ localhost:8080  │
└─────────────────┘    │ │ entrypoint.sh│ │    └─────────────────┘
                       │ │  - Download  │ │
                       │ │  - Extract   │ │
                       │ │  - Start     │ │
                       │ └──────────────┘ │
                       │ ┌──────────────┐ │
                       │ │    Nginx     │ │
                       │ │   Server     │ │
                       │ └──────────────┘ │
                       └──────────────────┘
```

## ファイル構成

```text
gh-pages-docker/
├── Dockerfile              # メインのDockerイメージ定義
├── entrypoint.sh           # コンテナ起動時の処理スクリプト
├── nginx.conf              # Nginx設定ファイル
├── package.json            # バージョン管理用
├── .devcontainer/          # VS Code開発コンテナ設定
│   └── devcontainer.json
├── .github/workflows/      # GitHub Actions
│   └── publish.yml
└── README.md              # このファイル
```

## トラブルシューティング

### コンテナが起動しない

1. 環境変数が正しく設定されているか確認
2. GitHub PATの権限が適切か確認
3. 対象リポジトリに`gh_pages`ブランチが存在するか確認

### コンテンツが表示されない

1. ダウンロードログを確認：

   ```bash
   docker logs container-name
   ```

2. `gh_pages`ブランチにHTMLファイルが存在するか確認

### 認証エラー

1. GitHub PATが有効か確認
2. PATの権限が適切か確認（repo または public_repo）

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 貢献

プルリクエストやイシューの報告を歓迎します。開発に参加する際は、開発コンテナを使用することを推奨します。

## 作者

- **Mitsuru Nakakawaji** - [procube-open](https://github.com/procube-open)

## 関連リンク

- [Docker Hub](https://hub.docker.com/)
- [GitHub Pages](https://pages.github.com/)
- [Nginx](https://nginx.org/)
