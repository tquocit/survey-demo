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
    
    @IBOutlet weak var startSurveyView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleSurvey: UILabel!
    @IBOutlet weak var descriptionSurvey: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var descriptionDetail: UILabel!
    @IBOutlet weak var startSurveyButton: UIButton!
    
    private var swipeLeftGesture: UISwipeGestureRecognizer!
    private var swipeRightGesture: UISwipeGestureRecognizer!
    
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarLabel.text = Date().formattedString()
        self.viewModel.delegate = self
        configureUI()
        setupSwipeGestures()
        viewModel.fetchSurveys()
    }
    
    // MARK: - Utils
    
    private func configureUI() {
        self.nextButton.layer.cornerRadius = self.nextButton.frame.width/2
        self.nextButton.layer.masksToBounds = true
        self.startSurveyButton.layer.cornerRadius = 12.0
        self.startSurveyButton.layer.masksToBounds = true
    }
    
    private func setupSwipeGestures() {
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    private func addOrRemoveSwipeGesture(isAdd: Bool) {
        if isAdd {
            view.addGestureRecognizer(swipeLeftGesture)
            view.addGestureRecognizer(swipeRightGesture)
        } else {
            view.removeGestureRecognizer(swipeLeftGesture)
            view.removeGestureRecognizer(swipeRightGesture)
        }
    }
     
    // MARK: - Actions
    @IBAction func onProfileButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        
        let initialFrame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
        menuVC.view.frame = initialFrame
        
        UIView.animate(withDuration: 0.3) {
            menuVC.view.frame = CGRect(x: 0, y: 0, 
                                       width: self.view.frame.width,
                                       height: self.view.frame.height)
        }
        
    }
    
    @IBAction func onNextButton(_ sender: UIButton) {
        showStartSurveyView(isShow: true)
        addOrRemoveSwipeGesture(isAdd: false)
    }
    
    @IBAction func onBackButton(_ sender: UIButton) {
        showStartSurveyView(isShow: false)
        addOrRemoveSwipeGesture(isAdd: true)
    }
    
    private func showStartSurveyView(isShow: Bool) {
        let survey = self.viewModel.listSurveys[self.viewModel.currentIndex]
        self.titleDetail.text = survey.attributes.title
        self.descriptionDetail.text = survey.attributes.description
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundImageView.transform = CGAffineTransform(scaleX: isShow ? 1.3 : 1.0, y: isShow ? 1.3 : 1.0)
            self.descriptionView.alpha = isShow ? 0.0 : 1.0
            self.startSurveyView.alpha = isShow ? 1.0 : 0.0
        })
    }
    
    @IBAction func onStartSurvey(_ sender: UIButton) {
        let finalXPosition = -self.view.bounds.width
        UIView.animate(withDuration: 0.3) {
            self.startSurveyView.transform = CGAffineTransform(translationX: finalXPosition, y: 0)
            self.startSurveyView.alpha = 0
            self.startSurveyDetails()
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            viewModel.showNextArticle()
        } else if sender.direction == .right {
            viewModel.showPreviousArticle()
        }
    }
    
    private func startSurveyDetails() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let surveyDetailsVC = storyboard.instantiateViewController(withIdentifier: "SurveyDetailsViewController") as! SurveyDetailsViewController
        
        let surveyDetailsViewModel = SurveyDetailsViewModel(surveyID: self.viewModel.listSurveys[self.viewModel.currentIndex].id)
        
        surveyDetailsVC.setViewModel(surveyDetailsViewModel)
        surveyDetailsVC.delegate = self
        surveyDetailsVC.view.alpha = 0

        addChild(surveyDetailsVC)
        surveyDetailsVC.view.frame = view.bounds
        view.addSubview(surveyDetailsVC.view)

        UIView.animate(withDuration: 0.3) {
            surveyDetailsVC.view.alpha = 1
        }

        surveyDetailsVC.didMove(toParent: self)
    }
}

// MARK: - HomeViewModelDelegate

extension HomeViewController: HomeViewModelDelegate {
    func updateUIWithData(for index: Int) {
        UIView.transition(with: view, duration: 0.7, options: .transitionCrossDissolve, animations: {
            let survey = self.viewModel.listSurveys[index]
            self.titleSurvey.text = survey.attributes.title
            self.descriptionSurvey.text = survey.attributes.description
            self.backgroundImageView.kf.setImage(with: URL(string: survey.attributes.coverImageURL))
            
            
            self.pageControl.numberOfPages = self.viewModel.listSurveys.count
            self.pageControl.currentPage = self.viewModel.currentIndex
        }, completion: nil)
    }
}

extension HomeViewController: SurveyDetailsViewControllerDelegate {
    func onDimissSurveyDetails() {
        UIView.animate(withDuration: 0.3) {
            self.startSurveyView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.showStartSurveyView(isShow: false)
            self.addOrRemoveSwipeGesture(isAdd: true)
            
            
        }
    }
}

extension HomeViewController: MenuViewControllerDelegate {
    func logoutSuccessfully() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIApplication.shared.windows.first?.rootViewController = loginViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
