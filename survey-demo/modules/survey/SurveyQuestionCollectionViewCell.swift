//
//  SurveyQuestionCollectionViewCell.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 13/12/2023.
//

import UIKit

class SurveyQuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    
    func configureCellWithQuestion(_ question: QuestionModel) {
        questionLabel.text = question.attributes?.text
        if question.answers.isEmpty {
            return
        }
        self.answerView.subviews.forEach({ $0.removeFromSuperview()})
        configureAnswersForQuestion(question)
        
    }
    
    private func configureAnswersForQuestion(_ question: QuestionModel) {
        guard let displayType = question.attributes?.displayType.lowercased() else { return }
        switch displayType {
        case "star", "heart", "smiley":
            configureRatingAnswerUI(question.answers, withType: displayType)
        default:
            break
        }
        
    }
    
    private func configureRatingAnswerUI(_ answers: [ItemData], withType: String) {
        print("type: \(withType)")
        let customRatingView = Bundle.main.loadNibNamed("RatingView", owner: nil, options: nil)?.first as! RatingView
        customRatingView.answerType = withType
        customRatingView.setupImagesForButton()
        customRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.addSubview(customRatingView)
        NSLayoutConstraint.activate([
            customRatingView.centerXAnchor.constraint(equalTo: self.answerView.centerXAnchor),
            customRatingView.topAnchor.constraint(equalTo: self.answerView.topAnchor, constant: 30),
            customRatingView.widthAnchor.constraint(equalToConstant: 200),
            customRatingView.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
}
