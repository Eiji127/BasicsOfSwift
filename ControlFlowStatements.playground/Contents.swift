
// MARK: - 条件分岐

// 1. whereキーワード

/*
 [Point]
 ・whereキーワードを使用することで、ケースにマッチする条件を追加することが可能
*/

let optionalA: Int? = 1

switch optionalA {
case .some(let a) where a > 10:
    print("10より大きい値\(a)が存在する")
default:
    print("値が存在しない、もしくは10以下の値です")
}

// 2. ラベル(label)
/*
 [Point]
 ・ラベルはbreak文の制御対象を指定するための仕組み
*/

let value = 0 as Any

outerSwitch: switch value {
case let int as Int:
    let description: String
    switch int {
    case 1, 3, 5, 7, 9:
        description = "奇数"
    case 2, 4, 6, 8, 10:
        description = "偶数"
    default:
        print("対象外の値です")
        break outerSwitch // ここで外側のswitch文に対して終了の合図を送っている
    }
    print("値は\(description)です")
default:
    print("対象外の値です")
}

// 3. fallthrough文
/*
 [Point]
 ・switch文のケースの実行を終了し、次のケースの実行する制御構文
 ・C言語などではケースを実行したあと、後続のケースが実行されるのがデフォルトの挙動となっている
 */

let fallthroughInt = 1

switch fallthroughInt {
case 1:
    print("case 1")
    fallthrough
case 2:
    print("case 2")
default:
    print("default")
}

/*
 実行結果
 
 case 1
 case 2
*/

// MARK: - パターンマッチ

// 1. 様々なパターンマッチ
/*
 [Feature]
 ・値が特定のパターンに合致するか検査することをパターンマッチという。
 → 結果に応じてプログラムのフローを制御することが可能
 ・複数のパターンが存在する
 ① 式パターン
 ② バリューバインディングパターン
 ③ オプショナルパターン
 ④ 列挙型ケースパターン
 ⑤ is演算子による型キャスティングパターン
 ⑥ as演算子による型キャスティングパターン
*/

// ① 式パターン : ~=演算子による評価

let integer = 9

switch integer {
case 6:
    print("match: 6")
case 5...10:
    print("match: 5...10")
default:
    print("default")
}

/*
 実行結果
 match: 5...10
*/

// ② バリューバインディングパターン : 値の代入を伴う評価

let value3 = 3

switch value3 {
case let matchedValue:
    print(matchedValue)
}

/*
 実行結果
 3
 */

// ③ オプショナルパターン : Optional<Wrapped>型の値の有無を評価

let optionalB = Optional(4)
switch optionalB {
case let b?:
    print(b)
default:
    print("nil")
}

/*
 実行結果
 4
 */

// ④ 列挙型ケースパターン : ケースとの一致の評価
enum Hemisphere {
    case northern
    case southern
}

let hemisphere = Hemisphere.northern

switch hemisphere {
case .northern:
    print("match: .northern")
case .southern:
    print("match: .southern")
}

/*
 実行結果
 match: .northern
 */

enum Color {
    case rgb(Int, Int, Int)
    case cmyk(Int, Int, Int, Int)
}

let color = Color.rgb(100, 200, 255)

switch color {
case .rgb(let r, let g, let b):
    print(".rgb: (\(r), \(g), \(b))")
case .cmyk(let c, let m, let y, let k):
    print(".cmyk: (\(c), \(m), \(y), \(k)")
}

/*
 実行結果
 .rgb: (100, 200, 255)
 */

// ⑤ is演算子による型キャスティングパターン : 型の判定による評価

let any: Any = 1

switch any {
case is String:
    print("match: String")
case is Int:
    print("match: Int")
default:
    print("default")
}

/*
 実行結果
 match: Int
 */

// ⑥ as演算子による型キャスティングパターン : 型のキャストによる評価
let any2: Any = 1

switch any2 {
case let string as String:
    print("match: String(\(string))")
case let int as Int:
    print("match: Int(\(int))")
default:
    print("default")
}

/*
 実行結果
 match: Int(1)
 */

// 2. パターンマッチが使える場所
// MARK: -


// MARK: -


// MARK: -


// MARK: -


// MARK: -


// MARK: -


// MARK: -


// MARK: -


// MARK: -


// MARK: -
