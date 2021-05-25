

// MARK: - 値の受け渡し方法による分類
/*
 [Feature]
 ・値の受け渡しの方法は大別して以下の２つ
 - 値型
 - 参照型
 → 違い：変更を他の変数や定数と共有するかどうか（値型→共有しない、参照型→変更を共有する）
 ・構造体と列挙型は値型、クラスは参照型
 */

// 1. 値型
/*
 [Feature]
 ・インスタンスが値への参照ではなく値そのものを表す型
 ・Swiftでは構造体、列挙型が該当
 ・変数や定数への値型のインスタンスの代入は、インスタンスが表す値そのものを代入を意味する
 → 複数の変数や定数で1つの値型のインスタンスを共有することができない
 */

var a = 4.0
var b = a
a.formSquareRoot()
print("a: \(a), b: \(b)") // a: 2.0, b: 4.0 → aの値が更新されても、bの値には影響はない(値型の特徴の一つ)

// - mutatingキーワード(自身の値の変更を宣言するキーワード)
/*
 [Feature]
 ・mutating func メソッド名() -> 返り値の型 {}
 → インスタンスの値を変更すると、インスタンスが格納されている変数への暗黙的な再代入が行われる
 */
extension Int {
    mutating func increment() {
        self += 1
    }
}

var intA = 1 // 1
intA.increment() // 2

//let intB = 1
//intB.increment() //再代入を行えないためコンパイルエラー

// 2. 参照型
/*
 [Feature]
 ・参照型：インスタンスが値への参照を表す型
 ・Swiftでは、クラスが参照型
 ・変数や定数への参照型の値の代入はインスタンスに対する参照の代入を意味する
 → 複数の変数や定数で1つの参照型のインスタンスを共有することが可能
 ・変数や定数への代入時や関数への受け渡し時にはインスタンスのコピーが発生しない
 →効率的なインスタンスへの受け渡しができる
 */
class IntBox {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

var aOfIntBox = IntBox(value: 1)
var bOfIntBox = aOfIntBox

aOfIntBox.value // 1
bOfIntBox.value // 1

aOfIntBox.value = 2

aOfIntBox.value // 2
bOfIntBox.value // 2

// 3. 値型と参照型の使い分け
/*
 ・値型：変数や定数への代入や引数への受け渡しのたびにコピーされ、変更は共有されない
 → 一度代入された値は明示的に再代入しない限りは不変である
 ・参照型：変数や定数への代入や引数への受け渡しのたびにコピーされず参照が渡されるため、変更は共有される
 → 一度代入された値が変更されないことの保証が難しい
 
 [重要！]
 ・安全にデータを取り扱うためには積極的に値型を使用するべき
 ・参照型は状態管理などの変更の共有が必要となる範囲にのみ使用するべき
 */


// MARK: - 構造体
// 1. メンバーワイズイニシャライザ(自動的に定義されるイニシャライザ)
struct Article {
    var id: Int
    var title: String
    var body: String
    
    // 以下と同等のイニシャライザが自動的に定義される
//    init(id: Int, title: String, body: String) {
//        self.id = id
//        self.title = title
//        self.body = body
//    }
}

let article = Article(id: 1, title: "[Breaking!!]", body: "...")
article.id // 1
article.title // [Breaking!!]
article.body // ...

// MARK: - クラス
/*
 [Feature]
 ・クラスは参照型であり、継承することができる
 ・Cocoaのほとんどの型がクラスとして定義されている
 */
// 1. 継承
/*
 ・スーパークラス：継承先に対して、継承元のクラスのこと
 ・サブクラス：継承元に対して、継承先のクラスのこと
 → ほかのクラスのプロパティ、メソッド、イニシャライザなどの型を再利用することが可能
 */

class User {
    let id: Int
    
    var message: String {
        return "Hello"
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func printProfile() {
        print("id: \(id)")
        print("message: \(message)")
    }
}

class RegisteredUser: User {
    let name: String
    
