# WebSocket Mock Server using AsyncAPI Generator

このプロジェクトは、AsyncAPI Generator を使用して WebSocket モックサーバーを作成する方法を示しています。このモックサーバーは、WebSocket ベースのチャットサービスをシミュレートできます。サーバーは、AsyncAPI 仕様に基づいてメッセージの送受信ができます。

## 概要

- **AsyncAPI 仕様バージョン**: 2.6.0
- **WebSocket URL**: `ws://localhost:3000`
- **プロトコル**: WebSocket (ws)
- **操作**:
  - `subscribe`: チャットメッセージを受信する。
  - `publish`: チャットメッセージを送信する。

## 必要なツール

このプロジェクトを実行するために必要なツールは以下の通りです：
- **Docker** (コンテナを使用)
- **Node.js** (モックサーバーのビルドに使用)

## セットアップ方法

1. **リポジトリをクローン**またはプロジェクトファイルをダウンロードします。
2. **Docker** がインストールされ、実行されていることを確認します。
3. **Node.js** がインストールされていることを確認します (バージョン 18 以上)。

## コマンド

### 1. モックサーバーの初期化

`mock-init` ターゲットは以下の操作を行います：
- `./mock-server` ディレクトリが存在しない場合に作成します。
- AsyncAPI Generator の Docker イメージをビルドします。
- 提供された AsyncAPI 仕様 (`asyncapi.yaml`) に基づいて WebSocket モックサーバーを生成します。
- 生成されたモックサーバーを `./mock-server` ディレクトリに抽出します。

```bash
make mock-init
```

### 2. モックサーバーの起動

`mock-start` ターゲットは以下の操作を行います：
- `./mock-server` ディレクトリからモックサーバーの Docker イメージをビルドします。
- モックサーバーをポート 8080 で実行します (`http://localhost:8080` でアクセス可能)。

```bash
make mock-start
```

### 3. モックサーバーのクリーンアップ

`mock-clean` ターゲットは `./mock-server` ディレクトリを削除します。

```bash
make mock-clean
```

## プロジェクト構造

- `Dockerfile`: AsyncAPI Generator とモックサーバーのイメージをビルドするために使用する Dockerfile。
- `asyncapi.yaml`: WebSocket チャットサービスの仕様を定義する AsyncAPI 仕様ファイル。
- `Makefile`: ビルドや実行コマンドを管理する Makefile（`mock-init`, `mock-start`, `mock-clean`）。

### Dockerfile

この Dockerfile は、AsyncAPI Generator とモックサーバーのイメージをビルドするために使用されます。主な手順は以下の通りです：
- 必要な依存パッケージ（`@asyncapi/generator` と `@asyncapi/cli`）をインストールします。
- AsyncAPI 仕様 (`asyncapi.yaml`) に基づいてモックサーバーを生成します。
- 生成された `Dockerfile` を修正して、ベースイメージを `node:18-alpine` に変更します。

### asyncapi.yaml

このファイルは、シンプルな WebSocket チャットサービスの API を定義しています。主な操作は以下の通りです：
- **`subscribe`**: チャットメッセージを受信する。
- **`publish`**: チャットメッセージを送信する。

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
