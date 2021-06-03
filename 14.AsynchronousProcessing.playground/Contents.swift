// MARK: - 非同期処理とは
/*
 ・非同期処理：複数の処理を並列化することで効率よくプログラムを実現するための手法
 → 適切に実装しなければ保守性の低いコードになりやすく、バグの温床になる！
 ・Swiftではスレッドを用いて非同期処理を実現している
 ・スレッド：CPU利用の仮想的な実行の単位
 ・マルチスレッド処理：メインスレッドとは別のスレッドを作成、並列に実行すること
 
 [間違ったマルチスレッド処理による問題点の例]
 ・スレッドの過度の使用によるメモリの枯渇
 ・複数のスレッドから同一のデータを更新しようとしたときの不整合の発生
 ・デッドロック(= スレッドが互いに待ち合う状態)の発生
 etc...
 
 [非同期処理を行う方法]
 ① GCD(= コアライブラリlibdispatchが提供)を用いる方法
 ② Operation, OperationQueueクラス(= コアライブラリFoundationが提供)を用いる方法
 ③ Threadクラス(= コアライブラリFoundationが提供)を用いる方法
 */

// MARK: - GCD - 非同期処理のための低レベルAPI群
/*
 ・GCD(Grand Central Dispatch)：非同期処理を容易に行うためにC言語ベースにシステムレベルでの技術
 ・GCDはキューを通じて非同期処理を実行するだけ！
 -> 直接スレッドを管理することはない（システムがスレッドの管理を行い、CPUのコア数や負荷の状況を考慮し自動的に最適化してくれる）
 => タスクをキューに追加することのみをすればよい！！！！
 ・スレッドプール：あらかじめ準備されたスレッドを使い回すスレッド管理の手法
 */

// 1. 実装方法
/*
 ・ディスパッチキュー = GCDのキュー
 
 --[ディスパッチキューの種類]---------------------------------------------
 ・直列ディスパッチキュー(serial dispatch queue)：現在実行中の処理の終了を待ってから次の処理を実行する
 ・並列ディスパッチキュー(concurrent dispatch queue)：現在実行中の処理の終了を待たずに次の処理を並列して実行する
 --------------------------------------------------------------------
 
 --[ディスパッチキューの利用方法]---------------------------------------------
 ・既存のディスパッチキューを取得する
 or
 ・新規のディスパッチキューを生成する
 --------------------------------------------------------------------
 */
// 1.1 既存のディスパッチキューの取得
/*
 ・GCDの既存のディスパッチキュー = 1つのメインキュー(main queue) + 複数のグローバルキュー(global queue)
 ・メインキューはメインスレッドで実行する直列ディスパッチキュー
 */
// - メインキューについて
import Dispatch
let mainQueue = DispatchQueue.main // ← これでメインディスパッチキューを取得している

// - グローバルキューについて
/*
 ・グローバルキューは並列ディスパッチキュー
 ・実行優先度(QoS：Quality of Service)を指定して取得
 ・専用のディスパッチキューを必要とする非同期処理以外は、グローバルキューを使用！！！
 [QoSの高い順]
 ① userInteractive：アニメーションの実行など、ユーザーからの入力に対してインタラクティブに実行され、即時に実行されなければフリーズしているように見える処理に利用
 ② userInitiated：ユーザーインターフェース上のなにかをタップした場合など、ユーザーからの入力を受けて実行される処理に利用
 ③ default：QoSが何も指定されない場合に利用
 ④ utility：プログレスバー付きのダウンロードなど、視覚的な情報の更新を伴いながらも、即時の結果を要求しない処理に利用
 ⑤ background：バックアップなど、目に見えないところで行われて、数分から数時間かかっても問題ない処理に用いる
 定義↓
 public struct DispatchQoS : Equateble {
 ...
 
 public enum QoSClass {
 case background
 case utility
 case `default`  // ←  ``(バッククオート)で囲まれたキーワードは予約語(⚠ 変数や定数などの名前として利用できない！！)
 case userInitiated
 case userInteractive
 ...
 }
 }
 
 */
//import Dispatch
let globalQueue = DispatchQueue.global(qos: .userInitiated)

