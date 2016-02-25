//
//  AppDelegate.swift
//  taskapp01
//
//  Created by 株式会社コアファイン on 2016/02/21.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        /***** add by『7.2 通知からアプリを起動した時の処理』*/
        // ユーザに通知の許可を求める　　/***** add by『7.3 ユーザに通知を出すことに許可を求める』*/
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        /**
        アプリのプロセスが終了した状態はapplication:didFinishLaunchingWithOptions:メソッドで判断することができます。
        ③アプリのプロセスが終了した状態の時
        **/
        // 通知からの起動かどうか確認する
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            // 通知領域から削除する
            application.cancelLocalNotification(notification)
        }
        /***** add by『7.2 通知からアプリを起動した時の処理』*/

        return true
    }

    
    /**
     アプリがフォアグランド、
     またはバックグランドにいるときはapplication:didReceiveLocalNotification:メソッド内で判することができます。
     ①アプリ起動中（フォアグラウンド)
     ②アプリがバックグラウンドでホーム画面か他のアプリがフォアグランドにいる
    **/
    /***** add by『7.2 通知からアプリを起動した時の処理』*/
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // アプリがフォアグランドにいる時に通知が届いた時
        if application.applicationState == UIApplicationState.Active {
            // アラートを表示する
            let alertController = UIAlertController(title: "時間になりました", message:notification.alertBody, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(defaultAction)
            
            window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // バックグランドにいる時に通知が届いた時はログに出力するだけ
            print("\(notification.alertBody)")
        }
        
        // 通知領域から削除する
        application.cancelLocalNotification(notification)
    }
    /***** add by『7.2 通知からアプリを起動した時の処理』*/
    

    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

