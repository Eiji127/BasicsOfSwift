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

// ↓わかりやすい例
protocol RandomValueGenerator {
    associatedtype Value
    
    func randomValue() -> Value
}

struct IntegerRandomValueGenerator: RandomValueGenerator {
    func randomValue() -> Int {
        return Int.random(in: Int.min...Int.max)
    }
}

struct StringRandomValueGenerator: RandomValueGenerator {
    func randomValue() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let offset = Int.random(in: 0..<letters.count)
        let index = letters.index(letters.startIndex, offsetBy: offset)
        return String(letters[index])
    }
}
/*
 ↑ RandomValueGeneratorプロトコルでまず連想型としてValue型を指定し、準拠した構造体はInt型やString型などへと指定されるようになっている
 → 1つの型に依存しない抽象的な性質を持った定義が可能となる
 */

// - 型制約の追加
/*
 ・プロトコルの連想型が準拠すべきプロトコルや継承すべきスーパークラスを指定することで、連想型に制約に設けることができる
 protocol プロトコル名 {
    associatedtype 連想型名: プロトコル名またはスーパークラス名
 }
 
 ・より詳細な制約の設定をするときはwhere節を追加する
 → where節では、プロトコルに準拠する型自身をSelfキーワードで参照することができ、その連想型も.を付けてSelf.連想型のように参照することが可能
 → Selfキーワードを省略して連想型とすることも可能
 */

class SomeClass {}

protocol SomeProtocol5 {
    associatedtype AssociatedType: SomeClass
}

class SomeSubClass: SomeClass {}

struct ConformedStruct: SomeProtocol5 {
    typealias AssociatedType = SomeSubClass
}
/*
struct NonConformedStruct: SomeProtocol5 {
    typealias AssociatedType = Int // コンパイルエラー(IntはSomeClassのサブクラスではない)
}
 
 → 連想型AssociatedTypeにSomeClass型を継承していなければならないという制約を設けている
*/

protocol Container {
    associatedtype Content
}

protocol SomeData {
    associatedtype ValueContainer: Container where
        ValueContainer: Equatable
}
/*
 ↑ SomeDataプロトコルの連想型ValueContainerの連想型Contentが、
 Equatableプロトコルに準拠するという制約を課している
 */

protocol Container2 {
    associatedtype Content
}

protocol SomeData2 {
    associatedtype ValueContainer: Container2 where
        ValueContainer.Content == Int
}
/*
 ↑ ==による型の一致の制約も設定可能(SomeDataプロトコルの連想型ValueContainerの連想型ContentがInt型であるという制約を設けている)
 */

protocol Container3 {
    associatedtype Content
}

protocol SomeData3 {
    associatedtype Value
    associatedtype ValueContainer: Container3 where
        ValueContainer.Content: Equatable, ValueContainer.Content == Value
}
/*
 ↑ 型制約を複数指定することが可能(SomeData3プロトコルの連想型ValueContainerの連想型Contentが、Equatableプロトコルに準拠し、なおかつ別の連想型Valueと一致するという制約を設けている)
 */

// - クラス専用プロトコル
protocol SomeClassOnlyProtocol: class {}
/*
 ・準拠する型をクラスのみに限定できる
 ・準拠する型が参照型であることが想定する場合に使用する
 */
// MARK: -
// MARK: -
// MARK: -

// MARK: -
// MARK: -
// MARK: -

// MARK: -