// 1.2 新規のディスパッチキューの生成
// ・DispatchQueue型のイニシャライザから新たにディスパッチキューを生成する方法がある
//import Dispatch
// com.my_company.my_app.upload_queueという名前の並列ディスパッチキューを生成
let newDispatchQueue = DispatchQueue(label: "com.my_company.my_app.upload_queue",
                                     qos: .default,
                                     attributes: [.concurrent])
/*
 ・labelにはディスパッチキューの名前、qosには優先度、attributesには並列か直列かを設定する
 ・ディスパッチキューの命名には逆順DNS(Domain Name System)形式のものを使用
 ->「トップレベルドメイン.会社名.アプリケーション名.キューの役割(= com.my_company.my_app.upload_queue)」のようにする
 -> 使用する目的は、階層構造を用いて名前を一意にすることができ、ほかのライブラリで使用されているキューとの名前の重複を回避することが可能
 */

// 2. ディスパッチキューへのタスクの追加方法
/*
 ・ディスパッチキューへのタスクの追加にはDispatchQueue型のasync(execute:)メソッドを用いる
 ・ディスパッチキューではタスクはクロージャで表記
 */
// 例：
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let newQueue = DispatchQueue.global(qos: .userInitiated)
newQueue.async {
    Thread.isMainThread // false ← ThreadクラスのisMainThreadクラスプロパティの値を確認しメインスレッド上で行われているか確認することが可能
    print("非同期の処理")
}
/*
 実行結果：
 非同期の処理
 */

// 3. GCDを利用すべきとき
/*
 [GCDを利用すべきとき]
 ・シンプルな非同期処理を実装する時
 */
//import Foundation
//import PlaygroundSupport

//Playground.current.needsIndefiniteExecution = true

let globalQueue2 = DispatchQueue.global(qos: .userInitiated)
globalQueue2.async {
    Thread.isMainThread // false
    print("非同期の処理")
    let mainQueue = DispatchQueue.main
    mainQueue.async {
        Thread.isMainThread // true
        print("メインスレッドでの処理")
    }
}
/*
 実行結果：
 非同期の処理
 メインスレッドでの処理
 */


// MARK: - Operation, OperationQueueクラス - 非同期処理を抽象化したクラス
/*
 ・Operationクラス → 実行されるタスクとその情報をカプセル化したもの、Operationクラスのインスタンスがキューに入って順次実行される
 ・OperationQueueクラス -> キューの役割を果たす
 */

// 1. 実装方法
/*
 ① タスクの定義(Operationクラスのサブクラスとしてタスクを定義する)
 ② キューの生成(実行するキューとなるOperationQueueクラスのインスタンス化)
 (③ タスクのキャンセル)
 (④ タスクの依存関係の設定)
 */

// ① タスクの定義(Operationクラスのサブクラスとしてタスクを定義する)
//import Foundation

class SomeOperation: Operation {
    let number: Int
    init(number: Int) {
        self.number = number
    }
    
    override func main() {
        Thread.sleep(forTimeInterval: 1) // 1秒待つ
        print(number)
    }
}

// ② キューの生成(実行するキューとなるOperationQueueクラスのインスタンス化)
//import Foundation
//import PlaygroundSupport

//Playground.current.needsIndefiniteExecution = true

//class SomeOperation2: Operation {
//    let number: Int
//    init(number: Int) {
//        self.number = number
//    }
//
//    override func main() {
//        Thread.sleep(forTimeInterval: 1) // 1秒待つ
//        print(number)
//    }
//}
//
//let queue = OperationQueue()
//queue.name = "com.example_my_operation_queue"
//queue.maxConcurrentOperationCount = 2
//queue.qualityOfService = .userInitiated
//
//var operations = [SomeOperation2]()
//
//for i in 0..<10 {
//    operations.append(SomeOperation2(number: i))
//}
//
//queue.addOperations(operations, waitUntilFinished: false)
//print("Operations are added...")
/*
 実行結果：
 Operations are added...
 0
 1
 3
 2
 5
 4
 6
 7
 9
 8
 
 ⚠番号順は環境によって変化する
 
 ・addOperations(_:waitUntilFinished:)メソッド：キューに追加
 -> waitUntilFinishedがtrueのときは、全てのタスクの実行が終わるまで呼び出したスレッドをブロックする
 ・maxConcurrentOperationCountプロパティ：並列に実行するタスクの最大数を指定する
 → 今回は2が指定されているので1秒に2こずつ値が表示されるようになっている
 */

