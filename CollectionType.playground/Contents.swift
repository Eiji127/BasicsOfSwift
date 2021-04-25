

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
    
let range1 = 1..<4 // CountableRange(1..<4)
for value in range1 {
    print(value)
}

/*
 実行結果(range1)
 1
 2
 3
 */



// MARK: -

// MARK: -

