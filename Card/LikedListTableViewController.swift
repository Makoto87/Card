//
//  LikedListTableViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {

    // いいね」された名前の一覧
    var likedName: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "likedTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    // 必須:セルの数を返すメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // いいねされたユーザーの数
        
        return likedName.count
    }

    // 必須:セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! likedTableViewCell
        // いいねされた名前を表示
        cell.nameImage?.image = UIImage(named: likedName[indexPath.row]["imageName"] ?? "")
        cell.name?.text = likedName[indexPath.row]["name"]
        cell.work?.text = likedName[indexPath.row]["work"]
        cell.from?.text = likedName[indexPath.row]["from"]
        // いいねされた人の画像を表示
        
        return cell
    }

}