// ③ タスクのキャンセル
/*
 ・cancel()メソッドでタスクに対してキャンセルしたことを通知する
 ・またOperationクラスのサブクラスにキャンセル時の処理を追加する必要があり！
 */

//import Foundation
//import PlaygroundSupport

//Playground.current.needsIndefiniteExecution = true

//class SomeOperationForCancelation: Operation {
//    let number: Int
//    init(number: Int) {
//        self.number = number
//    }
//
//    override func main() {
//        Thread.sleep(forTimeInterval: 1)
//
//        guard !isCancelled else {
//            return // キャンセル時の処理文
//        }
//
//        print(number)
//    }
//}
//
//let queueForCancel = OperationQueue()
//queueForCancel.name = "com.example_my_operation_queue"
//queueForCancel.maxConcurrentOperationCount = 2
//queueForCancel.qualityOfService = .userInitiated
//
//var operationsForCancel = [SomeOperationForCancelation]()
//
//for i in 0..<10 {
//    operationsForCancel.append(SomeOperationForCancelation(number: i))
//}
//
//queueForCancel.addOperations(operationsForCancel, waitUntilFinished: false)
//operationsForCancel[6].cancel()
/*
 実行結果:
 0
 1
 3
 2
 5
 4
 8
 7
 9
 
 → 6が表示されるタスクが1つキャンセルされている
 */

// ④ タスクの依存関係の設定
/*
 ・addDependency(_:)メソッド：あるタスクに対して、それよりも先に実行されるべきタスクを指定する
 */

//import Foundation
//import PlaygroundSupport

//Playground.current.needsIndefiniteExecution = true

class SomeOperationForDependency: Operation {
    let number: Int
    init(number: Int) {
        self.number = number
    }
    
    override func main() {
        Thread.sleep(forTimeInterval: 1)
        
        if isCancelled {
            return
        }
        
        print(number)
    }
}

let queueForDependency = OperationQueue()
queueForDependency.name = "com.example_my_operation_queue"
queueForDependency.maxConcurrentOperationCount = 2
queueForDependency.qualityOfService = .userInitiated

var operationsForDependency = [SomeOperationForDependency]()

for i in 0..<10 {
    operationsForDependency.append(SomeOperationForDependency(number: i))
    if i > 0 {
        operationsForDependency[i].addDependency(operationsForDependency[i-1])
    }
}

queueForDependency.addOperations(operationsForDependency, waitUntilFinished: false)
/*
 実行結果:
 0
 1
 2
 3
 4
 5
 6
 7
 8
 9
 
 → 順番に表示されている
 */

// 2. Operation,OperationQueueクラスを利用すべき時
/*
 [利用すべき時]
 ・複雑な非同期処理を実行する時
 */

// MARK: - Threadクラス - 手動でのスレッド管理
/*
 ・GCDとOperation、OperationQueueクラスは、スレッドの管理をシステムに任せている
 -> Threadクラスはスレッドの生成から制御をエンジニア自身が管理することが可能
 */

// 1. 実装方法
/*
 ・Threadクラスのサブクラスを実装することでスレッドを定義できる
 ・スレッドのエントリポイントは、main()メソッドをオーバーライドして実装
 ・Threadクラスのインスタンスはstart()メソッドを呼び出して実行する
 */
//import Foundation

class SomeThread: Thread {
    override func main() {
        print("executed.")
    }
}

let thread = SomeThread()
thread.start()
/*
 実行結果:
 executed.
 
 → カレントスレッド：処理を実行しているスレッドのこと
 
 [カレントスレッドの操作メソッド]
 ⅰ. sleep(forTimeInterval:)クラスメソッド：このメソッドが実行されているスレッドを、指定した秒数だけ停止する
 ⅱ. sleep(until:)：時刻を表すDate型の値を引数に取り、その時刻までカウントスレッドを休止させる
 ⅲ. exit()クラスメソッド：カウントスレッドの実行を途中で終了する
 ⅳ. isMainThreadクラスメソッド：カウントスレッドがメインスレッドかどうかを判定する
 */

// 2. Threadクラスの利用すべき時
// => 特になし！！！（スレッドを利用するケースは非同期処理によってパフォーマンスやユーザビリティを改善することが目的！）
// -> スレッドの作成、管理そのものではない！
// MARK: -
// MARK: -
// MARK: -
