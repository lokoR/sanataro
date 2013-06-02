# language: ja

@javascript
フィーチャ: ログインする
  ログインする。
 
  シナリオ: ログイン画面を表示する。
    もし "ログイン"ページを表示する
    ならば "ログインID、もしくは、パスワードが正しくありません。"と表示されていないこと

  シナリオ: ユーザ,パスワードを入力せずにログインを押す。
    前提 "ログイン"ページを表示する
    もし "ログイン"ボタンをクリックする
    ならば "ログインID、もしくは、パスワードが正しくありません。"と表示されていること

  シナリオ: 間違ったユーザ,パスワードを入力しログインを押す。
    前提 "ログイン"ページを表示している
    もし "login"に"user1"と入力する
    かつ "password"に"1234567"と入力する
    かつ "ログイン"ボタンをクリックする
    ならば "ログインID、もしくは、パスワードが正しくありません。"と表示されていること

  シナリオ: 正しいユーザ,パスワードを入力しログインを押す。
    前提 "ログイン"ページを表示している
    もし "login"に"user1"と入力する
    かつ "password"に"123456"と入力する
    かつ "ログイン"ボタンをクリックする
    ならば "収支入力"ページにリダイレクトすること
