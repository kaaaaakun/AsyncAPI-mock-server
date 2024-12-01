# ベースイメージとしてNode.js 18を使用
FROM node:18

# 作業ディレクトリを設定
WORKDIR /app

# 必要なグローバルパッケージをインストール
RUN npm install -g @asyncapi/generator@1.9.0 @asyncapi/cli@1.9.0

# asyncapi.yaml ファイルだけをコピー
COPY asyncapi.yaml /app/asyncapi.yaml

# AsyncAPI Generator コマンドを実行
RUN npx ag /app/asyncapi.yaml @asyncapi/nodejs-ws-template -o /mock-server -p server=websocketServer

# /mock-server/Dockerfile の内容を変更する
RUN sed -i 's/FROM node:12-alpine/FROM node:18-alpine/' /mock-server/Dockerfile

# 出力結果をホストにコピーするためにエントリポイントを変更
CMD ["tar", "-czvf", "/mock-server.tar.gz", "-C", "/mock-server", "."]

