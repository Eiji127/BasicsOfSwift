
/*
 [Point]
 ・関数はクロージャの一種
 ・関数・クロージャはひとまとまりの処理を切り出し、再利用可能とするためのもの
 ・関数・クロージャを用いることで可読性やメンテナンス性の向上につながる
 */
// MARK: - 関数

// 1. 外部引数と内部引数

func invite(user: String, to group: String) {
    print("\(user) is invited to \(group).")
}

invite(user: "Ishikawa", to: "Soccer Club")

// 実行結果：Ishikawa is invited to Soccer Club.

/*
 [Point]
 ・第2引数の外部引数名がto、内部引数名がgroupとなる
 ・外部引数名には関数を利用する側から見てわかりやすい名前を！！
 ・内部引数名にはプログラムが冗長にならない名前をつける！！
 */

// 2. 外部引数の省略

func sum(_ int1: Int, _ int2: Int) -> Int {
    return int1 + int2
}

let result = sum(1, 2)
print(result) // 3

/*
 [Point]
 ・外部引数名を省略したいとき、外部引数名に_を使用
 */

// 3. デフォルト引数

func greet(user: String = "Anonymous") {
    print("Hello, \(user)!")
}

greet() // Hello, Anonymous!
greet(user: "Ishikawa") // Hello, Ishikawa!

/*
 [Point]
 ・引数にデフォルト値を設定できる
 ・引数のデフォルト値 = デフォルト引数
 ・複数の引数にも指定できる
 */

func search(byQuery query: String,
            sortKey: String = "id",
            ascending: Bool = false) -> [Int] {
    return [1, 2, 3]
}

search(byQuery: "query") // [1, 2, 3]

// 4. インアウト引数

func greet(user: inout String) {
    if user.isEmpty {
        user = "Anonymous"
    }
    print("Hello, \(user)")
}

var user: String = ""
greet(user: &user) // Hello, Anonymous

/*
 [Point]
 ・関数内での引数への再代入を関数外へ反映させるときに使用
 ・インアウト引数を使用するには、引数の型の先頭にinoutキーワードを追加する
 ・インアウト引数を持つ関数を呼び出すには、インアウト引数の先頭に&を追加する
 */

// 5. 可変長引数

func print(strings: String...) {
    if strings.count == 0 {
        return
    }
    
    print("first: \(strings[0])")
    
    for string in strings {
        print("element: \(string)")
    }
}

print(strings: "abc", "def", "ghi")
/*
 実行結果：
 first: abc
 element: abc
 element: def
 element: ghi
 */

/*
 [Point]
 ・任意の個数の値を受け取ることができる引数
 ・Swiftでは1つの関数につき最大1つまで設定可能
 */

// 6. 戻り値

// - 戻り値がない関数

func say(user: String) {
    print("Hello, \(user)!")
}

say(user: "Nishikawa") // Hello, Nishikawa!
// 関数宣言で戻り値の型の定義を省略した際、関数の戻り値はVoid型となる
// 以下と同じ
/*
func say(user: String) -> Void {
    print("Hello, \(user)!")
}

say(user: "Nishikawa") // Hello, Nishikawa!
*/

// MARK: - クロージャ
/*
 [Feature]
 ・クロージャは再利用可能なひとまとまりの処理
 ・関数はfuncキーワードで定義し、クロージャはクロージャ式という定義方法がある
 ・クロージャ型も関数のように (引数の型) -> 戻り値の型 という形式で表される
 */

let double = { (x: Int) -> Int in
    return x * 2
}

print(double(2)) // 4

/*
 ・クロージャの型は通常の型と同じように扱える
 ・変数や定数の型、関数の引数の型として利用することも可能
 
 let closure: (Int) -> Int
 func someFunction(x: (Int) -> Int) {}
 
 */

// 1. 型推論
/*
 [Point]
 ・クロージャを宣言したとき引数と戻り値の型を宣言しているとその後の型を省略することができる
 */
var closure: (String) -> Int
// 引数の型と戻り値の型を明示したとき
closure = { (string: String) -> Int in
    return string.count
}
closure("abc") // 3
// 引数と戻り値の型を省略したとき
closure = { string in
    return string.count * 2
}
closure("abc") // 6

// 引数と戻り値の型が決まっていないとき
/*
 let closure = { string in
    return string.count * 2 // クロージャの型が決定しないためコンパイルエラー
 }
 */

// 2. 引数
/*
 [Point]
 ・クロージャ式は
 外部引数名、
 デフォルト引数
 が使用不可
 ・インアウト引数、可変長引数、簡略引数名が使用可能
 */

// - 簡略引数名
let isEqual: (Int, Int) -> Bool = {
    return $0 == $1
}

print(isEqual(1, 1)) // true

/*
 [Point]
 ・引数名の省略する代わりに簡略引数名を利用する
 ・$に引数のインデックスをつけた$0、$1などを使用する
 */

// 3. 引数としてのクロージャ

/*
 [Point]
 ・クロージャを関数や別のクロージャの引数として利用する場合にのみ有効な仕様↓
 ・属性：クロージャに対して指定する追加情報
 ・トレイリングクロージャ：クロージャを引数に取る関数の可能性を高めるの仕様
 */

// 3.1 属性の指定方法
/*
 [Point]
 ・クロージャの型の前に@属性名を追加する
 ・属性にはescaping属性とautoclosure属性がある
 */
func or(_ lhs: Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
    if lhs {
        return true
    } else {
        return rhs()
    }
}

print(or(true, false)) // true

// - escaping属性

/*
 [Point]
 ・関数に引数として渡されたクロージャが、関数のスコープ外で保持される可能性があることを示す属性
 ・escaping属性の有無によってコンパイラが「クロージャがキャプチャを行う必要があるか」判別する
 */

var queue = [() -> Void]()

func enqueue(operation: @escaping () -> Void) {
    queue.append(operation)
}

enqueue {
    print("executed")
}

enqueue {
    print("executed")
}

queue.forEach {
    $0()
}

// - autoclosure属性
/*
 [Point]
 ・引数をクロージャで包み込むことで遅延評価を実現する
 */
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
