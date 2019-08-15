//
//  ViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

// Xibでセルを作成。いいねがひとつもないとき?
// すべての情報を載せる。画像、職種、出身国
// いいねした人がいないときも表示する

import UIKit

class ViewController: UIViewController {

    // viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    // スワイプ中にgood or bad の表示
    @IBOutlet weak var likeImage: UIImageView!
    // ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!

    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数
    var selectedCardCount: Int = 0
    // ユーザーリスト
    let nameList: [[String: String]] = [
        ["imageName": "津田梅子", "name": "津田梅子", "work": "教師", "from": "千葉"],
        ["imageName": "ガリレオガリレイ", "name": "ガリレオガリレイ", "work": "物理学者", "from": "イタリア"],
        ["imageName": "ジョージワシントン", "name": "ジョージワシントン", "work": "大統領", "from": "アメリカ"],
        ["imageName": "板垣退助", "name": "板垣退助", "work": "議員", "from": "高知"],
        ["imageName": "ジョン万次郎", "name": "ジョン万次郎", "work": "冒険家", "from": "アメリカ"]
    ]
    // 「いいね」をされた人の配列
    var likedName: [[String: String]] = []


    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }

    // ロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }

    // view表示前に呼ばれる（遷移すると戻ってくる度によばれる）
    override func viewWillAppear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController
            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }

    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
    }

    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in personList {
            // 元に戻す処理
            person.center = self.centerOfCard
            person.transform = .identity
        }
    }

    // ベースカードを元に戻す
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard
        // 角度を戻す
        baseCard.transform = .identity
    }

    // スワイプ処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {

        // ベースカード
        let card = sender.view!
        // 動いた距離
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

        // likeImageの表示のコントロール
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }

        // 元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended {

            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 左へ飛ばす場合
                    // X座標を左に500とばす(-500)
                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)
                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // 次のカードへ
                selectedCardCount += 1

                if selectedCardCount >= personList.count {
                    // 遷移処理。いいねがあった場合となかった場合
                    if likedName.count > 0 {
                        performSegue(withIdentifier: "ToLikedList", sender: self)
                    } else {
                        performSegue(withIdentifier: "AllBad", sender: self)
                    }
                }

            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 右へ飛ばす場合
                    // X座標を右に500とばす(+500)
                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // プロフィール情報をいいねリストに追加
                likedName.append(nameList[selectedCardCount])
                // 次のカードへ
                selectedCardCount += 1
                
                if selectedCardCount >= personList.count {
                    // 遷移処理
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }

            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    // ベースカードの角度と位置を戻す
                    self.resetCard()
                    // likeImageを隠す
                    self.likeImage.isHidden = true
                })
            }
        }
    }

    // よくないねボタン
    @IBAction func dislikeButtonTapped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            // ベースカードをリセット
            self.resetCard()
            // ユーザーカードを左にとばす
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y:self.personList[self.selectedCardCount].center.y)
        })

        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            if likedName.count > 0 {
            performSegue(withIdentifier: "ToLikedList", sender: self)
            } else {
                performSegue(withIdentifier: "AllBad", sender: self)
            }
        }
    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y:self.personList[self.selectedCardCount].center.y)
        })
        // いいねリストに追加
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
}

