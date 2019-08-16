//
//  ViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//


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
        // personListにperson1・2を追加
        personList.append(person1)
        personList.append(person2)
    }

    // view表示前に呼ばれる（遷移すると戻ってくる度によばれる）
    override func viewWillAppear(_ animated: Bool) {
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
        // ユーザー情報初期化
        userChange()
        // 透明化キャンセル
        person1.alpha = 1
        person2.alpha = 1
    }

    // 画面遷移時に1枚目のカードを下に持ってくる
    override func viewDidDisappear(_ animated: Bool) {
        let number = selectedCardCount % 2
        self.view.sendSubviewToBack(personList[number])
    }

    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ToLikedList" {
            let vc = segue.destination as! LikedListTableViewController

            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }

    // person1のカード情報変換をまとめた
    func changeNumber1(number1: Int){
        image1.image = UIImage(named: userInfo[number1]["image"] as! String )
        labels1[0].text = userInfo[number1]["name"] as? String
        labels1[1].text = userInfo[number1]["work"] as? String
        labels1[2].text = userInfo[number1]["from"] as? String
        person1.backgroundColor = userInfo[number1]["color"] as? UIColor
    }
    // person2のカード情報変換をまとめた
    func changeNumber2(number2: Int){
        image2.image = UIImage(named: userInfo[number2]["image"] as! String )
        labels2[0].text = userInfo[number2]["name"] as? String
        labels2[1].text = userInfo[number2]["work"] as? String
        labels2[2].text = userInfo[number2]["from"] as? String
        person2.backgroundColor = userInfo[number2]["color"] as? UIColor
    }

    // ユーザーカードにユーザー情報を入れる。奇数か偶数で決める
    func userChange() {
        let number = selectedCardCount % 2
        // ユーザー情報を入れる前に画面遷移があるか確かめる
        if selectedCardCount >= userInfo.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        } else {
            // 偶数のときにユーザー1に情報を入れる
            if number == 0 {
                changeNumber1(number1: selectedCardCount)
            } else {
                // 奇数のとき
                changeNumber2(number2: selectedCardCount)
            }
        }
    }

    // ベースカードを元に戻す
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard
        // 角度を戻す
        baseCard.transform = .identity
    }

    /// ユーザーカードを左右に飛ばす処理
    func farCard(distance: CGFloat) {
        let number = selectedCardCount % 2
        // X座標をdistance分飛ばす
        personList[number].center = CGPoint(x: personList[number].center.x + distance, y :personList[number].center.y)
        // ベースカードをリセット
        resetCard()
    }

    // スワイプ処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // どちらのユーザーカードを扱うか判断
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
            // 下のカードを次に表示するデータに変える。sekectedCardCountが1つ増える前なので、-1した
            if selectedCardCount >= userInfo.count - 1 {
                // 画面遷移するとき、下のカードの透明化
                person2.alpha = 0
            } else {
                if number == 0 {
                    // ユーザー1の情報をスワイプするときの下のカード
                    changeNumber2(number2: selectedCardCount + 1)
                } else {
                    // 2のカードをスワイプするときの下のカード
                    changeNumber1(number1: selectedCardCount + 1)
                }
            }
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
            // 下のカードを次に表示するデータに変える。sekectedCardCountが1つ増える前なので、-1した
            if selectedCardCount >= userInfo.count - 1 {
                // 画面遷移するとき、下のカードの透明化
                person2.alpha = 0
            } else {
                if number == 0 {
                    // ユーザー1の情報をスワイプするときの下のカード
                    changeNumber2(number2: selectedCardCount + 1)
                } else {
                    // 2のカードをスワイプするときの下のカード
                    changeNumber1(number1: selectedCardCount + 1)
                }
            }
        }
        // 元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended {

            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 左へ飛ばす場合
                    // X座標を左に500とばす(-500)
                    self.farCard(distance: -500)
                })
                // likeImageを隠す
                likeImage.isHidden = true
                // カード数のカウントを増やす
                selectedCardCount += 1
                // 次のカードの情報を入れる
                userChange()
                // ユーザーカードを戻すとともに下に移動させる
                personList[number].center = self.centerOfCard
                personList[number].transform = .identity
                self.view.sendSubviewToBack(personList[number])
            } else if card.center.x > self.view.frame.width - 50 {
                // 右に大きくスワイプしたときの処理
                UIView.animate(withDuration: 0.5, animations: {
                    // 右へ飛ばす場合
                    // X座標を右に500とばす(+500)
                self.farCard(distance: +500)
                })
                // ベースカードの角度と位置を戻す
                resetCard()
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねリストに追加
                likedName.append(nameList[selectedCardCount])
                // カードのカウント数増やす
                selectedCardCount += 1
                // 次のカード情報を入れる
                userChange()
                // ユーザーカードを戻すとともに下へ移動
                personList[number].center = self.centerOfCard
                personList[number].transform = .identity
                self.view.sendSubviewToBack(personList[number])
            } else {    // カード飛ばさないとき
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.personList[number].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[number].transform = .identity
                    // ベースカードの角度と位置を戻す
                    self.resetCard()
                    // likeImageを隠す
                    self.likeImage.isHidden = true
                })
            }
        }
    }

    // よくないねボタン
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        // 使うカードの選択
        let number = self.selectedCardCount % 2
        // カードを飛ばす処理
        UIView.animate(withDuration: 0.5, animations: {
            self.farCard(distance: -500)
        })
        // ユーザーカードを下へ移動
        self.view.sendSubviewToBack(personList[number])
        // ボタンを選択できなくする(連打防止)
        sender.isEnabled = false
        // 次のカードへ
        selectedCardCount += 1
        // 0.5秒後に次のカードを表示させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            // 次のカード情報を入れる
            self.userChange()
            // ボタン使用可能にする
            sender.isEnabled = true
            // ユーザーカードをもとに戻す
            self.personList[number].center = self.centerOfCard
        })

        // 下のカードを次のユーザーカードの情報にする
        if selectedCardCount >= userInfo.count {
            // 画面遷移するときに何も表示
            person1.alpha = 0
            person2.alpha = 0
        } else {
            // ユーザー1を扱っているとき
            if number == 0 {
                changeNumber2(number2: selectedCardCount)
            // ユーザー2を扱っているとき
            } else {
                changeNumber1(number1: selectedCardCount)
            }
        }

    }

    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: UIButton) {
        // 使うカードの選択
        let number = self.selectedCardCount % 2
        // カードを飛ばす処理
        UIView.animate(withDuration: 0.5, animations: {
            self.farCard(distance: +500)
        })
        // 飛ばしたユーザーカードを下に持ってくる
        self.view.sendSubviewToBack(personList[number])

        // いいねリストに追加
        likedName.append(nameList[selectedCardCount])
        // ボタンを選択できなくする(連打防止)
        sender.isEnabled = false
        selectedCardCount += 1
        // 0.5秒後に次のカードを表示させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            // 次のユーザーカードを表示する処理
            self.userChange()
            // ボタン使用可能にする
            sender.isEnabled = true
        })
        // 下のカードを次のユーザーカードにする
        if selectedCardCount >= userInfo.count {
            // 画面遷移時に透明にする
            person2.alpha = 0
            person1.alpha = 0
        } else {
            if number == 0 {
                changeNumber2(number2: selectedCardCount)
            } else {
                changeNumber1(number1: selectedCardCount)
            }
        }
    }
}

