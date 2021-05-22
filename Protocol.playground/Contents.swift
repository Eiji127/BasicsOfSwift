// MARK: - 型のインターフェースを定義する目的(プロトコルを用意する理由)
/*
 ・プロトコル：型が特定の性質や機能を持つために必要なインターフェースを定義するもの
 ・準拠：プロトコルが要求するインタフェースを型が満たすこと
 ・プロトコルを利用することで、複数の型で共通となる性質を抽象化できる
 */

func printIfEqual<T: Equatable>(_ arg1: T, _ arg2: T) {
    if arg1 == arg2 {
        print("Both are \(arg1)")
    }
}

printIfEqual(123, 123)
printIfEqual("str", "str")
/*
 実行結果：
 Both are 123
 Both are str
 
 → 渡せる引数の型をEquatableプロトコルに準拠している型に制限している
 → Int型もString型もEqatableプロトコルに準拠しているのでOK!!
 */
// MARK: - プロトコルを構成する要素
// 1. プロパティ
/*
 ・常にvarキーワードで宣言する
 ・{}内にゲッタ、セッタの有無に応じてそれぞれgetキーワードとsetキーワードを追加する
 ・プロトコルにはストアドプロパティとコンピューテッドプロパティの区別がない
 */

// - ゲッタの実装
protocol SomeProtocol {
    var id: Int { get }
}

// 変数のストアドプロパティ
struct SomeStruct1: SomeProtocol {
    var id: Int
}
// 定数のストアドプロパティ
struct SomeStruct2: SomeProtocol {
    let id: Int
}

// コンピューテッドプロパティ
struct SomeStruct3: SomeProtocol {
    var id: Int {
        return 1
    }
}

// - セッタの実装
protocol SomeProtocol2 {
    var title: String { get set }
}

// 変数のストアドプロパティ
struct SomeStruct2_1: SomeProtocol2 {
    var title: String
}

// 定数のストアドプロパティ
//struct NGSomeStruct: SomeProtocol2 {
//    let title: String // コンパイルエラー(Type 'NGSomeStruct' does not conform to protocol 'SomeProtocol2')
//}

//コンピューテッドプロパティ
struct SomeStruct2_2: SomeProtocol2 {
    var title: String {
        get {
            return "title"
        }
        set {}
    }
}

// 2. メソッド
protocol SomeProtocol3 {
    func someMethod() -> Void
    static func someStaticMethod() -> Void
}

struct SomeStruct3_1: SomeProtocol3 {
    func someMethod() {
        // メソッドの実装
    }
    
    static func someStaticMethod() {
        // メソッドの実装
    }
}
// MARK: -
// MARK: -
// MARK: -

// MARK: -
// MARK: -
// MARK: -

// MARK: -
