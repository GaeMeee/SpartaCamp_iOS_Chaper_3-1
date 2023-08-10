//
//  DataManager.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/08.
//

import Foundation

// 완료된 작업을 관리하는 클라스
class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    private let tasksKey = "tasks"
    private let completedTasksKey = "completedTasks"
    
    // '할일' 배열 가져오기 및 설정
    var tasks: [Task] {
        get {
            if let savedTasks = UserDefaults.standard.data(forKey: tasksKey), let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
                return decodedTasks
            }
            return []
        }
        set {
            if let encodedTasks = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedTasks, forKey: tasksKey)
            }
        }
    }
    
    // '할일' 완료된 배열 가져오기 및 설정
    var completedTasks: [Task] {
        get {
            if let savedCompletedTasks = UserDefaults.standard.data(forKey: completedTasksKey), let decodedCompledtedTasks = try? JSONDecoder().decode([Task].self, from: savedCompletedTasks) {
                return decodedCompledtedTasks
            }
            return []
        }
        set {
            if let encodedCompletedTasks = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedCompletedTasks, forKey: completedTasksKey)
            }
        }
    }
    
    // '할일' 추가 메서드
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    // '할일' 완료 처리 메서드
    func completeTask(_ index: Int) {
        if index >= 0 && index < tasks.count {
            let completedTask = tasks.remove(at: index)
            completedTasks.append(completedTask)
        }
    }
    
    // '할일' 수정 처리
    func editTask(at index: Int, with newTitle: String) {
        if index >= 0 && index < tasks.count {
            tasks[index].todoTitle = newTitle
            saveEditedTasks()
        }
    }
    
    // '할일' 수정 값 저장
    private func saveEditedTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: tasksKey)
        }
    }
    
    // 완료된 셀 저장
    private func saveCompletedTasks() {
        if let encodedCompletedTasks = try? JSONEncoder().encode(completedTasksKey) {
            UserDefaults.standard.set(encodedCompletedTasks, forKey: completedTasksKey)
        }
    }
    
    // 완료된 셀 삭제
    func removeCompletedTask(_ task: Task?) {
        if let taskToRemove = task, let index = completedTasks.firstIndex(of: taskToRemove) {
            completedTasks.remove(at: index)
            saveCompletedTasks()
        }
    }
}
