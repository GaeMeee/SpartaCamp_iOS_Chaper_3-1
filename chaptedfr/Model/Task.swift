//
//  Task.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/08.
//

import Foundation

// '할일' 장보를 갖은 구조체
struct Task: Codable, Equatable {
    var todoTitle: String
    var isDone: Bool
}
