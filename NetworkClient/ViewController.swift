//
//  ViewController.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 这里是简单的调用入口
        HDNetwork.test.init(userName: "汪汉 东", password: "1111").sendRequest({ (result) in
            print("返回了结果")
        }) { (error) in
            print("网络出错了： \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

