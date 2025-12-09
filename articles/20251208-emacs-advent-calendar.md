---
title: "leaf.elを活用し日本語で構造化したinit.elを作る"
emoji: "🐂"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["emacs"]
published: false
---

この記事は[Emacs - Qiita Advent Calendar 2025](https://qiita.com/advent-calendar/2025/emacs)の8日目の記事です（空いてることに気づき9日に急ぎ書いてますが、多分どこかの国はまだ8日でしょう）

昨日は、naoking158さんの[rust 実装のLSPクライアント lsp-proxy が凄く早くて良い](https://naoking158.pages.dev/posts/lsp-proxy/)でした。

# この記事は？

Emacsを利用されている方は、定期的にinit.elを式年遷宮しているかと思います

私は年始に作り直しをしたばかりなのですが、毎年の様に「このプラグインなんだっけ・・・？」「コレ全然使ってねぇな・・・」と分からなくなり作り直すを繰り返していました。

で、今年はleaf.elを導入して、これから説明する様な構成にしたところ、思った以上に個人的にメンテしやすい/何がやってるかわかりやすいinit.elができたので共有しようと思います。

つまり **一個人の例として、見やすいinit.elができたから紹介するよ** というお話です。

# アレやらないの？

よくある例としては、

* 設定ごとに細かくファイルを分けてわかりやすくする
* org-mode使って文芸的にinit.elを作成する

ですが、僕個人の好みとして、ファイル分かれてると見失いやすい(1ファイルで完結して欲しい)、orgは面倒で二の足踏んでしまった という点で、1ファイル完結&org無しでinit.elを作っています。

# 要点は？

* leaf.el使って構造化する
* 日本語を使う

です。

# 設定例

```lisp
  (leaf *一般設定=========================================================================
    :config

    (leaf *言語設定-----------------------------------------------------------------------
      :doc "Emacsが扱う文字コードの設定"
      :config
      (set-language-environment "Japanese")
      (prefer-coding-system  'utf-8-unix))

    (leaf *日本語入力設定-----------------------------------------------------------------
      :config
      (leaf mozc
        :ensure t
        :require t
        :doc "mozcとの接続設定（GUIかつLinuxの時）"
        :when window-system
        :when (eq system-type 'gnu/linux)
        :bind (("C-SPC"   . toggle-input-method))
        :custom (default-input-method . "japanese-mozc"))
      )

    (leaf *Windowsでの文字化け対策--------------------------------------------------------
      :doc "外部プロセスとのやりとりや外部コマンド実行で文字化けを防ぐ"
      :doc "「windowsネイティブのemacs（wslではない）で外部プロセス連携がうまく行かないときに出てきた話だったはず」とのコメントもらいました"
      :when (memq system-type '(cygwin windows-nt ms-dos))
      :config
      (setq-default default-process-coding-system '(utf-8-unix . japanese-cp932-dos)))

    (leaf *ビープ音を無効化する-----------------------------------------------------------
      :doc "visible-bell設定入れようかとも思ったけど、macだと画像出る様になってて鬱陶しかったので無効に"
      :doc "(この設定だと、visible-bellも無効になる（警告音/画面フラッシュも全部無効）)"
      :custom (ring-bell-function . 'ignore))

    (leaf *yes-or-noをy-or-nに変更--------------------------------------------------------
      :custom (use-short-answers . t))
〜〜〜
```

どうでしょう？僕は昔はコメントで構造化していたのですが、視認性良くないですか？

# 小技

![](/images/20251208-emacs-advent-calendar/image1.png)

こんな感じで、init.elを開いて、`(leaf`で検索をかけると、その構造が一目瞭然です。

# 実物見てみたい

ここに置いてます

https://github.com/nakazye/dotfiles/tree/master/dot_config/emacs

# 結び

同じようにやってみよう！という人は少ないと思いますが、ここからleaf.elを使った便利な何かのインスピレーションになれば幸いです。

