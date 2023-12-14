//
//  HomeViewModel.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 14/12/2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func updateUIWithData(for index: Int)
//    func animateBackgroundZoomIn(_ zoomIn: Bool)
}

class HomeViewModel {
    private(set) var currentIndex: Int = 0
    private(set) var listSurveys: [Survey] = []

    weak var delegate: HomeViewModelDelegate?

    func fetchSurveys() {
        SurveyManager.shared.fetchSurveys(pageNumber: 1, pageSize: 8) { result in
            switch result {
            case .success(let surveyList):
                self.listSurveys = surveyList.data
                DispatchQueue.main.async {
                    self.delegate?.updateUIWithData(for: self.currentIndex)
                }
            case .failure(let error):
                print("Error fetching surveys: \(error)")
            }
        }
    }

    func showNextArticle() {
        currentIndex = (currentIndex + 1) % listSurveys.count
        delegate?.updateUIWithData(for: currentIndex)
//        delegate?.animateBackgroundZoomIn(true)
    }

    func showPreviousArticle() {
        currentIndex = (currentIndex - 1 + listSurveys.count) % listSurveys.count
        delegate?.updateUIWithData(for: currentIndex)
//        delegate?.animateBackgroundZoomIn(true)
    }
}
