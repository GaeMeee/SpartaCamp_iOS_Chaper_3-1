//
//  WriteTodoViewController.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/08.
//

import UIKit

// 할 일 작성 컨트롤러에 사용할 프로토콜
protocol WriteTodoDelegate: AnyObject {
    func taskCompleted(_ task: Task)
}

// 할 일 작성 및 관리 컨트롤러
class WriteTodoViewController: UIViewController {
    
    weak var delegate: WriteTodoDelegate?
    
    @IBOutlet weak var todoTableView: UITableView!
    
    // "추가" 버튼을 누를 때 호출되는 메서드
    @IBAction func createTodoButton(_ sender: Any) {
        let todoAlert = UIAlertController(title: "할일 작성", message: "추가", preferredStyle: .alert)
        todoAlert.addTextField{ textField in
            textField.placeholder = "입력해주세요"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] action in
            if let textField = todoAlert.textFields?.first, let todoText = textField.text, !todoText.isEmpty {
                let task = Task(todoTitle: todoText, isDone: false)
                
                // DataManager에 추가하고 tableView 갱신
                DataManager.shared.addTask(task)
                
                self?.todoTableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        todoAlert.addAction(addAction)
        todoAlert.addAction(cancelAction)
        
        self.present(todoAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoTableView.dataSource = self
        self.todoTableView.delegate = self
    }
}

extension WriteTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableView에 DateManaer.dhared.tasks 배열에 있는 갯수만큼 표시할 행 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.tasks.count
    }
    
    // tableView 셀을 구성하고 반환, 스위치의 값 변경 처리 및 상태 업데이트
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "todoCells", for: indexPath) as! TodoListCell
        let task = DataManager.shared.tasks[indexPath.row]
        
        cell.textLabel?.text = task.todoTitle
        
        // 셀 내부 레이블과 스위치 설정
        cell.todoLabel.text = task.todoTitle
        cell.todoSwitch.isOn = task.isDone
        cell.todoSwitch.tag = indexPath.row
        cell.todoSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    // 작성한 '할일'들을 수정할 수 있는 스와이핑
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editContext = UIContextualAction(style: .normal, title: "수정") { [weak self] (_, _, completionHandler) in
            let taskToEdit = DataManager.shared.tasks[indexPath.row]
            
            let editAlert = UIAlertController(title: "할일 수정", message: nil, preferredStyle: .alert)
            editAlert.addTextField{ textField in
                textField.text = taskToEdit.todoTitle
            }
            
            let editAction = UIAlertAction(title: "수정", style: .default) { [weak self] action in
                if let textField = editAlert.textFields?.first, let editedTodoText = textField.text, !editedTodoText.isEmpty {
                    DataManager.shared.editTask(at: indexPath.row, with: editedTodoText)
                    self?.todoTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            
            let cancelEditAction = UIAlertAction(title: "취소", style: .cancel)
            
            editAlert.addAction(editAction)
            editAlert.addAction(cancelEditAction)
            
            self?.present(editAlert, animated: true)
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [editContext])
        
        return configuration
    }
    
    // 스위치 값 변경했을 때 이벤트 처리
    @objc func switchValueChanged(_ sender: UISwitch) {
        let rowIndex = sender.tag
        DataManager.shared.tasks[rowIndex].isDone = sender.isOn
        todoTableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        
        if sender.isOn {
            DataManager.shared.completeTask(rowIndex)
            NotificationCenter.default.post(name: .todoCompleted, object: nil)
        }
        
        todoTableView.reloadData()
    }
}

extension Notification.Name {
    static let todoCompleted = Notification.Name("todoCompleted")
}
