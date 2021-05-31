// MARK: - クラスに対する構造体の優位性
/*
 ・クラスで実現可能なことの大半は構造体でも実現可能
 ・Swiftでは構造体が頻繁に使用されている(標準ライブラリの多くが構造体である)
 → できるだけ構造体を使用するべきである！！
 */
// 1. 参照型のクラスがもたらすバグ
class TemperatureClass {
    var celsius: Double = 0
}

class Country {
    var temperature: TemperatureClass
    init(temperature: TemperatureClass) {
        self.temperature = temperature
    }
}

let temperature = TemperatureClass()
temperature.celsius = 25
let japan = Country(temperature: temperature)
temperature.celsius = 40
let egypt = Country(temperature: temperature)
print("Japan: \(japan.temperature.celsius), Egypt: \(egypt.temperature.celsius)")
// 実行結果：Japan: 40.0, Egypt: 40.0
/*
 ↑ 日本が25 ℃、エジプトが40 ℃とするべきコードであるが、クラスが参照型であるため、japanとegyptの引数としてインスタンスが渡され、そのインスタンスの参照も渡されている。
 → つまり、temperatureのプロパティの値を変更すると、そのインスタンスを参照している両方のインスタンスも影響を受けてしまっている
 */

// MARK: - 値型の構造体がもたらす安全性
struct TemperatureStruct {
    var celsius: Double = 0
}

struct CountryStruct {
    var temperature: TemperatureStruct
    init(temperature: TemperatureStruct) {
        self.temperature = temperature
    }
}

var temperature1 = TemperatureStruct()
temperature1.celsius = 25
let japan1 = CountryStruct(temperature: temperature1)
temperature1.celsius = 40
let egypt1 = CountryStruct(temperature: temperature1)
print("Japan: \(japan1.temperature.celsius), Egypt: \(egypt1.temperature.celsius)")
// 実行結果：Japan: 25.0, Egypt: 40.0
/*
 ・構造体のときは参照ではなく値そのままが渡される
 → インスタンスのコピーが渡される
 */

// MARK: - コピーオンライト - 構造体の不要なコピーを発生させない最適化
/*
 ・構造体は代入や変更を行うたびにコピーが発生する
 ・Array<Element>型やDictionary<Key, Value>型などのコレクションを表す型はサイズの大きいデータを扱う可能性がある
 ・代入のたびに毎回を実行するとパフォーマンスの低下が予想される
 → コピーオンライト：コストを必要最小限に抑えつつ値型の特性を実現する仕組み
 */
var array1 = [1, 2, 3]
var array2 = array1
array1.append(4)
print("array1: \(array1), array2: \(array2)") // array1: [1, 2, 3, 4], array2: [1, 2, 3]
/*
 ・var array2 = array1のときにはコピーは実行されていない
 → array1.append(4)のときの違いが発生したときにコピーが実行されている
 */

// MARK: - クラスを利用するべきとき
/*
 [利用時]
 1. 参照を共有する必要があるとき
 2. インスタンスのライフサイクルに合わせて処理を実行するとき
 */

// 1. 参照を共有する必要があるとき
/*
 ・参照を共有することによって、ある箇所での操作を他の箇所へ共有させたいケースに適している
 */
protocol Target {
    var identifier: String { get set }
    var count: Int { get set }
    mutating func action()
}

extension Target {
    mutating func action() {
        count += 1
        print("id: \(identifier), count: \(count)")
    }
}

struct ValueTypeTarget: Target {
    var identifier = "Value Type"
    var count = 0
    
    init() {}
}

class ReferenceTypeTarget: Target {
    var identifier = "Reference Type"
    var count = 0
}

struct Timer {
    var target: Target
    
    mutating func start() {
        for _ in 0..<5 {
            target.action()
        }
    }
}
// 構造体のターゲットを登録してタイマーを実行
let valueTypeTarget: Target = ValueTypeTarget()
var timer1 = Timer(target: valueTypeTarget)
timer1.start()
print(valueTypeTarget.count) // 0

