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

// 3. 連想値
/*
 ・連想値(associated type)によって、プロトコルの準拠時にプロパティ、メソッドの引数、戻り値の型を指定することができる
 → 1つの型に依存しない、より抽象的なプロトコルを定義することが可能
 ・associatedtypeキーワードを使用する
 
 protocol プロトコル名 {
    associatedtype 連想型名
    var プロパティ名； 連想型名
    func メソッド名(引数名: 連想型名)
    func メソッド名() -> 連想型名
 }
 */
protocol SomeProtocol4 {
    associatedtype AssociatedType
    
    // 連想型はプロパティやメソッドでも使用可能
    var value: AssociatedType { get }
    func someMethod(value: AssociatedType) -> AssociatedType
}

// AssociatedTypeを定義することで要件を満たす
struct SomeStruct4_1 {
    typealias AssociatedType = Int
    
    var value: AssociatedType
    func someMethod(value: AssociatedType) -> AssociatedType {
        return 1
    }
}

// 実装からAssociatedTypeが自動的に決定する
struct SomeStruct4_2: SomeProtocol4 {
    var value: Int
    func someMethod(value: Int) -> Int {
        return 1
    }
}

// ネスト型AssociatedTypeを定義することで要求を満たす
struct SomeStruct4_3: SomeProtocol4 {
    struct AssociatedType {}
    
    var value: AssociatedType
    func someMethod(value: AssociatedType) -> AssociatedType {
        return AssociatedType()
    }
}

// MARK: -
// MARK: -
// MARK: -

// MARK: -
// MARK: -
// MARK: -

// MARK: -
