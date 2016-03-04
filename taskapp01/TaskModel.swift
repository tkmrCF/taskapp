//
//  TaskModel.swift
//  taskapp01
//
//  Created by 株式会社コアファイン on 2016/03/02.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

//import Foundation

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