// クラスのターゲットを登録してタイマーを実行
let referenceTypeTarget = ReferenceTypeTarget()
var timer2 = Timer(target: referenceTypeTarget)
timer2.start()
print(referenceTypeTarget.count) // 5
/*
 実行結果：
 id: Value Type, count: 1
 id: Value Type, count: 2
 id: Value Type, count: 3
 id: Value Type, count: 4
 id: Value Type, count: 5
 0
 id: Reference Type, count: 1
 id: Reference Type, count: 2
 id: Reference Type, count: 3
 id: Reference Type, count: 4
 id: Reference Type, count: 5
 5
 
 →  ・構造体は値型なので0のまま
    ・クラスは参照型なので変更回数がタイマーと共有されている
    → 変更などを共有するときはクラスを使用するべきである
 */

// 2. インスタンスのライフサイクルに合わせて処理を実行するとき
/*
 ・クラスにはデイニシャライザが存在する
 ・デイニシャライザ：クラスのインスタンスが開放された時点で即座に実行されるもの
 → インスタンスのライフサイクルに関連するリソースの解放操作を結びつけることができる
 */
var temporaryData: String?

class SomeClass {
    init() {
        print("Create a temporary data")
        temporaryData = "a temporary data"
    }
    
    deinit {
        print("Clean up the temporary data")
        temporaryData = nil
    }
}

var someClass: SomeClass? = SomeClass()
print("temporary data: \(temporaryData)")

someClass = nil
print("temporary data: \(temporaryData)")
/*
 実行結果：
 Create a temporary data
 temporary data: Optional("a temporary data")
 Clean up the temporary data
 temporary data: nil
 
 → インスタンスが作成されたときにinit部分が実行されている
 → someClass = nilのときにdeinit部分が呼び出され、一時ファイルも削除されている
 */

// MARK: - クラスの継承に対するプロトコルの優位性
/*
 ・Swiftは構造体を推奨している一方で、構造体や列挙型には継承という概念は存在しない
 → プロトコルに準拠することで抽象的な概念を具象化している
 */

// 1. クラスの継承がもたらす期待しない挙動
//class Animal {
//    var owner: String?
//    func sleep() { print("Sleeping") }
//    func move() {}
//}
//
//class Dog: Animal {
//    override func move() {
//        print("Running")
//    }
//}
//
//class Cat: Animal {
//    override func move() {
//        print("Prancing")
//    }
//}
//
//class WileEagle: Animal {
//    override func move() {
//        print("Flying")
//    }
//}
/*
 [クラスの継承のメリット]
 ・move()メソッドの多様性が実現されている
 ・それぞれのサブクラスで実現せずともsleep()メソッドを利用できる
 
 [クラスの継承のデメリット]
 ・Animalクラスは特定の動物を表さない抽象的な概念であるためインスタンス化は不可能であるべきだが、
 インスタンス化が可能になってしまっている
 ・野生であるためownerプロパティが不要なWildEagleクラスにも、
 継承によって自動的にownerプロパティが追加されてしまっている
 
 → 不要なイニシャライザやプロパティはクラスの誤用を招く可能性がある！！
 */

// 2. プロトコルのよるクラスの継承の問題点の克服
protocol Ownable {
    var owner: String { get set }
}

protocol Animal {
    func sleep()
    func move()
}

extension Animal {
    func sleep() { print("sleeping") }
}

struct Dog: Animal, Ownable {
    var owner: String
    func move() {
        print("Running")
    }
}

struct Cat: Animal, Ownable {
    var owner: String
    func move() {
        print("Prancing")
    }
}

struct WildEagle: Animal {
    func move() {
        print("Flying")
    }
}
/*
 ・move()メソッドの多様性が実現されている
 → 共通のインターフェースをプロトコルで実現している
 ・それぞれのサブクラスを実装せずともsleep()メソッドのデフォルト実装を定義している
 → Animalプロトコルを拡張することで、sleep()メソッドのデフォルト実装を定義している
 
 [クラスの継承のデメリット]
 ・Animalクラスは特定の動物を表さない抽象的な概念であるためインスタンス化は不可能であるべきだが、
 インスタンス化が可能になってしまっている
 → Animalはプロトコルであるためインスタンス化できない
 ・野生であるためownerプロパティが不要なWildEagleクラスにも、
 継承によって自動的にownerプロパティが追加されてしまっている
 → クラスは多重継承できないが、複数のプロトコルに準拠する型を実装することはできる。ownerプロパティが必要な型だけをOwnableプロトコルに準拠させている
 */

// 3. クラスの継承を利用するべきとき
/*
 [利用する時]
 ・複数の型の間でストアドプロパティの実装を共有する時
 */
class Animal1 {
    var owner: String? {
        didSet {
            guard let owner = owner else {
                return
            }
            print("\(owner) was assigned as the owner")
        }
    }
}

class Dog1: Animal1 {}

class Cat1: Animal1 {}

class WileEagle: Animal1 {}

let dog = Dog1()
dog.owner = "Yusei Nishikawa"
// 実行結果：Yusei Nishikawa was assigned as the owner
/*
 ・プロトコルエクステンションではストアドプロパティやプロパティオブザーバを実装できない
 → ストアドプロパティを共有する必要があるときはクラスの継承を利用するべき
 */

// MARK: - オプショナル型の利用指針
/*
 オプショナル型は安全なコードを書くことに非常に重要
 [オプショナル型の利用指針]
 ・Optional<Wrapped>型を利用するべきとき
 ・暗黙的にアンラップされたOptional<Wrapped>型を利用するべきとき
 ・比較検討するべきとき
 */

// 1. Optional<Wrapped>型を利用するべきとき
/*
 ・すべてのプロパティをOptional<Wrapped>型で宣言すると、コードの厳密性を損ね、冗長なコードを招く
 [利用するべきとき]
 → 値が不在が想定される時
 */

// 例：サービスのユーザー情報(ユーザー名は必須、メールアドレスは任意)
struct User {
    let id: Int
    let name: String
    let mailAddress: String? // ユーザーがメールアドレスを登録していない（持っていない）可能性を見越して?を付与
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String else {
            // idやnameを初期化できなかった場合はインスタンスの初期化を失敗させる
            return nil
        }
        self.id = id
        self.name = name
        self.mailAddress = json["email"] as? String
    }
}

let json: [String: Any] = [
    "id": 123,
    "name": "Yusei Nishiyama"
]

if let user = User(json: json) {
    print("id: \(user.id), name: \(user.name)")
} else {
    print("Invalid JSON")
}

// 2. 暗黙的にアンラップされたOptional<Wrapped>型を利用するべきとき
/*
 [利用するべき時]
 ・初期化時にのみ値が決まっていない
 ・サブクラスの初期化より前にスーパークラスの初期化が必要
 */

// 2.1 初期化時にのみ値が決まっていない
/*
 @IBOutlet weak var someLabel: UILabel!
 ・storyboardファイルのアウトレットプロパティは、インスタンス化されるときに空であるが、その後必ずstoryboardから生成された値が設定される → 暗黙的にOptional<Wrapped>型の値を生成する
 -> そのため、オプショナルバインディングや強制的なアンラップが必要となる↓

import UIKit

@IBOutlet weak var someLabel: UILabel!

// オプショナルバインディングを行う場合
if let label = someLabel {
    label.text
}
// 強制アンラップを行う場合
someLabel!.text

 
 -> 上のコードは値の有無を意図的に使い分けるのでなければ、単に冗長にすぎない
 
 */

// 2.2 サブクラスの初期化より前にスーパークラスを初期化する
class SuperClass {
    let one = 1
}

class BaseClass: SuperClass {
    var two: Int!
    
    override init() {
        super.init()
        two = one + 1
    }
}

BaseClass().one // 1
BaseClass().two // 2

/*
 ↑ スーパークラスの初期化時にはnil、それ以降は初期化された値が代入される
 
 [追記]
 ・super.init()を実行する前にスーパークラスのプロパティを参照していると、スーパークラスを初期化するまで、スーパークラスの値にアクセスすることができないためコンパイルエラーとなる
 ・先にスーパークラスを初期化すると、スーパークラスのイニシャライザを呼び出す前にサブクラスのプロパティが初期化されている必要があるため、コンパイルエラーとなる
 */

// MARK: - Optional<Wrapped>型と暗黙的にアンラップされたOptional<Wrapped>型を比較検討するべき時

// MARK: -
// MARK: -
