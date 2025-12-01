---
title: "nix使ったAdvent Calendar執筆環境構築"
emoji: "❄️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["nix"]
published: false
---

この記事は[Nix Advent Calendar 2025](https://adventar.org/calendars/11657) 2日目の記事です。

昨日はnatsukiumさんの[Nixと文芸的プログラミング](https://adventar.org/calendars/11657)でした。

# この記事は？

nixのことは聞いたことがあるけど何ができるか分からない。難しそうというイメージはある。という人に向けた入門記事です。

いろいろなことができるnixですが、その中でも

* 使い回しの利く開発ツールセットを「一時的に」導入する
* ↑で作ったツールセットを、特定ディレクトリ配下でのみ「一時的に」有効化する
* ちょっとだけ使ってみたいツールを「一時的に」導入する

に焦点を当てた記事です。

もちろんnixでは「一時的では無い」環境構築もできるので（むしろそっちが主だと思う）、この記事でふんわり雰囲気を掴んで頂き、その後に他のAdvent Calendar記事などを見ながらご自身の環境を育てて頂けたら良いななんて思ってます。

# 何をするの？

もしこのAdvent Calendarを見ているなら、Advent Calendarという概念を知っていて、そして自分でも記事を書いてみたいと思ってる（もしくは既に書いた）でしょう。

僕もそんな形で例年見るだけな人ですが、今回この記事で解説する内容に従ってZennで記事を書く環境を構築し（後述）、ついでにこの記事で解説する方法に従ってSpaceVimを導入し、それで記事を書いてます。

ということで、

* zenn-cliを導入する為の設定を作成し、devShellと呼ばれる機能を使って読み込む
* direnvを導入して、自動的にdevShellを読み込む
* nix-shellと呼ばれる機能を使って、spacevimを一時的に導入する

を解説していこうと思います。

# やってみよう！

まずはnixの導入からしなければなりません。

## nixの導入

nixという言葉には、コンテキストによっていろいろな意味を持ちますが、ここではnixコマンドの導入くらいな意味で「nixの導入」という言葉を使っています。

つまり、コマンドなので、叩かない限り何か悪さをすることは無いです。

ただし、お使いの環境ややりたいことによって、nixネイティブなOSを突っ込んでしまうという選択肢もあります。

* 今Mac、もしくはLinuxを使っているよ(WSL含む) -> [nix-installerによるセットアップ](https://zenn.dev/asa1984/books/nix-hands-on/viewer/ch00-02-setup)
* 今Windowsを使っているよ。wsl使ってないよ -> [wsl2 nixosのインストール](https://zenn.dev/tositada/books/1c1564531ec8fc/viewer/cdf4de)
* 今、OSが入ってないPCがあるんだよね -> [nixosのインストール](https://note.com/nokiyameego/n/n788264b57721)

## タイトルの回収：zenn-cliの導入

僕がこの記事を書くにあたって(Advent Calendarに参加するにあたって)、zennのアカウントを作成しました。

で、zenの記事を書くにあたって、Web上でも執筆は可能だとは思いますが、githubと連携して、markdownを用いて記事執筆ができることを知りました。

で、コレから説明するnixの機能を使って、そこで必要なツール([zenn-cli](https://zenn.dev/zenn/articles/install-zenn-cli))を導入していきます。

### nix.flakeの作成

https://github.com/nakazye/zenn/blob/main/flake.nix

zenn執筆用のリポジトリを作り、その中に↑の様なファイルを配置しています。

このファイル自体はAIに書いて貰いましたが、ポイントとしては`buildInputs = [ pkgs.zenn-cli ];`です。

これは、このflake.nixを後述の方法で読み込むと、zenn-cliが有効になるよ ということを意味しています。

今はzenn執筆の環境として作っているのでこれだけですが、通常の開発で使う場合は、ここに開発に必要な環境を並べ立てて一括してツールをセットアップすることができます（かつ、グローバル環境を汚さず一時的に）。

### devShellの利用

flake.nixの中に`devShells.default = pkgs.mkShell`という記載がありますが、devShellなる機能を用いてこのファイルを読み込みます。

nixにおいては、home-managerと呼ばれる機能を使って、ユーザが通常利用するツール群をセットアップすることができます。

一方、ここで利用しようとしているdevShellについては、一時的な利用となります。使いたい時だけ使える状態にして、その後は無効にできる機能です。

nixを初めて使ってみたい！という場合は、このdevShellから始めるのが良いのではと思ってます。

ということで使ってみましょう。

```shell
git add flake.nix
nix develop
```

![](/images/20251202-nix-advent-calendar/image1.png)

nixの特性上、flake.nixがgit管理されている必要があります。よってもって、最初にgit addするのを忘れないでください。

その上で`nix develop`を実行すると、必要な設定がされて、かつshellのプロンプトも変わったことがわかると思います。

もちろんプロンプトだけでなく、shell自体が変わっており、つまり`exit`で抜けることができます。

exitで抜けた後にwichを実行しても、zennコマンドが出てこないことを確認できます。

exitで抜けるまで有効な環境ということですね。

さぁ、これでzenn-cliが有効化され、Advent Calendarを書く準備が整いました！

まだ参加Advent Calendarに参加されていない場合は、これを機にnixとzenn-cliを導入し、zennで記事を書いてみるのはいかがでしょうか？

## 毎回nix developが面倒

その場合、一歩進んで？[direnv](https://zenn.dev/asa1984/books/nix-hands-on/viewer/ch02-03-devshell#direnv)というツールを用いることで、当該ディレクトリに入った時に自動で有効化し、抜けたら自動で無効化することもできます。

詳しい解説はここでは省きますが、[普通にインストールする方法](https://direnv.net/docs/installation.html)と、home-managerを用いている場合は[nix-direnv](https://github.com/nix-community/nix-direnv)を用いて簡単に設定する方法があります。

なお、私は以下の様な感じでhome-managerの設定を入れています。

https://github.com/nakazye/nix-config/blob/master/home-manager/programs/direnv/default.nix

※home-manager?なんのこっちゃ？な人は、まずはdevShellに触れてみた後に、次のステップアップとして色々と調べてみると良いと思ってます。

## flake.nixの準備が面倒

そんなあなたに朗報です。nix-shellという機能を用いることで、特定のアプリケーションを一時的に利用することが可能です。

お試しにちょっと使ってみたい・・・なんていう時に便利ですね。

技術記事を書く対象をちょっと触れてみて、深掘りするか考える・・・といった利用も楽しいかもしれません。

flake.nixで指定するアプリケーションもそうですが、nix-shellで利用するアプリケーションについても

[https://search.nixos.org/packages](https://search.nixos.org/packages)

で調べることができます。

今この記事を書いている僕ですが、どうせなので何かいつもと違うエディタで書いてみようかな・・・と上記サイトで調べてみたところ、[spacevim](https://search.nixos.org/packages?channel=25.11&show=spacevim&query=spacenvimhttps://search.nixos.org/packages?channel=25.11&show=spacevim&query=spacenvim)を見つけたので、その機能を用いてお試し導入したspacevimで本記事を書いています。

```shell
nix-shell -p spacevim
spacenvim
```

でspacenvimを立ち上げ（spacevimとspacenvimの二つが使えるみたいです）その環境で本記事を執筆しています。

![](/images/20251202-nix-advent-calendar/image2.png)

ambiwidthがおかしな感じになっている様に見えますが、お試し利用なのでとりあえずコレで良いか・・・と使ってみてます。

こちらも、同様に`exit`で抜けることで利用を終えることができます。

## 普通はどんな感じでdevShell使うの？

zenn-cliの為にdevShellを使う・・・なんていうことは、まぁ普通は無いと思います。

通常、開発において必要な言語/ビルドツール を詰めて利用することが多いと思ってます。

バージョンを指定したり、プロジェクト毎に違うツールを使い分けたり・・・などなど、グローバルを汚さず使い分けをできるのは便利です。

## もっと色々と使ってみたい

home-managerを学んでみる/使える様にするのが良いと思ってます。

僕は、Mac利用になりますが、kawarimidollさんの[Homebrew管理下のCLIをNixに移してみる](https://zenn.dev/kawarimidoll/articles/0a4ec8bab8a8ba)で基本的な部分を学んだと思ってます。

WSL環境も作っていますが、[こちらの記事](https://zenn.dev/tositada/books/1c1564531ec8fc/viewer/0e5eeb)も参照しながら学んだ記憶があります。

このAdvent Calendarにも、きっと（僕みたいな）初心者にも優しい記事が沢山でると思います。一緒に楽しんで行きましょう

# 最後に

この記事を書く為に、ここで説明したのもそうですが、zennのアカウントも初めて作ってみました。

つまり、この記事は僕の初のzennの記事になります。

この記事を楽しんで・・・貰える人がいるかどうかは分かりませんが、Nixの年末の賑やかしに多少でも貢献できればと思ってます。

ということで、皆様もよきNixライフを！