    init(id: Int, name: String) {
        self.name = name
        super.init(id: id)
    }
}

let registerdUser = RegisteredUser(id: 1, name: "Yosuke Ishikawa")
let id = registerdUser.id
let message = registerdUser.message
registerdUser.printProfile()
/*
 実行結果：
 id: 1
 message: Hello
 */

// 2. オーバーライド
/*
 ・オーバーライド：スーパークラスで定義されているプロパティやメソッドなどの要素を、サブクラスで再定義すること
 ・finalキーワード：オーバライド可能な要素の前に付与することで、その要素がサブクラスでオーバライドされることを禁止できる
 */

class SuperClass {
    func overridableMethod() {}
    
    final func finalMethod() {}
}

class SubClass: SuperClass {
    override func overridableMethod() {
        print("HELLO")
    }
    
//    override func finalMethod() {} ← オーバライド不可のため、コンパイルエラー
}

// 3. イニシャライザの種類と初期化のプロセス
/*
 ・イニシャライザの役割
    ⅰ. 型のインスタンス化の完了までにすべてのプロパティの初期化
    ⅱ. 型の整合性を担保
 
 ・2段階初期化：指定イニシャライザ + コンビニエンスイニシャライザ
 */

// - 指定イニシャライザ
/*
 ・指定イニシャライザ(designated initilizer)：クラスの主となるイニシャライザ。このイニシャライザの中ですべてのストアドプロパティが初期化される必要がある
 ・一般的なイニシャライザ
 */
class Mail1 {
    let from: String
    let to: String
    let title: String
    
    // 指定イニシャライザ
    init(from: String, to: String, title: String) {
        self.from = from
        self.to = to
        self.title = title
    }
}

// - コンビニエンスイニシャライザ
/*
 ・コンビニエンスイニシャライザ：指定イニシャライザを中継するイニシャライザ
 ・内部で引数を組み立て、指定イニシャライザを呼び出す必要がある
 ・convenieceキーワードを使用
 */
class Mail2 {
    let from: String
    let to: String
    let title: String
    
    // 指定イニシャライザ
    init(from: String, to: String, title: String) {
        self.from = from
        self.to = to
        self.title = title
    }
    
    // コンビニエンスイニシャライザ
    convenience init(from: String, to: String) {
        self.init(from: from, to: to, title: "Hello, \(from).")
    }
}

// - 2段階初期化
/*
 [指定イニシャライザの2段階初期化]
 ⅰ. クラス内で新たに定義されたすべえのストアドプロパティを初期化、スーパークラスの指定イニシャライザを実行する。スーパークラスでも同様の初期化を行い、大元のクラスまで遡る
 ⅱ. ストアドプロパティ以外の初期化を実行
 
 [クラスのイニシャライザのルール3箇条]
 ・指定イニシャライザは、スーパークラスの指定イニシャライザを呼ぶ
 ・コンビニエンスイニシャライザは、同一クラスのイニシャライザを呼ぶ
 ・コンビニエンスイニシャライザは、最終的に指定イニシャライザを呼ぶ
 
 → これらのルールをすべて満たすことで、型の整合性が保証される
 → 1つでもルールが満たされていないと、型の整合性が担保されていないことになり、コンパイルエラーとなる
 */
class User2 {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func printProfile() {
        print("id: \(id)")
    }
}

class RegisteredUser2: User2 {
    let name: String
    
