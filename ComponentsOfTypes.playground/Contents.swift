// MARK: - 型に共通するもの
/*
 Swiftの型
 ・クラス
 ・構造体
 ・列挙型
 → 標準ライブラリの型の多くが構造体
 → Cocoaのほとんどの型がクラス
 */

/*
 [共通点]
 ・型が持つ値を保存するプロパティ
 ・型の振る舞いを表すメソッド
 
 [他の特性]
 ・初期化を行うイニシャライザ
 ・コレクションの要素を取得するサブスクリプト
 ・型内に型を定義するネスト型
 が存在
 */
// MARK: - プロパティ

// 1. インスタンスプロパティ
/*
 [Feature]
 ・型のインスタンスに紐付くため、インスタンスごとに異なる値を持たせることができる
 ・varキーワードやletキーワードで定義したプロパティは、デフォルトではインスタンスプロパティを指す
 */
struct Greeting1 {
    var to = "Yosuke Ishikawa"
    let body = "Hello!, "
}

let greeting1_1 = Greeting1()
var greeting1_2 = Greeting1()
greeting1_2.to = "Yusei Nishikawa" //

let greet1_1 = greeting1_1.body + greeting1_1.to
let greet1_2 = greeting1_2.body + greeting1_2.to

print(greet1_1)
print(greet1_2)

/*
 実行結果：
 Hello!, Yosuke Ishikawa
 Hello!, Yusei Nishikawa
 
 → greeting1とgreeting2のtoが異なる
 */

// 2. スタティックプロパティ
/*
 [Feature]
 ・型のインスタンスではなく型自身に紐付くプロパティ
 ・インスタンス間で共通する値の保持などに使用する
 ・定義方法はプロパティ宣言の先頭にstaticキーワードを追加する
 */
struct Greeting2 {
    static let signature = "Sent from iPhone"
    
    var to = "Yosuke Ishikawa"
    var body = "Hello!"
}

func print(greeting: Greeting2) {
    print("to: \(greeting.to)")
    print("body: \(greeting.body)")
    print("signature: \(Greeting2.signature)")
}

let greeting2_1 = Greeting2()
var greeting2_2 = Greeting2()
greeting2_2.to = "Yusei Nishikawa"
greeting2_2.body = "Hi"

print(greeting: greeting2_1)
print("--")
print(greeting: greeting2_2)
/*
 実行結果：
 to: Yosuke Ishikawa
 body: Hello!
 signature: Sent from iPhone
 --
 to: Yusei Nishikawa
 body: Hi
 signature: Sent from iPhone
 */

// 3. ストアドプロパティ
/*
 ストアドプロパティ：値を保持するプロパティ
 ↑
 ↓
 コンピューテッドプロパティ：値を保持しないプロパティ
 */
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -

