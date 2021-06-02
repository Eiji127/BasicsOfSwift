// MARK: - イベントとは
/*
 ・イベント：UI要素のタップやプロパティの値の変更など、アプリケーション内で発生するあらゆる事象のこと
 ・イベント通知：イベントの発生箇所となるオブジェクトが、ほかのオブジェクトにイベントの発生を通知すること
 */

// MARK: - Swiftにおけるイベントの通知パターン
/*
 ・iOSやmacOS向けのアプリ開発においてSwiftではCocoaやCocoa Touchというオブジェクト指向のAPI群を利用する
 [Cocoa、Cocoa Touchにおけるオブジェクト間のイベント通知方法]
 ⅰ. デリゲートパターン
 ⅱ. クロージャ
 ⅲ. オブザーバパターン
 */

// MARK: - デリゲートパターン - 別オブジェクトへの処理の委託
/*
 ・1対1のイベント通知方法
 ・Cocoa、Cocoa Touchクラスの主要なコンポーネントの多くは、デリゲートパターンで実装されている
 ・デリゲートパターン：あるオブジェクトの処理を別のオブジェクトに代替させるパターン

 [メリット]
 ・デリゲート先のオブジェクトを切り替えることでデリゲート元の振る舞いを柔軟に変更できる
 [デメリット]
 ・必要な処理はプロトコルとして事前に宣言されている必要があるため、記述するコードは多くなりがち...
 */

// 1. 実装方法
/*
 [実装の手順]
 ・委譲する処理をプロトコルのメソッドとして宣言する
 ↓
 ・デリゲート先のオブジェクトはそのプロトコルに準拠し、デリゲート元のオブジェクトからの処理の委譲に応えられるようにする
 ↓
 ・デリゲート元のオブジェクトはデリゲート先のオブジェクトをプロパティとして持ち、デリゲート先のメソッドを実行して処理を委譲する
 */
protocol GameDelegate: class {
    var numberOfPlayers: Int { get }
    func gameDidStart(_ game: GameForDelegate)
    func gameDidEnd(_ game: GameForDelegate)
}

class TwoPersonsGameDelegate: GameDelegate {
    var numberOfPlayers: Int { return 2 }
    
    func gameDidStart(_ game: GameForDelegate) {
        print("Game start")
    }
    
    func gameDidEnd(_ game: GameForDelegate) {
        print("Game end")
    }
}

class GameForDelegate {
    weak var delegate: GameDelegate?
    
    func start() {
        print("Number of players is \(delegate?.numberOfPlayers ?? 1)")
        delegate?.gameDidStart(self)
        print("Playing")
        delegate?.gameDidEnd(self)
    }
}

let delegate = TwoPersonsGameDelegate()
let twoPersonsGame = GameForDelegate()
twoPersonsGame.delegate = delegate
twoPersonsGame.start()
/*
 実行結果：
 Number of players is 2
 Game start
 Playing
 Game end
 */

// - 命名規則
/*
 [Point]
 ・メソッド名はデリゲート元のオブジェクト名から始め、続いてイベントを説明する
 ・didやwillなどの助動詞を用いてイベントのタイミングを示す
 ・第1引数にはデリゲート元のオブジェクトを渡す
 例：
 public protocol UITableViewDelegate: NSObjectProtocol, UIScrollViewDelegate {
 
    optional public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
 
 }
 
 -> これらの命名規則は自分自身で定義したデリゲートメソッドにも適用すべき！！
 → 名前の衝突を回避できるという実用上の効果がある
 → 既存のCocoa、Cocoa Touchフレームワークと違和感なく強調させることができる
 */

// - 弱参照による循環参照への対処
/*
 
 [循環参照について]
 ・強参照：参照カウントを1つカウントする　←→　弱参照：参照カウントを数えない
 ・デフォルトでは強参照となる
 ・弱参照(weakキーワード)は循環参照を解消するために利用する
 ・循環参照：2つのインスタンスが互いに強参照を持ち合う状態のこと(参照カウントが0になることはなく、メモリが確保されたままになる！！)
 ・メモリリーク：メモリが確保されたまま解放されたままになっている状態のこと
 → メモリリークはメモリ領域を圧迫によりパフォーマンスの低下を招いたり、アプリケーションを強制終了させたりする
 
 ・デリゲートパターンではデリゲート先のオブジェクトとデリゲート元のオブジェクトが互いに参照し合う可能性があるため、デリゲート元からデリゲート先への参照を弱参照として、循環参照を回避する
 
 例：
 open class UITableView: UIScrollView, NSCoding {
    weak open var delegate: UITableViewDelegate?
 }
 */

// 2. デリゲートパターンを利用すべきとき
/*
 [利用すべき時]
 ⅰ. 2つのオブジェクト間で多くの種類のイベント通知を行うとき
 ⅱ. 外部からのカスタマイズを前提としたオブジェクトを設計する時
 */

//ⅰ. 2つのオブジェクト間で多くの種類のイベント通知を行うとき
/*
 ・非同期処理中に発生するイベントに応じて実行する関数を切り替えたいケースはよくある
 ex.
 ① 非同期処理を開始したタイミングでプログレスバーを表示する
 ② 非同期処理の途中で、定期的にプログレスバーを更新する
 ③ 非同期処理が完了したタイミングで、プログレスバーを非表示にする
 (④ 非同期処理が失敗したタイミングで、エラーダイアログを表示する)
 
 ・クロージャのコールバックでも対応することはできるが、複数のコールバックが存在するケースではコードが煩雑になる
 -> 通知するイベントの種類が多い場合はデリゲートパターンを利用すべし！！！！
 */

// ⅱ. 外部からのカスタマイズを前提としたオブジェクトを設計する時
/*
 ・オブジェクトの中でも外部からのカスタマイズを前提とした設計が適しているものがある
 -> そのケースではデリゲートパターンを採用するべき！！
 ・デリゲートパターンでは、カスタマイズ可能な処理をプロトコルとして定義するため、オブジェクトのどの振る舞いがカスタマイズ可能かは明らか
 */

// MARK: - クロージャ - 別オブジェクトへのコールバック時の処理の登録
/*
 ・1対1のイベント通知方法
 ・コールバックとしてよく利用される
 ・非同期処理のためのDispatchモジュールのAPIの多くは、コールバックをクロージャで受け取る
 ・クロージャを用いることで呼び出し元と同じ場所にコールバック処理を記述することができる
 → 処理の流れを追いやすくなる！！
 ・But!! 複数のコールバック関数が必要であったり、コールバック時の処理が複雑な場合は、ネストが深くなり可読性が低下してしまう...😓
 */

// 1. 実装方法
/*
 [実装手順]
 ・非同期処理を行うメソッドの引数にクロージャを追加する
 */
class GameForClosure {
    private var result = 0
    
    func start(completion: (Int) -> Void) {
        print("Playing")
        result = 42
        completion(result)
    }
}

let gameForClosure = GameForClosure()
gameForClosure.start { result in
    print("Result is \(result)")
}
/*
 実行結果：
 Playing
 Result is 42
 
 → GameForClosureクラス内のstart(completion:)メソッド内でcompletion(_)の引数に設定された値が呼び出し時に、値として渡される
 */

// - キャプチャリスト(capture list)：キャプチャ時の参照方法の制御
/*
 ・クロージャのキャプチャ：クロージャが定義されたスコープに存在する変数や定数への参照を、クロージャ内のスコープでも保持すること
 ・デフォルトでは、キャプチャはクラスのインスタンスへの強参照
 -> クロージャが解放されない限りはキャプチャされたクラスのインスタンスは解放されない！！
 */

import PlaygroundSupport
import Dispatch

// Playgroundでの非同期実行を持つオプション
PlaygroundPage.current.needsIndefiniteExecution = true

class SomeClassForCapture {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    deinit {
        print("deinit")
    }
}

do {
    let object = SomeClassForCapture(id: 42)
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: .now() + 3) {
        print(object.id)
    }
}
/*
 実行結果：
 42
 deinit
 
 → asyncAfter(deadline:execute:)メソッドの引数として渡されているクロージャにキャプチャされている定数objectは3秒後まで生存し、実行結果にも値が出力されている。
 -> 強参照によって、クロージャの実行までクラスのインスタンスが生存していることがわかる！！
 ・DispatchQueue型のasyncAfter(deadline:execute:)メソッド = 一定時間後に処理を実行する関数
 */

/*
 [キャプチャリストの定義方法]
 { [weakまたはunowned 変数名または定数名] (引数) -> 戻り値 in
        クロージャの呼び出し時に実行される文
 }
 
 ・キャプチャリストを利用することで弱参照をもたせることが可能
 -> キャプチャを弱参照にするとクロージャの解放状況に依存せずにクラスのインスタンスの解放が実行される
 -> キャプチャの弱参照化は、クロージャとキャプチャされたクラスのインスタンスの循環参照の解消にも有効！！
 */
class SomeClassForCaptureList {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

let object1 = SomeClassForCaptureList(id: 42)
let object2 = SomeClassForCaptureList(id: 43)

let closure = { [weak object1, unowned object2] () -> Void in
    print(type(of: object1))
    print(type(of: object2))
}

closure()
/*
 実行結果：
 Optional<SomeClassForCaptureList>
 SomeClassForCaptureList
 */

// - weakキーワード：メモリ解放を想定した弱参照

//import PlaygroundSupport
//import Dispatch

// Playgroundでの非同期実行を持つオプション
//PlaygroundPage.current.needsIndefiniteExecution = true

class SomeClassForWeakKeyword {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

do {
    let object = SomeClassForWeakKeyword(id: 42)
    let closure = { [weak object] () -> Void in
        if let o = object {
            print("objectはまだ解放されていません：id => \(o.id)")
        } else {
            print("objectはすでに解放されました")
        }
    }
    
    print("ローカルスコープ内で実行：", terminator: "")
    closure()
    
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: .now() + 1) {
        print("ローカルスコープ外で実行：", terminator: "")
        closure()
    }
}
/*
 実行結果：
 ローカルスコープ内で実行：objectはまだ解放されていません：id => 42
 ローカルスコープ外で実行：objectはすでに解放されました
 
 → ローカルスコープの実行中は、定数objectの値はまだ解放されていない!
 → ローカルスコープから抜けた1秒後では、定数objectの値がnilとなっており、すでに解放されている
 */

// - unownedキーワード：メモリ解放を想定しない弱参照
/*
 ・unownedキーワードを指定してキャプチャした定数や定数も参照先に対して弱参照を持つため、クロージャの実行時に参照先のインスタンスがすでに解放されている可能性がある！
 -> weakキーワードとは異なる！ → 参照先のインスタンスが解放されていた場合でも、キャプチャした定数や変数の値はnilにはならない
 → 参照先のインスタンスが解放されたあとにunownedキーワードが指定された定数や定数へアクセスすると不正アクセスになり実行時エラーとなる...
 */

//import PlaygroundSupport
//import Dispatch

// Playgroundでの非同期実行を持つオプション
//PlaygroundPage.current.needsIndefiniteExecution = true

class SomeClassForUnownedKeyword {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

do {
    let object = SomeClassForUnownedKeyword(id: 42)
    let closure = { [unowned object] () -> Void in
        print("objectはまだ解放されていません：id => \(object.id)")
    }
    
    print("ローカルスコープ内で実行：", terminator: "")
    closure()
    
    let queue = DispatchQueue.main
    queue.asyncAfter(deadline: .now()) {
        print("ローカルスコープ外で実行：")
        closure() // ← 実行時エラー(Fatal error: Attempted to read an unowned reference but object 0x600001882400 was already deallocated)
    }
}
/*
 実行結果：
 ローカルスコープ内で実行：objectはまだ解放されていません：id => 42
 ローカルスコープ外で実行：
 */

// - キャプチャリストの使い分け：weakキーワードとunownedキーワードの使い分け
/*
 ・weakキーワードはnilを取るため実行時エラーが起きないため安全
 ・unownedキーワードは実行時エラーを起こすリスクはあるが、nilがないことを保証してくれる目印になる
 
 [キャプチャリストを使うべきタイミング]
 ① 循環参照を招かない参照
 ⅰ. クロージャの実行時に参照するインスタンスが必ず存在するべき場合はキャプチャリストは使用しない
 ⅱ. クロージャの実行時に参照するインスタンスが存在しなくても良い場合、weakキーワードを使用する
 ② 循環参照を招く参照
 ⅰ. 参照するインスタンスが先に解放される可能性があるときはweakキーワードを使用する
 ⅱ. 参照するインスタンスが先に解放される可能性がない場合はweakキーワードまたはunownedキーワードを使用する
 */

// - escaping属性によるselfキーワードの必須化
/*
 ・イニシャライザ、プロパティ、メソッドの内部ではselfキーワードを省略してインスタンス自身のプロパティやメソッドにアクセスできる！
 -> escaping属性を持つクロージャの内部は例外！！
 */
class Executor {
    let int = 0
    var lastExecutedClosure: (() -> Void)? = nil
    
