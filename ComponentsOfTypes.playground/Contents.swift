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
 ・ストアドプロパティとコンピューテッドプロパティは値を保持するかどうかによる分類
 ・インスタンスプロパティにもスタティックプロパティにもなり得る
 ストアドプロパティ：値を保持するプロパティ
 ↑
 ↓
 コンピューテッドプロパティ：値を保持しないプロパティ
 */

struct SomeStruct1 {
    var variable = 123
    let constant = 456
    static var staticVariable = 789
    static let staticConstant = 890
}

let someStruct = SomeStruct1()
print(someStruct.variable)
print(someStruct.constant)
print(SomeStruct1.staticVariable)
print(SomeStruct1.staticConstant)

// プロパティオブザーバ
/*
 [Feature]
 ・ストアドプロパティの値を変更を監視し、変更前と変更後に文を実行する
 ・プロパティオブザーバを定義するには、変更前に実行するwillSetキーワードあるいは変更後に実行するdidSetキーワードを指定する
 */

struct Greeting3 {
    var to = "Yosuke Ishikawa" {
        // 値の変更前
        willSet {
            print("willSet: (to: \(self.to), newValue: \(newValue))")
        }
        // 値の変更後
        didSet {
            print("didSet: (to: \(self.to))")
        }
    }
}

var greeting3 = Greeting3()
greeting3.to = "Yusei Nishikawa" // ここで変更前willSetのクロージャと変更後didSetのクロージャ内の内容が呼ばれる

/*
 実行結果:
 willSet: (to: Yosuke Ishikawa, newValue: Yusei Nishikawa)
 didSet: (to: Yusei Nishikawa)
 */

// - レイジーストアドプロパティ

/*
 [Feature]
 ・アクセスされるまで初期化を遅延させる
 ・varキーワード前にlazyキーワードを追加することで定義する(letキーワードには使用不可)
 */

struct SomeStruct2 {
    var value: Int = {
        print("valueの値を生成します")
        return 1
    }()
    
    lazy var lazyValue: Int = {
        print("lazyValueの値を生成します")
        return 2
    }()
}

var someStruct2 = SomeStruct2()
print("SomeStruct2をインスタンス化します")
print("valueの値を\(someStruct2.value)です")
print("lazyValueの値は\(someStruct2.lazyValue)です")
/*
 実行結果:
 valueの値を生成します
 SomeStruct2をインスタンス化します
 valueの値を1です
 lazyValueの値を生成します
 lazyValueの値は2です
 
 → 通常のストアドプロパティはインスタンス化時に初期化が実行され、レイジーストアドプロパティはアクセス時に初期化が行われる
 → レイジーストアドプロパティを利用することで、初期化コストの高いプロパティの初期化をアクセス時にまで延ばすことができ、
 アプリケーションのパフォーマンスを向上させることが可能！！
 
 */

// 4. コンピューテッドプロパティ
/*
 [Feature]
 ・コンピューテッドプロパティ：プロパティ自身では値を保持しておらず、すでに存在するストアドプロパティなどから計算して値を返すプロパティ
 ・アクセスごとに値を計算し直すので、計算元の値との整合性が常に保たれる
 ・定義するには、getキーワード(ゲッタ)とsetキーワード(セッタ)を使用する
 ・ゲッタ：プロパティの値を返す処理
 ・セッタ：プロパティの値を更新する処理
 */

// - ゲッタ ← 値の返却
struct Greeting4 {
    var to = "Yosuke Ishikawa"
    var body: String {
        // ほかのストアドプロパティなどから値を取得し、コンピューテッドプロパティの値として返している
        get {
            return "Hello, \(to)!" // ストアドプロパティtoを利用可能
        }
    }
}

let greeting4 = Greeting4()
print(greeting4.body) // 実行結果： Hello, Yosuke Ishikawa!

// - セッタ ← 値の更新
/*
 [Feature]
 ・下記の例のように一方のプロパティの値が変更されたら、もう一つのプロパティの値も変更するときに有効
 ・インスタンスの更新方法が複数あるが、プロパティ同士の整合性をもたせたいときに有用
 */
struct Temperature {
    var celsius: Double = 0.0
    
    var fahrenheit: Double {
        get {
            return (9.0 / 5.0) * celsius + 32.0
        }
        
        set {
            return celsius = (5.0 / 9.0) * (newValue - 32.0)
        }
    }
}

var temparature = Temperature()
print("Celsius: \(temparature.celsius), Fahrenheit: \(temparature.fahrenheit)") // Celsius: 0.0, Fahrenheit: 32.0

temparature.celsius = 20
print("Celsius: \(temparature.celsius), Fahrenheit: \(temparature.fahrenheit)") // Celsius: 20.0, Fahrenheit: 68.0

temparature.fahrenheit = 32
print("Celsius: \(temparature.celsius), Fahrenheit: \(temparature.fahrenheit)") // Celsius: 0.0, Fahrenheit: 32.0

// セッタで暗黙的に宣言された定数newValueには、()内に定数名を追加することで任意の名前を与えることが可能
struct Temparature2 {
    var celsius: Double = 0.0
    
    var fahrenheit: Double {
        get {
            return (9.0 / 5.0) * celsius + 32.0
        }
        
        set(newFahrenheit) {
            celsius = (5.0 / 9.0) * (newFahrenheit - 32.0)
        }
    }
}

// - セッタの省略

/*
 ・コンピューテッドプロパティはゲッタの定義は必須であるが、セッタの定義は任意
 ・セッタが存在しないとき、getキーワードと{}を省略することができる
*/
struct Greeting5 {
    var to = "Yosuke Ishikawa"
    var body: String {
        return "Hello, \(to)"
    }
}

let greeting5 = Greeting5()
print(greeting5.body)
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -

