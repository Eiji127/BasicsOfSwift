// MARK: - ジェネリクスとは
/*
 ・ジェネリクス：型をパラメータとして受け取ることで汎用的なプログラムを記述するための機能
 ・Swiftではジェネリクス関数とジェネリック型として提供している
 → 関数や型を汎用的なかつ型安全に記述することが可能
 */
// 例
// ジェネリクスを使用しない時
func isEqual() -> Bool {
    return 1 == 1
}

func isEqual(_ x: Int, _ y: Int) -> Bool {
    return x == y
}

isEqual() // true
isEqual(1, 1) // true

// ジェネリクスを使用した時
func isEqual<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}

isEqual("abc", "def")
isEqual(1.0, 3.14)
isEqual(false, false)
/*
 ・ジェネリクスの基本的なコンセプトとしては入力値の型も任意にすることによりプログラムの汎用性を向上すること
 ↑ 「Equatableプロトコルに準拠したあらゆる型」を引数として指定することができる
 */

// MARK: - ジェネリクスの基本
/*
 [定義方法]
 func 関数名<型引数>(引数名: 型引数) -> 戻り値の型 {
    関数呼び出し時に実行される文
 }
 
 ・型引数は<>で囲む
 ・複数あるときは<T, U>のように定義する
 */
func someFunction<T, U>(x: T, y: U) -> U {
    let _: T = x // 型アノテーションとして使用
    let _ = x // 型推論に対応
    let _ = 1 as? T // 型のキャストに対応
    return y
}
/*
 ・Optinal<Wrapped>型やArray<Element>型などの<>内にプレースホルダ型を持つ型をジェネリック型という。
 → プレースホルダ型 = 型引数
 */

// 1. 特殊化方法
/*
 ・実際にジェネリック関数を呼び出したり、ジェネリック型をインスタンス化したりするときに、型引数に具体的な型を指定する必要がある
 → 特殊化(specialization)：ジェネリクスを使用して汎用的に定義されたものに対して、具体的な型引数を与えて型を確定させること
 */

// Contentは型引数
struct Container<Content> {
    let content: Content
}

// 型引数がString型であることを明示している
let stringContainer = Container<String>(content: "abc") // Content<String>

// 型引数を型推論する
let intContainer = Container(content: 1) // Content<Int>
/*
 ・Optinal<Wrapped>型やArray<Element>型のWrapped型やElement型に、Int型やString型などの具体的な型を当てはめてInt?型やArray<String>型として使用していたのも
 特殊化の一種
 */
// MARK: - ジェネリック関数：汎用的な関数
// 1. 型制約
/*
 ・型制約：準拠するプロトコルやスーパークラスなど、型引数には様々な制約を設けること
 → ジェネリック関数やジェネリック型をより細かくコントロールすることが可能となる
 →　さらに型の性質を利用することができる
 
 [型制約の種類]
 1. スーパークラスや準拠するプロトコルに対する制約
 2. 連想型のスーパークラスや準拠するプロトコルに対する制約
 3. 型同士の一致を要求する制約
 */

// 1.1　スーパークラスや準拠するプロトコルに対する制約
/*
 [定義方法]
 func 関数名<型引数: プロトコル名やスーパークラス名>(引数) {
    関数呼び出し時に実行される文
 }
 */
func isEqual1<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}

isEqual1("abc", "def") // false

// 1.2 連想型のスーパークラスや準拠するプロトコルに対する制約
/*
 [定義方法]
 func 関数名<型引数: プロトコル>(引数) -> 戻り値の型
    where 連想型: プロトコルやスーパークラス {
    
    関数の呼び出し時に実行される文
 }
 */
func sorted<T: Collection>(_ argument: T) -> [T.Element]
where T.Element: Comparable {
    return argument.sorted()
}

sorted([3, 2, 1]) // [1, 2, 3]

// 1.3 型同士の一致を要求する制約
/*
 [定義方法]
 func 関数名<型引数1: プロトコル1, 型引数2: プロトコル2>(引数) -> 戻り値の型
    where プロトコル1の連想型 == プロトコル2の連想型 {
    
    関数呼び出し時の実行される文
 }
 */
func concat<T: Collection, U: Collection>(_ argument1: T, _ argument2: U) -> [T.Element]
    where T.Element == U.Element {
    
    return Array(argument1) + Array(argument2)
}

let array = [1, 2, 3] // [Int]型
let set = Set([1, 2, 3]) // Set<Int>型
let result = concat(array, set) // [1, 2, 3, 1, 2, 3]

// MARK: - ジェネリック型
/*
 ・ジェネリック型：型引数を持つクラス、構造体、列挙型のこと。
 [定義方法]
 struct 構造体名<型引数> {
     構造体の定義
 }
 class クラス名<型引数> {
     クラスの定義
 }
 enum 列挙型名<型引数> {
     列挙型の定義
 }
 */
struct Container1<Content> {
    var content: Content
}

let intContainer1 = Container1<Int>(content: 1)
let stringContainer1 = Container1(content: "abc") // ← 型推論のよる特殊化

//let container1 = Container<Int>(content: "abc") // 型引数とイニシャライザの引数の型が一致しないためコンパイルエラー


// MARK: -
// MARK: -
// MARK: -
