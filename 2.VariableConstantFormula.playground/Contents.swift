
// MARK: - 型の確認

func checkType() {
    let a = 123
    let b = "Swift"
    print(type(of: a)) // Int
    print(type(of: b)) // String
}

checkType()

// MARK: - スコープについて

// 1. ローカルスコープ
func localFunction() {
    let a = "aだよ~"
    print(a) // aだよ~
}

localFunction()
//print(a) // ← コンパイルエラー(ローカルスコープで宣言された定数・変数は呼び出せない)

// 2. グローバルスコープ
let globalA = "グローバルAだよ~"

func globalFunction() {
    print(globalA) //グローバルAだよ~
}

print(globalA) //グローバルAだよ~
globalFunction()

/*
 [Point]
 ・グルーバルスコープはどこからでも参照することができ、意図しない変更を招きやすい！！
 ・ローカルスコープに比べ、より説明的な命名をする必要がある
 */

// 3. スコープの優先順位

let scope = 1

func scopeFunction() {
    let scope = 2
    print("Local Scope:", scope) // Local Scope: 2
}

print("Global Scope:", scope) // Global Scope: 1
scopeFunction()

/*
 [Point]
 ・異なるスコープに同じ名前の変数・定数が存在すると、名前を参照するスコープから、最も近い祖先のスコープにあるものを参照する
 */

// MARK: - 式の組み合わせ

// 1. クロージャ式
let original = [1, 2, 3]
let doubled = original.map({ value in value * 2 })
print(doubled) // [2, 4, 6]

// MARK: -

// MARK: -


// MARK: -


// MARK: -

// MARK: -

// MARK: -

// MARK: -


// MARK: -


// MARK: -
