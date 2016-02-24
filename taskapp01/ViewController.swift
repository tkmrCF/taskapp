//
//  ViewController.swift
//  taskapp01
//
//  Created by 株式会社コアファイン on 2016/02/21.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit
import RealmSwift


class Task: Object {
    // 管理用 ID。プライマリーキー
    dynamic var id = 0
    
    // タイトル
    dynamic var title = ""
    
    // 内容
    dynamic var contents = ""
    
    // カテゴリ          ******* 課題対応
    dynamic var category:String = ""
    
    /// 日時
    dynamic var date = NSDate()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /***************  add by『6.5 Realm のデータベースファイル』*/
    @IBOutlet weak var tableView: UITableView!
     
    // Realmインスタンスを取得する
    let realm = try! Realm()  // ←追加
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    let taskArray = try! Realm().objects(Task).sorted("date",ascending: false)   // ←追加
    /***************  add by『6.5 Realm のデータベースファイル』*/
    
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 0               ***cheng
        return taskArray.count  // ←追加する by 6.6
    }
    
    // 各セルの内容を返すメソッド
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        /***** add by『6.6 TableViewのプロトコルメソッドの中身を実装する』*/
        //Cellに値を設定する// ←以降、実際のデータを表示するように修正/追加する
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.stringFromDate(task.date)
        cell.detailTextLabel?.text = dateString
        /***** add by『6.6 TableViewのプロトコルメソッドの中身を実装する』*/
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド（セルをタップした時）
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /****** add by『5.3 ViewControllerからInputViewControllerに遷移させる』*/
        performSegueWithIdentifier("cellSegue",sender: nil) // ←追加する
        /** セルをタップした時と　+ボタンをタップした時とを区別するため **/
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete;
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        /***** add by『6.6 TableViewのプロトコルメソッドの中身を実装する』*/
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
        /***** add by『6.6 TableViewのプロトコルメソッドの中身を実装する』*/
    }
    
    
    /***** add by『6.7 画面遷移する時にデータを渡す』*/
    // segue で画面遷移するに呼ばれる
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let inputViewController:InputViewController = segue.destinationViewController as! InputViewController
        
        if segue.identifier == "cellSegue" {
            /**
             セルをタップした時は先ほど設定したIdentifierがcellSegueであるsegueが発行されます。IdentifierがcellSegueのときはすでに作成済みのタスクを編集するときなので配列taskArrayから該当するTaskクラスのインスタンスを取り出してinputViewControllerのtaskプロパティに設定します。**/
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            /**
             +ボタンをタップした時はTaskクラスのインスタンスを生成して、初期値として現在時間と、プライマリキーであるIDに値を設定します。taskArray.max("id")ですでに存在しているタスクのidのうち最大のものを取得し、1を足すことで他のIDと重ならない値を指定します。**/
            let task = Task()
            task.date = NSDate()
            
            if taskArray.count != 0 {
                task.id = taskArray.max("id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    /***** 上記追加にあたり、注意事項：  InputViewController.swiftに
            let realm = try! Realm()
            var task:Task! 
            の追記も同時にしないと、”inputViewController.task =”でエラーになる。****/
    /***** add by『6.7 画面遷移する時にデータを渡す』*/
    
    
    

}

