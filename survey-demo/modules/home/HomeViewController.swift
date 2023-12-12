//
//  HomeViewController.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleSurvey: UILabel!
    @IBOutlet weak var descriptionSurvey: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    private var currentIndex: Int = 0
    private var listSurveys: [Survey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SurveyManager.shared.fetchSurveys(pageNumber: 1, pageSize: 8) { result in
            switch result {
            case .success(let surveyList):
                self.listSurveys = surveyList.data
                DispatchQueue.main.async {
                    self.configureData()
                }
            case .failure(let error):
                print("Error fetching surveys: \(error)")
            }
        }
        
        
    }
    
    private func configureData() {
        updateUI(for: currentIndex)
    
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        pageControl.numberOfPages = listSurveys.count
        pageControl.currentPage = currentIndex
    }
     
    // MARK: - Actions
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            showNextArticle()
        } else if sender.direction == .right {
            showPreviousArticle()
        }
    }
    
    func showNextArticle() {
        currentIndex = (currentIndex + 1) % listSurveys.count
        fadeTransition()
    }
    
    func showPreviousArticle() {
        currentIndex = (currentIndex - 1 + listSurveys.count) % listSurveys.count
        fadeTransition()
    }

    // MARK: - Utils
    
    func updateUI(for index: Int) {
        pageControl.currentPage = currentIndex
        let survey = listSurveys[index]
        titleSurvey.text = survey.attributes.title
        descriptionSurvey.text = survey.attributes.description
        backgroundImageView.kf.setImage(with: URL(string: survey.attributes.coverImageURL))
    }
    
    func fadeTransition() {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.updateUI(for: self.currentIndex)
        }, completion: nil)
    }
    
}
