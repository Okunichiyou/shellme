# Shellme

## セットアップ

### 環境変数の設定

`.env`ファイルをプロジェクトルートに作成してください：

```text
BASE_URL=http://192.168.x.x:8787
```

### Arkanaでキーを生成

```bash
bundle install
bundle exec arkana
```

### バックエンドサーバーを起動

読み取った画像を解析して、自動入力を行うためのデータを返すサーバー

```bash
cd backend
npm install
npm run dev -- --ip 0.0.0.0
```

同じWiFi上の端末からアクセスする場合は `--ip 0.0.0.0` オプションが必要です。
起動後、自分のIPアドレス（例: `http://192.168.x.x:8787`）を`.env`の`BASE_URL`に設定してください。
