//
//  ExerciseListViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/16.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit

class ExerciseListViewController: UIViewController {
    
    @IBOutlet var exerciseListTableView: UITableView!
    @IBOutlet var navBar: UINavigationItem!
    
    let titleArr = ["일어나란 말이야 지금 잠들때가 아니라 말이야", "삼겹살을 먹으려면 PT를 해야 할껄?", "1:1 발레 자세 교정으로 당당한 걸음을"]
    let nameArr = ["김수연", "원다솜", "김용현"]
    var selectedTheme: String!
    
    override func viewDidLoad() {
        exerciseListTableView.delegate = self
        exerciseListTableView.dataSource = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        navigationBarDesign()
        
        selectedTheme = UserDefaults.standard.string(forKey: UserDefaultKey.selectedTheme)
    }
    
    func navigationBarDesign() {
        navBar.title = "매일 5분 같이 힙업!"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        ]
        
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        leftButton.addTarget(self, action:#selector(goBack), for: .touchDown)
        leftButton.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ExerciseListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTheme {
        case "승모근 스트레칭":
            return 1
        case "승모근과 팔뚝살 빼기":
            return 2
        case "전신 다이어트 스트레칭":
            return 2
        case "층간소음 없는 유산소 운동":
            return 2
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exerciseListTableView.dequeueReusableCell(withIdentifier: "ExerciseListCell", for: indexPath) as! ExerciseListTableViewCell
        switch selectedTheme {
        case "승모근 스트레칭":
            cell.selectionStyle = .none
            cell.exerciseTitleLabel.text = titleArr[indexPath.row % 3]
            cell.exerciseTrainerLabel.text = nameArr[indexPath.row % 3]
            cell.thumbnailView.image = UIImage(named: "\(indexPath.row+1)")
        case "승모근과 팔뚝살 빼기":
            cell.selectionStyle = .none
            cell.exerciseTitleLabel.text = titleArr[indexPath.row % 3]
            cell.exerciseTrainerLabel.text = nameArr[indexPath.row % 3]
            cell.thumbnailView.image = UIImage(named: "\(indexPath.row+1)")
        case "전신 다이어트 스트레칭":
            cell.selectionStyle = .none
            cell.exerciseTitleLabel.text = titleArr[indexPath.row % 3]
            cell.exerciseTrainerLabel.text = nameArr[indexPath.row % 3]
            cell.thumbnailView.image = UIImage(named: "\(indexPath.row+1)")
        case "층간소음 없는 유산소 운동":
            cell.selectionStyle = .none
            cell.exerciseTitleLabel.text = titleArr[indexPath.row % 3]
            cell.exerciseTrainerLabel.text = nameArr[indexPath.row % 3]
            cell.thumbnailView.image = UIImage(named: "\(indexPath.row+1)")
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let exerciseViewController = mainStoryboard.instantiateViewController(withIdentifier: "ExerciseVC") as! ExerciseViewController
        self.navigationController?.pushViewController(exerciseViewController, animated: true)
    }
}
