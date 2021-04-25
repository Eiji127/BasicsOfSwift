

/*
 [Feature]
 ・コレクションを表す型は、
    配列型Array<Element>、
    辞書型Dictionary<Key, Value>、
    範囲型Range<Bound>、
    文字列型String
 である。
 ・上記の型はSequeceプロトコル、Collectionプロトコルに準拠している
 */

// MARK: - Dictionary<Key, Value>型
/*
 [Point]
 ・キー(Key)をもとに値(Value)にアクセスする
 ・Key型はHashableプロトコルに準拠した型
 →アルゴリズムで有名なハッシュ法のハッシュ値のようにキーの一意性を保証したり、探索などに用いる
 ・HashableプロトコルはString型やInt型が準拠している
 
 */

// 1. 基本的な構造

let dictionary = ["a": 1, "b": 2]

// 要素数が0のときは型アノテーションで明示する必要がある↓
let nilDicionary: [String: Int] = [:]

// 2. Dictionary<Key, Value>型の操作

// 値へのアクセス
let dic = ["key1": 1, "key2": 2]
print(dic["key1"]) // Optional(1)

// 値の更新、追加、削除
var dic1 = ["key": 1]
dic1["key"] = 2 // 更新
print(dic1["key"]) // Optional(2)

var dic2 = ["key1": 1]
dic2["key2"] = 2 // 追加
print(dic2) // ["key2": 2, "key1": 1]

var dic3 = ["key": 1]
dic3["key"] = nil
print(dic3) // [:]

// MARK: - 範囲型
/*
 [Point]
 ・基本的にはRange<Bound>型だが、他にも様々な範囲型が存在
 ① ..<演算子(終了の値を含まない)
 Range<Bount>
 CountableRange<Bound>
 ParticialRangeUpTo<Bound>
 ② ...演算子(終了の値を含む)
 ClosedRange<Bound>
 CountableClosedRange<Bound>
 PartialRangeThrough<Bound>
 PartialRangeFrom<Bound>
 CountablePartialRangeFrom<Bound>
 */

// 1. ..<演算子
let rangeDouble = 1.0..<3.5 // Range<Double>型、1.0以上3.5未満の範囲を示す
let particialRangeUpTo = ..<3.5 //  ParticialRangeUpTo<Double>型、3.5未満という範囲を示す
let range1 = 1..<4 // CountableRange(1..<4) ← Sequenceプロトコルに準拠
for value in range1 {
    print(value)
}
/*
 実行結果(range1)
 1
 2
 3
 */

// 2. ...演算子
let range2 = 1...4 // CountableClosedRange<Int> ← Sequenceプロトコルに準拠
for value in range2 {
    print(value)
}
/*
 実行結果(range1)
 1
 2
 3
 4
 */

// 3. 範囲型の操作
/*
 [Point]
 ・範囲型の境界値へのアクセスは、lowerBoundとupperBoundプロパティを使用
 ・upperBoundプロパティ → 範囲の末尾の値をBound型として返す
 ・lowerBoundプロパティ → 範囲の先頭の値をBound型として返す
 */

let controllingRange = 1.0...4.0 // Range<Double>
print(controllingRange.lowerBound) // 1.0
print(controllingRange.upperBound) // 4.0

let countableRange = 1..<4 // CountableRange<Int>
print(countableRange.lowerBound) // 1
print(countableRange.upperBound) // 4

let closedRange = 1.0...4.0 // ClosedRange<Double>
print(closedRange.lowerBound) // 1.0
print(closedRange.upperBound) // 4.0

let countableClosedRange = 1...4 // CountableClosedRange<Int>
print(countableClosedRange.lowerBound) // 1
print(countableClosedRange.upperBound) // 4


// 4. 値が範囲に含まれるかどうかの判定(contain(_:)メソッド)
let judgedRange = 1...4
print(judgedRange.contains(2)) // true
print(judgedRange.contains(5)) // false
// MARK: -

// MARK: -

