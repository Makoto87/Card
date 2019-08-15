//
//  ViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

// ユーザーカードの情報を5枚から2枚に変更
// 動作は変わらないようにする。5人の情報を表示し、色も変える

import UIKit

class ViewController: UIViewController {

    // viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    // スワイプ中にgood or bad の表示
    @IBOutlet weak var likeImage: UIImageView!
    // ユーザーカード
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!

    // ユーザーカード1の画像とラベル
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet var labels1: [UILabel]!
    // ユーザーカード2の画像とラベル
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet var labels2: [UILabel]!
    
    // ユーザー情報の配列
    let userInfo: [[String: Any]] = [
        ["image": "津田梅子", "name": "津田梅子", "work": "教師", "from": "千葉", "color": #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)],
        ["image": "ガリレオガリレイ", "name": "ガリレオガリレイ", "work": "物理学者", "from": "イタリア", "color": #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)],
        ["image": "ジョージワシントン", "name": "ジョージワシントン", "work": "大統領", "from": "アメリカ", "color": #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)],
        ["image": "板垣退助", "name": "板垣退助", "work": "議員", "from": "高知", "color": #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)],
        ["image": "ジョン万次郎", "name": "ジョン万次郎", "work": "冒険家", "from": "アメリカ", "color": #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)]
    ]
    
    
    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数
    var selectedCardCount: Int = 0
    // ユーザーリスト
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    // 「いいね」をされた名前の配列
    var likedName: [String] = []


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
        // ユーザー情報をセットする
        userChange()
    }
    
    func userChange() {
        let number = selectedCardCount % 2
        self.view.bringSubviewToFront(personList[number])
        if selectedCardCount >= userInfo.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        } else {
            if number == 0 {
                image1.image = UIImage(named: userInfo[selectedCardCount]["image"] as! String )
                labels1[0].text = userInfo[selectedCardCount]["name"] as? String
                labels1[1].text = userInfo[selectedCardCount]["work"] as? String
                labels1[2].text = userInfo[selectedCardCount]["from"] as? String
                person1.backgroundColor = userInfo[selectedCardCount]["color"] as? UIColor
            } else {
                image2.image = UIImage(named: userInfo[selectedCardCount]["image"] as! String)
                labels2[0].text = userInfo[selectedCardCount]["name"] as? String
                labels2[1].text = userInfo[selectedCardCount]["work"] as? String
                labels2[2].text = userInfo[selectedCardCount]["from"] as? String
                person2.backgroundColor = userInfo[selectedCardCount]["color"] as? UIColor
            }
        }
    }
    

    // view表示前に呼ばれる（遷移すると戻ってくる度によばれる）
    override func viewWillAppear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
        userChange()
    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController

            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
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

        let number = selectedCardCount % 2
        // ベースカード
        let card = sender.view!
        // 動いた距離
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにも同じ動きをさせる
        personList[number].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        personList[number].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)

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
                userChange()

                if selectedCardCount >= userInfo.count {
                    // 遷移処理
                    performSegue(withIdentifier: "ToLikedList", sender: self)
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
                // いいねリストに追加
                likedName.append(nameList[selectedCardCount])
                // 次のカードへ
                selectedCardCount += 1
                userChange()
                
                if selectedCardCount >= userInfo.count {
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
            let number = self.selectedCardCount % 2
            // ベースカードをリセット
            self.resetCard()
            // ユーザーカードを左にとばす
            self.personList[number].center = CGPoint(x:self.personList[number].center.x - 500, y:self.personList[number].center.y)
        })

        selectedCardCount += 1
        userChange()

    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: Any) {

        UIView.animate(withDuration: 0.5, animations: {
            let number = self.selectedCardCount % 2
            self.resetCard()
            self.personList[number].center = CGPoint(x:self.personList[number].center.x + 500, y:self.personList[number].center.y)
        })
        // いいねリストに追加
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        userChange()
        resetPersonList()

    }
}

