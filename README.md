# Best Guess

Simple script to determine the best guesses for wordle, using a naive calculation of "which letters are most common?"


## Usage

```shell
perl bestGuess.pm /path/to/word/list.txt
```

The input word list is a file containing each word in the vocabulary (may include words which are not valid for candidates), one word per line.

## Example

```shell
$ perl bestGuess.pm names.txt
♀: 1
♂: 1
ァ: 2
ア: 23
ィ: 9
イ: 45
ウ: 22
ェ: 3
エ: 11
ォ: 2
オ: 25
カ: 24
ガ: 16
キ: 28
ギ: 11
ク: 41
グ: 29
ケ: 4
ゲ: 8
コ: 11
ゴ: 13
サ: 15
ザ: 10
シ: 24
ジ: 17
ス: 52
ズ: 9
セ: 5
ゼ: 3
ソ: 4
ゾ: 1
タ: 22
ダ: 16
チ: 15
ッ: 40
ツ: 7
テ: 12
デ: 9
ト: 41
ド: 48
ナ: 14
ニ: 21
ヌ: 2
ネ: 7
ノ: 17
ハ: 13
バ: 17
パ: 10
ヒ: 5
ビ: 6
ピ: 6
フ: 17
ブ: 14
プ: 7
ヘ: 1
ベ: 8
ペ: 4
ホ: 3
ボ: 12
ポ: 8
マ: 34
ミ: 15
ム: 15
メ: 12
モ: 8
ャ: 14
ヤ: 10
ュ: 14
ユ: 6
ョ: 7
ヨ: 4
ラ: 58
リ: 46
ル: 55
レ: 22
ロ: 26
ワ: 8
ン: 87
ー: 111
２: 1
Ｚ: 1
Ranking:
グラードン: 333
ジーランス: 325
レントラー: 319
キングラー: 313
ヒードラン: 309
ドータクン: 309
ネンドール: 308
ルナトーン: 308
リザードン: 302
ビークイン: 290
ザングース: 289
トドグラー: 287
リーシャン: 282
サンダース: 281
スカンプー: 281
ワンリキー: 280
ハンテール: 278
バクフーン: 273
ダークライ: 271
アーマルド: 271
ユンゲラー: 270
Best Guesses:
1. グラードン: 333
2. チルタリス: 190
3. クロバット: 165
4. キレイハナ: 122
5. アズマオウ: 113
6. ワカシャモ: 78
```
