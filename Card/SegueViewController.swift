//
//  SegueViewController.swift
//  Card
//
//  Created by VERTEX20 on 2019/08/14.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class SegueViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // いいねが1つもないときの画面遷移先
        textView.text = "まだいいね！は\nありません。"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