    func execute(_ closure: @escaping () -> Void) {
        closure()
        lastExecutedClosure = closure
    }
    
    func executePrintInt() {
        execute {
            print(self.int)
        }
    }
}

// - typealiasキーワードによる複雑なクロージャの型への型エイリアス
/*
 ・typealiasキーワードを用いることで複雑なクロージャの型に型エイリアスを設定できる
 ・引数に複雑な型のクロージャを取る関数の定義はかなり読みにくい！！
 例:
 func someMethod(completion: (Int?, Error?, Array<String>?) -> Void) {}
 
 -> typealiasを使用することで可読性が向上する
 */
typealias CompletionHandler = (Int?, Error?, Array<String>?) -> Void

func someMethod(completion: CompletionHandler) {}

// 2. クロージャを利用すべき時
/*
 [利用すべき時]
 ・処理の実行とコールバックを同じ箇所に記述する時
 */
gameForClosure.start { result in
    print("Result is \(result)")
}

// MARK: - オブザーバパターン - 状態変化の別オブジェクトへの通知
/*
 ・1対多のイベント通知が可能(1つのイベントの結果を複数のオブジェクトが知る必要がある場合)
 ・Cocoa Touchではアプリケーションの起動やバックグラウンドへの遷移のイベント通知に使用されている
 ・構成要素 = サブジェクト + オブザーバ
 ・オブザーバ：通知を受け取る対象、　サブジェクト：必要なタイミングでオブザーバに通知を発行し、オブザーバを管理するもの
 */

// 1. 実装方法
/*
 ・Cocoaが提供するNotification型とNotificationCenterクラスを用いて実装する
 ・NotificationCenterクラス(= サブジェクト) = 中央に位置するハブのような役割
 ・NotificationCenterクラスを通じてオブジェクトは通知の送受信を実行する
 ・オブザーバはNotificationCenterクラスに登録され、登録の際に通知を受け取るイベントと受け取る際に利用するメソッドを指定する
 
 [オブジェクト間のイベント通知の流れ]
 ① 通知を受け取るオブジェクトにNotification型の値を引数にもつメソッドを実装する
 ② NotificationCenterクラスに通知を受け取るオブジェクトを登録する
 ③ NotificationCenterクラスに通知を投稿する
 
 */
import Foundation

class Poster {
    static let notificationName = Notification.Name("SomeNotification")
    
    func post() {
        NotificationCenter.default.post(name: Poster.notificationName, object: nil)
    }
}

class Observer {
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: Poster.notificationName,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        print("通知を受け取りました")
    }
}

var observer = Observer()
let poster = Poster()
poster.post() // 実行結果：通知を受け取りました
/*
 ①通知を受け取るObserverクラスにNotification型の値を引数にもつhandleNotification(_:)メソッドを実装する
 ②addObserver(_:selector:name:object:)メソッドを用いて、オブザーバのNotificationCenterクラスへの登録を行っている（通知を受け取るオブジェクト、通知を受け取るメソッド、受け取りたい通知の名前、を登録する）
 ③post(name:object:)メソッドを用いて、通知の名前、通知を送るオブジェクトの情報を含んだ通知を投稿している
 */

// - Selector型：メソッドを参照するための型
/*
 [addObserver(_:selector:name:object:)メソッドについて]
 open func addObserver(_ observer: Any,
                       selector aSelector: Selector,
                       name aName: NSNotification.Name?,
                       object anObject: Any?)
 
 ・Selector型はObjective-Cのセレクタの概念を実現している
 ・セレクタ：メソッドの名前を表す型、メソッドをセレクタが属する型とは切り離して扱うことができる
 ・#selectorキーワードを使用することでSelector型を生成することができる
 ・プロパティ名の前にsetterやgetterラベルを記述することでセッタやゲッタのセレクタを取得できる
 #selector(型名.メソッド名)
 #selector(setter: 型名.プロパティ名)
 
 ・Selector型を生成するときはobjective-Cから参照可能にする必要があるため、@objc(objc属性)を指定する必要がある！
 */

// 2. オブザーバパターンを利用すべき時
/*
 [利用すべき時]
 ・1対多のイベント通知を行うとき
 */
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
// MARK: -
