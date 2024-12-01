# WebSocket Mock Server using AsyncAPI Generator

このプロジェクトは、AsyncAPI Generator を使用して WebSocket モックサーバーを作成する方法を示します。サーバーは、AsyncAPI 仕様に基づいて WebSocket ベースのチャットサービスをシミュレートし、メッセージの送受信ができます。

## 概要

- **AsyncAPI 仕様バージョン**: 2.6.0
- **WebSocket URL**: `ws://localhost:3000`
- **プロトコル**: WebSocket (ws)
- **操作**:
  - `subscribe`: チャットメッセージを受信
  - `publish`: チャットメッセージを送信

## 必要なツール

- **Docker** (コンテナを使用)

## セットアップ方法

1. **リポジトリをクローン**またはプロジェクトファイルをダウンロード
2. **Docker** がインストールされていることを確認

## コマンド

### 1. モックサーバーの初期化

`mock-init` ターゲットは以下の操作を行います：
- `./mock-server` ディレクトリが存在しない場合に作成
- AsyncAPI Generator の Docker イメージをビルド
- `asyncapi.yaml` に基づいて WebSocket モックサーバーを生成
- 生成されたサーバーを `./mock-server` に抽出

```bash
make mock-init
```

### 2. モックサーバーの起動

`mock-start` ターゲットは以下の操作を行います：
- `./mock-server` ディレクトリからモックサーバーの Docker イメージをビルド
- サーバーをポート `8080` で起動（`http://localhost:8080`）
- `wscat -c ws://localhost:3000/` で WebSocket 接続確認

```bash
make mock-start
```

### 3. モックサーバーのクリーンアップ

`mock-clean` ターゲットで、`./mock-server` ディレクトリを削除します。

```bash
make mock-clean
```

## プロジェクト構造

- `Dockerfile`: AsyncAPI Generator とモックサーバーのイメージをビルド
- `asyncapi.yaml`: WebSocket チャットサービスの仕様
- `Makefile`: ビルドや実行コマンドを管理（`mock-init`, `mock-start`, `mock-clean`）

### Dockerfile

`Dockerfile` は AsyncAPI Generator とモックサーバーのイメージをビルドします。以下の手順で構成されています：
- 必要な依存パッケージ（`@asyncapi/generator` と `@asyncapi/cli`）をインストール
- `asyncapi.yaml` に基づいてモックサーバーを生成
- 生成されたサーバー用の Dockerfile で、ベースイメージを `node:18-alpine` に変更

### asyncapi.yaml

AsyncAPI 仕様ファイルで、WebSocket チャットサービスを定義しています。以下の操作をサポート：
- **`subscribe`**: チャットメッセージを受信
- **`publish`**: チャットメッセージを送信

```yaml
asyncapi: '2.6.0'
info:
  title: WebSocket Mock Example
  version: '1.0.0'
servers:
  websocketServer:
    url: ws://localhost:3000
    protocol: ws
channels:
  chat/message:
    subscribe:
      operationId: receiveMessage
      message:
        payload:
          type: object
          properties:
            user:
              type: string
            message:
              type: string
    publish:
      operationId: sendMessage
      message:
        payload:
          type: object
          properties:
            user:
              type: string
            message:
              type: string
```

## 実装部分

`mock-server/src/api/services/` 内のコードを自分で実装する必要があります。以下は、メッセージ受信および送信のサンプルコードです。

```js
const service = module.exports = {};

/**
 * 
 * @param {object} ws WebSocket connection.
 */
service.receiveMessage = async (ws) => {
  ws.send('Message from the server: Implement here your business logic that sends messages to a client after it connects.');
};
/**
 * 
 * @param {object} ws WebSocket connection.
 * @param {object} options
 * @param {string} options.path The path in which the message was received.
 * @param {object} options.query The query parameters used when connecting to the server.
 * @param {object} options.message The received message.
 * @param {string} options.message.payload.user
 * @param {string} options.message.payload.message
 */
service.sendMessage = async (ws, { message, path, query }) => {
  ws.send('Message from the server: Implement here your business logic that reacts on messages sent from a client.');
};
```

### 注意点
- このモックサーバーは基本的な構造を提供しますが、チャットサービスのロジックやビジネスロジックは手動で実装する必要があります。
- `chat-message.js` 内のコードをカスタマイズし、必要な機能を追加してください。