    init(id: Int, name: String) {
        // 第ⅰ段階
        self.name = name
        super.init(id: id)
        
        // 第ⅱ段階
        self.printProfile()
    }
}

// 4. クラスのメモリ管理
/*
 ・Swiftでは、ARC(Automatic Reference Counting)というメモリ管理方式を採用している
 ・ARC：クラスのインスタンスを生成するたびに、そのインスタンスのためのメモリ管理を自動的に確保し、不要になったタイミングで自動的にメモリ領域を解放する
 → 参照カウント：ARCにおいて、使用中のインスタンスのメモリが開放されてしまうのを防止するため、プロパティ、変数、定数からそれぞれのクラスのインスタンスへの参照がいくつかカウントされる。参照カウントが0のとき、そのインスタンスはどこからも参照されていないと判断し、メモリを解放する
 */

// - デイニシャライザ(インスタンスの終了処理)
/*
 ・デイニシャライザ：イニシャライザの逆、クリーンアップなどの終了処理を行うもの
 ・ARCによってインスタンスが破棄されるタイミングで、クラスのデイニシャライザが実行される
 ・deinitキーワードを使用する
 */

// 5. 値の比較と参照の比較
/*
 ・参照先が同じかどうかを知るためには===演算子を使用する
 */

class SomeClass: Equatable {
    static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
        return true
    }
}

let a1 = SomeClass()
let b1 = SomeClass()
let c1 = a1

// 定数aとbは同じ値のとき
a1 == b1 // true

// 定数aとbの参照先が異なるとき
a1 === b1 // false

// 定数aとcが同じ参照先であるとき
a1 === c1 // true


// MARK: - 列挙型

/*
 [Feature]
 ・列挙型は値型の一種、複数の識別子をまとめる型
 ・標準ライブラリの一部の型は列挙型（ex. Optional<Wrapped>）
 ・enum内ではストアドプロパティを定義することができない
 */

enum Weekday {
    case sunday
    case monday
    case tuseday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(japaneseName: String) {
        switch japaneseName {
        case "日": self = .sunday
        case "月": self = .monday
        case "火": self = .tuseday
        case "水": self = .wednesday
        case "木": self = .thursday
        case "金": self = .friday
        case "土": self = .saturday
        default: return nil
        }
    }
}

let sunday = Weekday(japaneseName: "日") // Optional(Weekday.sunday)
let monday = Weekday(japaneseName: "月") // Optional(Weekday.monday)

print(sunday)
print(monday)

// 1. ローバリュー(実体の定義)
/*
 [Feature]
 ・ローバリュー(raw value)：列挙型のケースそれぞれ対応するように設定できる値
 → すべてのケースのろーバリューの型が同じである必要がある
 */
enum Symbol: Character {
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
}

let symbol = Symbol(rawValue: "#") // sharp
let character = symbol?.rawValue // #

// - ローバリューのデフォルト値
/*
 ・Int型やString型にはローバリューのデフォルト値が存在する
 ・指定しないと、Int型では最初のケースから0, 1, 2...というように、
 String型ではデフォルト値が設定される
 */

enum Option: Int {
    case none
    case one
    case two
    case undefined = 999
    case three
}

Option.none.rawValue // 0
Option.one.rawValue // 1
Option.two.rawValue // 2
Option.undefined.rawValue // 999
Option.three.rawValue // 1000

// 2. 連想値(associated value)
enum Color {
    case rgb(Float, Float, Float)
    case cmyk(Float, Float, Float, Float)
}

let rgb = Color.rgb(0.0, 0.33, 0.66)
let cmyk = Color.cmyk(0.0, 0.33, 0.66, 0.99)

let color = Color.rgb(0.0, 0.33, 0.99)

switch color {
case .rgb(let r, let g, let b):
    print("r: \(r), g: \(g), b: \(b)")
case .cmyk(let c, let m, let y, let k):
    print("c: \(c), m: \(m), y: \(y), k: \(k)")
}
// 実行結果: r: 0.0, g: 0.33, b: 0.99

// 3. CaseIterableプロトコル
/*
 ・すべてのケースを配列として取得したいときに使用するプロトコル
 ・CaseIterableプロトコルへの準拠を宣言した列挙型には自動的にallCasesスタティックプロパティが追加される
 ・allCasesプロパティによって、列挙型の全ケースを配列として取得することが可能
 ・連想値をもつ列挙型に対してはallCasesプロパティが自動生成されない
 */
enum Fruit: CaseIterable {
    case peach, apple, grape
}

Fruit.allCases // [peach, apple, grape]


// MARK: -

// MARK: -


// MARK: -

// MARK: -

// MARK: -


// MARK: -

// MARK: -

// MARK: -


// MARK: -
