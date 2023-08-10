//
//  CompletedViewController.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/08.
//

import UIKit

// WriteTodoViewController에서 '할일'을 완료된 것의 컨트롤러
class CompletedViewController: UIViewController {
    
    var completedTasks: [Task] = []
    
    @IBOutlet weak var completedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.completedTableView.dataSource = self
        self.completedTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoCompleted(_:)), name: .todoCompleted, object: nil)
        
        // 완료된 '할일' 목록을 배열에 설정 및 갱신
        completedTasks = DataManager.shared.completedTasks
        completedTableView.reloadData()
    }
    
    // 완료 처리 메서드
    @objc func todoCompleted(_ notification: Notification) {
        if let completedTask = notification.object as? Task {
            if let index = completedTasks.firstIndex(of: completedTask) {
                DataManager.shared.completeTask(index)
                completedTasks = DataManager.shared.completedTasks
                completedTableView.reloadData()
            }
        }
    }
}

extension CompletedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = completedTableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath) as! CompletedCell
        let task = completedTasks[indexPath.row]
        
        // '할일' 완료된 셀의 내용 구성
        cell.configure(with: task)
        
        return cell
    }
    
    // 완료된 셀들을 '삭제' 스와이프 설정
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deletedAciton = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
            let taskToRemove = self?.completedTasks[indexPath.row]
            DataManager.shared.removeCompletedTask(taskToRemove)
            self?.completedTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deletedAciton])
        
        return configuration
    }
}
