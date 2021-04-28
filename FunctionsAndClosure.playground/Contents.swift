
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

// MARK: -
