//
//  CompletedCell.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/08.
//

import Foundation
import UIKit

class CompletedCell: UITableViewCell {
    @IBOutlet weak var completedLabel: UILabel!
    
    // '할일' 정보를 셀 구성
    func configure(with task: Task) {
        completedLabel.text = task.todoTitle
        
        // 완료된 '할일'에 취소선 설정
        let attributedText = NSMutableAttributedString(string: task.todoTitle)
        if task.isDone {
            attributedText.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributedText.length))
            attributedText.addAttribute(.strikethroughColor, value: UIColor.red, range: NSRange(location: 0, length: attributedText.length))
        }
        completedLabel.attributedText = attributedText
    }
}
