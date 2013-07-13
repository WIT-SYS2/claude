# Claude

[![Build Status](https://travis-ci.org/shizm/claude.png?branch=master)](https://travis-ci.org/shizm/claude)

## About

**Claude**は精算書類台帳を管理するための簡易アプリケーションです。<br/>
Ruby 2.x + Rails 4.x + SQLite3 という環境での実行を前提としています。 

## Quick start

リポジトリをローカル環境にクローンします。

    $ git clone git://github.com/shizm/claude.git

必要なgemをインストールします。

    $ bundle install --path vendor/bundle

`config/database.example.yml`を参考に`config/database.yml`を作成します。

    development:
      adapter: sqlite3
      database: db/claude_development.sqlite3
      pool: 5
      timeout: 5000
    
    test:
      adapter: sqlite3
      database: db/claude_test.sqlite3
      pool: 5
      timeout: 5000

`config/application.example.yml`を参考に`config/application.yml`を作成します。

    # 台帳番号に付与されるプレフィックス文字列（5文字固定）
    LEDGER_NUMBER_PREFIX: ABC-00
    # メールを送信する際に必要となる自身のホスト名
    HOST: localhost
    # システムからメールを送る際に利用するGMailのアカウント
    GMAIL_USER_NAME: gmail_user_name
    GMAIL_PASSWORD: gmail_password

データベースを作成し、初期データを読み込みます。

    $ bundle exec rake db:create
    $ bundle exec rake db:migrate
    $ bundle exec rake db:seed

アプリケーションを起動します。

    $ bundle exec rails s

ブラウザで `http://localhost:3000` にアクセスし、メールアドレス: admin@example.com パスワード: administrator でログインできることを確認します。

## Test

    bundle exec rake


## Feature Requests & Bugs
<http://github.com/shizm/claude/issues>
