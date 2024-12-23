# ベースイメージに適切なOSを選択 (Debianを例にしています)
FROM debian:bullseye-slim

# 必要なツールをインストール
RUN apt-get update && apt-get install -y \
    # curl: GHCupのインストールスクリプトをダウンロードするために必要
    curl \
    # build-essential: GHCでのビルドに必要なコンパイラツールチェーン (gcc, make など)
    build-essential \
    # libncurses-dev: GHCのインタラクティブモード (ghci) が動作するために必要なライブラリ
    libncurses-dev \
    # zlib1g-dev: 圧縮ライブラリ (zlib) の開発ヘッダー、Haskellの一部ライブラリで使用
    zlib1g-dev \
    # xz-utils: 圧縮形式 xz の解凍ツール、GHCのインストール中に使用されることがある
    xz-utils \
    # git: Haskellプロジェクトの依存関係やソースコードを管理するために必要
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# GHCupのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh -s -- --no-verbose

# GHCupの設定を反映
ENV PATH="/root/.ghcup/bin:${PATH}"

# デフォルトのGHCとCabalをインストール
RUN ghcup install ghc && \
    ghcup set ghc $(ghcup show ghc | grep "^\*" | awk '{print $2}') && \
    ghcup install cabal && \
    ghcup set cabal $(ghcup show cabal | grep "^\*" | awk '{print $2}')

# コンテナ作業ディレクトリ
WORKDIR /app

# 確認のためにバージョンを表示
RUN ghc --version && cabal --version

# デフォルトコマンド (対話的なHaskell環境を提供)
CMD ["ghci"]
