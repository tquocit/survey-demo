//
//  SurveyManager.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation

class SurveyManager {
    static let shared = SurveyManager()
    
    private init() {}
    
    func fetchSurveys(pageNumber: Int, pageSize: Int, completion: @escaping (Result<SurveyList, Error>) -> Void) {
        let endpoint = "/api/v1/surveys?page[number]=\(pageNumber)&page[size]=\(pageSize)"
        
        if let userAccessToken = UserManager.shared.currentUser?.accessToken,
           let userTokenType = UserManager.shared.currentUser?.tokenType {
            let headers = ["Authorization": "\(userTokenType) \(userAccessToken)"]
            
            BaseNetwork.shared.performRequest(endpoint: endpoint, method: .get, headers: headers) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let surveys = try decoder.decode(SurveyList.self, from: data)
                        completion(.success(surveys))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network request error: \(error)")
                }
            }
        }
        else {
            // Handle missing access token or token type
        }
    }
    
    func fecthSurveyDetails(surveyID: String, completion: @escaping (Result<SurveyDetailsModel, Error>) -> Void) {
        let endpoint = "/api/v1/surveys/\(surveyID)"
        if let userAccessToken = UserManager.shared.currentUser?.accessToken,
           let userTokenType = UserManager.shared.currentUser?.tokenType {
            let headers = ["Authorization": "\(userTokenType) \(userAccessToken)"]
            
            BaseNetwork.shared.performRequest(endpoint: endpoint, method: .get, headers: headers) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let surveyDetailsResponse = try decoder.decode(SurveyDetailsResponse.self, from: data)
                        let surveyDetails = self.processRawData(surveyDetailsResponse)
                        completion(.success(surveyDetails))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network request error: \(error)")
                }
            }
        }
    }
    
    private func processRawData(_ rawData: SurveyDetailsResponse) -> SurveyDetailsModel {
        var questionsArray = [ItemData]()
        var answersArray = [ItemData]()
        
        guard let rawList = rawData.included else {
            return SurveyDetailsModel(id: rawData.data.id, type: rawData.data.type, questions: [])
        }
        for item in rawList {
            if item.type == "question" {
                questionsArray.append(item)
            } else if item.type == "answer" {
                answersArray.append(item)
            }
        }
        
        var arrayQuestionModels = [QuestionModel]()
        for question in questionsArray {
            var answers = [ItemData]()
            guard let answerIDs = question.relationships?.answers.data, !answerIDs.isEmpty else {
                let modelQuestion = QuestionModel(id: question.id, type: question.type, attributes: question.attributes, answers: [])
                arrayQuestionModels.append(modelQuestion)
                continue
            }
            for answerID in answerIDs {
                guard let answer = answersArray.filter({ $0.id == answerID.id }).first else {
                    continue
                }
                answers.append(answer)
            }
            let modelQuestion = QuestionModel(id: question.id, type: question.type, attributes: question.attributes, answers: answers)
            arrayQuestionModels.append(modelQuestion)
        }
        
        var surveyDetailsModel = SurveyDetailsModel(id: rawData.data.id, type: rawData.data.type, questions: arrayQuestionModels)
        
        return surveyDetailsModel
    }
    
    
//    private func filterQuestionsAndAnswerWithRawData(_ rawData: SurveyDetailsResponse) {
//        
//        guard let rawList = rawData.included else { return }
//        let questions = rawData.data.relationships.questions.data
//        var formattedQuestionList = [QuestionModel]()
//        for question in questions {
//            if let formattedQuestion = filterDetailsOfQuestionID(question.id, fromRawList: rawList) {
//                formattedQuestionList.append(formattedQuestion)
//            }
//            
//            
//        }
//        let surveyDetailsModel = SurveyDetailsModel(id: rawData.data.id,
//                                                    type: rawData.data.type, questions: formattedQuestionList)
//        
//    }
//    
//    private func filterDetailsOfQuestionID(_ questionID: String, fromRawList: [ItemData]) -> QuestionModel? {
//        if let rawQuestion = fromRawList.filter({ $0.id == questionID }).first {
//            let questionModel = QuestionModel(id: rawQuestion.id, type: rawQuestion.type, attributes: rawQuestion.attributes, answers: [])
//            if rawQuestion.relationships != nil,
//                !rawQuestion.relationships!.answers.data.isEmpty {
//                
//            }
//            return questionModel
//        }
//        return nil
//    }
//    
//    private func filterItemWithID(_ id: String, fromRawList: [ItemData]) -> ItemData? {
//        return fromRawList.filter({ $0.id == id }).first
//    }
}
