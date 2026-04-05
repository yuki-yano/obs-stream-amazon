# obs-stream-amazon

OBS で Amazon の画面を配信や録画に取り込むときに、配送先住所や個人情報を映さないための最小構成をまとめたリポジトリです。

このリポジトリでは、次の 2 パターンをすぐ試せるようにしています。

- `Browser Source` で Amazon を直接読み込み、`Custom CSS` で住所表示を消す
- `Window Capture` で専用ブラウザだけを取り込み、ブラウザ側の user CSS で住所表示を消す

「絶対に映したくない」という要件に対しては、`OBS で後からぼかす` よりも `そもそも住所を描画させない` 方が安全です。

## 推奨構成

最優先で推奨するのは次の構成です。

1. OBS では `Display Capture` を使わない
2. Amazon 用の専用シーンを作る
3. 取り込みは `Browser Source` か `Window Capture` のどちらかに限定する
4. 住所は CSS で非表示にする
5. さらに OBS 側で固定クロップか黒帯を重ねる
6. 配信開始前に `Studio Mode` で毎回プレビュー確認する

## 同梱ファイル

- `templates/obs-browser-source-custom.css`
  - OBS の `Browser Source > Custom CSS` に貼り付ける想定の CSS
- `templates/stylus-hide-address.user.css`
  - Stylus などの user CSS 拡張に読み込ませる想定の CSS

## CSS の開き方

README 上のリンクから raw URL を別タブで開いて、その内容をそのままコピーして使ってください。

- Browser Source 用:
  - <a href="https://raw.githubusercontent.com/yuki-yano/obs-stream-amazon/main/templates/obs-browser-source-custom.css" target="_blank" rel="noopener noreferrer">raw URL を開く</a>
- Stylus / user CSS 用:
  - <a href="https://raw.githubusercontent.com/yuki-yano/obs-stream-amazon/main/templates/stylus-hide-address.user.css" target="_blank" rel="noopener noreferrer">raw URL を開く</a>

## パターンA: Browser Source で取り込む

最も安全寄りの方法です。Amazon の DOM に対して CSS を直接適用できるため、住所を描画前に隠せます。

### 手順

1. OBS で新しいシーンを作る
2. `Browser Source` を追加する
3. URL に Amazon の対象ページを設定する
4. 下の raw URL を別タブで開いて CSS をコピーする
5. `Browser Source > Custom CSS` に貼り付ける
6. 必要に応じて `Crop/Pad` でヘッダ上部を少し削る
7. 事故防止のため、ヘッダ位置に細い黒帯ソースを重ねる

### コピー用リンク

<a href="https://raw.githubusercontent.com/yuki-yano/obs-stream-amazon/main/templates/obs-browser-source-custom.css" target="_blank" rel="noopener noreferrer">obs-browser-source-custom.css を raw で開く</a>

### 運用メモ

- Amazon 側の DOM 変更で selector が効かなくなる可能性があります
- そのため、CSS だけに頼らず固定クロップか黒帯を必ず併用してください
- URL 遷移で別ページに移ると別の住所表示要素が出ることがあるため、本番前に目的画面を一通り踏んで確認してください
- Windows では `Window Capture` の `Client Area` を使うとブラウザ枠の映り込みを減らしやすいです

## パターンB: Window Capture で取り込む

Browser Source が使いづらい場合の代替です。専用ブラウザを 1 つだけ用意して、ブラウザ側で住所を消します。

### 手順

1. Amazon 専用のブラウザプロファイルか専用ブラウザを用意する
2. Stylus などの user CSS 拡張を入れる
3. 下の raw URL を別タブで開いて CSS をコピーする
4. OBS の `Window Capture` でそのブラウザだけを取り込む
5. 取り込み範囲の上部に固定クロップか黒帯を入れる

### コピー用リンク

<a href="https://raw.githubusercontent.com/yuki-yano/obs-stream-amazon/main/templates/stylus-hide-address.user.css" target="_blank" rel="noopener noreferrer">stylus-hide-address.user.css を raw で開く</a>

### 運用メモ

- 専用ブラウザ以外は取り込まないでください
- タブ切り替え事故を避けるため、Amazon 用ブラウザは 1 ウィンドウ 1 タブ運用が安全です
- 可能なら OBS のホットキーで `待機シーン` を用意し、事故時に即切り替えできるようにしてください

## Windows ユーザ向けの補足

Windows では `Window Capture` の運用が特に現実的です。専用の Chrome / Edge プロファイルを作り、そこに Stylus を入れて住所非表示 CSS を適用し、そのウィンドウだけを OBS で取る構成にすると事故面積を狭められます。

### 推奨手順

1. Chrome か Edge で Amazon 専用プロファイルを作る
2. Stylus を入れる
3. 下の raw URL を別タブで開いて CSS をコピーする
4. Stylus に登録する
5. OBS の `Window Capture` でその専用ウィンドウだけを選ぶ
6. `Capture Method` は既定のままではなく、安定するものを実機で確認する
7. 上端には固定の黒帯を重ねる

### コピー用リンク

<a href="https://raw.githubusercontent.com/yuki-yano/obs-stream-amazon/main/templates/stylus-hide-address.user.css" target="_blank" rel="noopener noreferrer">stylus-hide-address.user.css を raw で開く</a>

## OBS 側の追加対策

CSS で非表示にしても、運用としては次を追加してください。

- `Display Capture` は使わない
- `Studio Mode` を常用する
- Amazon 用シーンはロックする
- 上部ヘッダ帯に `Color Source` の黒帯を常設する
- `待機シーン` と `緊急遮断シーン` をホットキーに割り当てる
- 配信前チェックリストを作り、住所表示がないことを確認する

## 注意点

- Amazon の HTML 構造は継続的に変わるため、CSS selector は将来的に更新が必要です
- このリポジトリの CSS は `amazon.co.jp` と `amazon.com` の代表的な住所表示箇所を対象にしています
- `絶対に映さない` を満たすには、`CSSで隠す` と `OBSで固定的に隠す` を二重化する前提で運用してください

## 更新方針

住所表示の selector が変わった場合は、次のどちらかを更新してください。

- OBS の Browser Source を使う場合: `templates/obs-browser-source-custom.css`
- Stylus などを使う場合: `templates/stylus-hide-address.user.css`
