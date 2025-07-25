#!/bin/sh

# 環境変数のチェック
if [ -z "${GITHUB_REPO_OWNER}" ]; then
  echo "Error: GITHUB_REPO_OWNER environment variable not set."
  exit 1
fi

if [ -z "${GITHUB_REPO_NAME}" ]; then
  echo "Error: GITHUB_REPO_NAME environment variable not set."
  exit 1
fi

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "Error: GITHUB_TOKEN environment variable not set."
  echo "Please provide your GitHub Personal Access Token for authentication."
  exit 1
fi

# ダウンロード対象のブランチ名 (gh_pages)
BRANCH_NAME="gh-pages"

# ダウンロードURLの構築
# GitHubのアーカイブダウンロードURL形式: https://github.com/OWNER/REPO/archive/refs/heads/BRANCH.zip
DOWNLOAD_URL="https://github.com/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}/archive/refs/heads/${BRANCH_NAME}.zip"

# ダウンロード先の一時ファイル
TEMP_ZIP_FILE="/tmp/${BRANCH_NAME}.zip"

# Webコンテンツの公開ディレクトリ
WEB_CONTENT_BASE="/usr/share/nginx/html"
WEB_CONTENT_TEMPDIR="${WEB_CONTENT_BASE}/${GITHUB_REPO_NAME}-${BRANCH_NAME}"
WEB_CONTENT_DIR="${WEB_CONTENT_BASE}/web-content"

echo "Attempting to download web content from: ${DOWNLOAD_URL}"

# curlを使用してZIPファイルをダウンロード
# -L: リダイレクトをフォロー
# -H: AuthorizationヘッダーでPATを渡す (HTTP Basic認証)
# -o: 出力ファイル名を指定
# -q: 静かに展開 (出力を抑制)
curl -q -L -H "Authorization: token ${GITHUB_TOKEN}" \
  "${DOWNLOAD_URL}" -o "${TEMP_ZIP_FILE}"

# ダウンロードの成功を確認
if [ $? -ne 0 ]; then
  echo "Error: Failed to download content from GitHub."
  exit 1
fi

echo "Successfully downloaded ${TEMP_ZIP_FILE}"

# 既存のコンテンツを削除（クリーンな状態にするため）
rm -rf "${WEB_CONTENT_DIR}"

# ダウンロードしたZIPファイルをWebコンテンツディレクトリに展開
# -d: 展開先ディレクトリを指定
unzip "${TEMP_ZIP_FILE}" -d "${WEB_CONTENT_BASE}" \
  && mv "${WEB_CONTENT_TEMPDIR}" "${WEB_CONTENT_DIR}/"

# 展開の成功を確認
if [ $? -ne 0 ]; then
  echo "Error: Failed to unzip content."
  exit 1
fi

echo "Content unzipped to ${WEB_CONTENT_DIR}"

# 一時ファイルを削除
rm "${TEMP_ZIP_FILE}"

# Nginxをフォアグラウンドで実行
echo "Starting Nginx..."
exec nginx -g "daemon off;"
