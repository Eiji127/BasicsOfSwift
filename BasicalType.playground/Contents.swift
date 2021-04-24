// MARK: - 論理演算

// 1. 論理積
func indicateIntersection() {
    let a = false && false // false
    let b = false && true // false
    let c = true && false // false
    let d = true && true // true
    print(a, b, c, d)
}

indicateIntersection()

// 2. 論理和
func indicateDisjunction() {
    let a = false || false // false
    let b = false || true // true
    let c = true || false // true
    let d = true || true // true
    print(a, b, c, d)
}

indicateDisjunction()

// MARK: - 数値型

// 1. 浮動小数点型
func indicateFloatingPointType() {
    let a: Double = 12345678.9 // 12345678.9
    let b: Float = 12345678.9 // 1.234568e+07
    print(a, b) // 12345678.9 12345679.0
}

indicateFloatingPointType()

/*
 [Point]
 ・Float型とDouble型はCocoaでは用途によって使い分ける
 ・Cocoa内で画面上の座標に関するCGFloat型は、32ビットのプラットフォーム上ではFloat型を、
 64ビットのプラットフォーム上ではDouble型を採用している。(CGFloat型はFloat型、Double型の型エイリアスである。)
 typealias CGFloat = Float
 ・地球上の座標を示すCLLocationDegrees型は、より高い精度を求められているためプラットフォームによらず
 Double型を採用している(CLLocationDegrees型はDouble型の型エイリアスである。)
 typealias CLLocationDegrees = Double
 */

// MARK: - String型

// 1. エスケープシーケンス
/*
 [エスケープシーケンス]
 ・\n：ラインフィード ← 改行によく用いる
 ・\r：キャリッジリターン
 ・\"：ダブルクオート
 ・\'：シングルクオート
 ・\\：バックスラッシュ
 ・\θ：null文字
 */

// 2. 複数行の文字列リテラル
let poem = """
五月雨を
あつめて早し
最上川
"""

print(poem)

// 3. コアライブラリFoundationによる高度な操作

import Foundation

// 2つの文字列間の順序比較
let options = String.CompareOptions.caseInsensitive
let order = "abc".compare("ABC", options: options)
print(order == ComparisonResult.orderedSame)

// 文字列間の探索
print("abc".range(of: "bc"))

/*
 [Point]
 ・compare(_:option:)メソッドで2つの文字列間の順序を検証
 ・.caseInsensitiveを適用することで大文字、小文字の区別を無視している
 */

// 4. Optional<Wrapped>型
/*
 [Point]
 ・Wrappedはプレースホルダ型
 ・<>内にプレースホルダ型を持つ型をジェネリック型
 */


// MARK: - 型のキャスト

// 1. アップキャスト
/*
 [Point]
 ・階層関係がある型どうしにおいて、階層の下位となる具体的な型を上位の抽象的な型として扱う操作
 ・as演算子を使用
 */

let abc = "abc" as Any // String型をAny型にアップキャスト
let any: Any = "abc" // String型からAny型へ暗黙的にアップキャスト

// 2. ダウンキャスト
/*
 [Point]
 ・階層関係にある型どうしにおいて、階層の上位となる抽象的な型を下位の具体的な型として扱う操作
 ・as?演算子 or as!演算子 を使用
 ・as?演算子 → 左辺の値を右辺の型の値へダウンキャストし、成功したときはOptional<Wrapped>型を、失敗したときはnilを返す
 ・as!演算子 → 強制キャスト、左辺の値を右辺の型へダウンキャストし、成功したときはWrapped型、失敗したときは実行時エラーとなる(少し危険！！)
 */

let any1 = 1 as Any

let intDown1 = any1 as? Int // Optional(1)
let string1 = any as? String // nil

let intDown2 = any1 as! Int // 1
let string = any as! String // 実行時エラー

// 3. 型の判定

/*
 ・型の判定にはis演算子を使用
 */

let abcd: Any = 1
let isInt = abcd is Int // true

// MARK: -

// MARK: -

// MARK: -


// MARK: -


// MARK: -
