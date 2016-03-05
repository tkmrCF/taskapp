//
//  InputViewController.swift
//  taskapp01
//
//  Created by 株式会社コアファイン on 2016/02/23.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit
import RealmSwift


class InputViewController: UIViewController {

    /** 最初にUIを作成した時に設定したアウトレット **/
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var CategolyTextField: UITextField!
    
    let realm = try! Realm()
    var task:Task!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /**
        タップを判断するにはUITapGestureRecognizerクラスを利用します。
        UITapGestureRecognizerクラスの初期化時にタップされたときにどのクラスのどのメソッドが呼ばれるかを指定します。
        今回はself=InputViewController自身、dismissKeyboardメソッドを指定します。
        そしてviewプロパティが背景に該当するので、addGestureRecognizerメソッドで生成したUITapGestureRecognizerクラスのインスタンスを設定します。
        これで背景をタップした時にdismissKeyboardメソッドが呼ばれるようになりました。**/
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
        /**
        UIに値を反映するには、最初にUIを作成した時に設定したアウトレットにそれぞれの値を設定します。
        **/
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        CategolyTextField.text = task.category
            /** セルをタップした時の　ViewController側の処理
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            **/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /**
    タスク一覧画面に戻る時に、UIに入力された値をデータベースに保存する
    viewWillDisappear:メソッドは遷移する際に、画面が非表示になるとき呼ばれるメソッドです。
    ここでRealmのwriteメソッドを使います。削除の時と同じようにtry!を付けます。**/
    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.CategolyTextField.text!
            self.realm.add(self.task, update: true)
        }
        
        // 7.4 ローカル通知を設定する
        // 当初この設定が抜けてたため、アラームが起動せずでした。
        setNotification(task)
        
        super.viewWillDisappear(animated)
    }
    
    
    /**
    dismissKeyboardメソッドにはキーボードを閉じる処理であるendEditing(true)を呼び出します。
    **/
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
 
    /***** add by『7.4 ローカル通知を設定する』*/
    // タスクのローカル通知を設定する
    func setNotification(task: Task) {
        
        // すでに同じタスクが登録されていたらキャンセルする
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break   // breakに来るとforループから抜け出せる
            }
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id":task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    /***** add by『7.4 ローカル通知を設定する』*/
    
    
    
}



