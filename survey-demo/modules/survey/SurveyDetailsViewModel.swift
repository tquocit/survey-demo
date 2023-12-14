//
//  SurveyDetailsViewModel.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 14/12/2023.
//

import Foundation

protocol SurveyDetailsViewModelDelegate: AnyObject {
    func surveyDetailsDidLoad()
    func surveyDetailsLoadFailed(with error: Error)
}

class SurveyDetailsViewModel {
    
    weak var delegate: SurveyDetailsViewModelDelegate?

    private(set) var arrayQuestionsSurvey = [QuestionModel]()
    var surveyID: String

    init(surveyID: String) {
        self.surveyID = surveyID
    }
    
    func fetchSurveyDetails() {
        SurveyManager.shared.fecthSurveyDetails(surveyID: surveyID) { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.arrayQuestionsSurvey = response.questions
                    self.delegate?.surveyDetailsDidLoad()
                }
            case .failure(let error):
                self.delegate?.surveyDetailsLoadFailed(with: error)
            }
        }
    }
}
