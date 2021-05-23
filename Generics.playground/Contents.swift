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
 
 */
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
