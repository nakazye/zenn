{
  description = "Zenn CLI development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.zenn-cli ];

          shellHook = ''
            echo "Zenn CLI 開発環境へようこそ!"
            echo ""
            echo "利用可能なコマンド:"
            echo "  zenn init          - Zennコンテンツ用のディレクトリを初期化"
            echo "  zenn new:article   - 新しい記事を作成"
            echo "  zenn new:book      - 新しい本を作成"
            echo "  zenn preview       - ブラウザでプレビュー (http://localhost:8000)"
            echo ""
            echo "記事作成の例:"
            echo "  zenn new:article --slug my-article --title \"タイトル\" --type tech --emoji 📝"
          '';
        };
      }
    );
}
