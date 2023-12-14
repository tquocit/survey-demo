//
//  SurveyDetailsViewController.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import UIKit

protocol SurveyDetailsViewControllerDelegate: AnyObject {
    func onDimissSurveyDetails()
}

class SurveyDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: SurveyDetailsViewControllerDelegate?
    
    var arrayQuestionsSurvey = [QuestionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        SurveyManager.shared.fecthSurveyDetails(surveyID: "d5de6a8f8f5f1cfe51bc") { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.arrayQuestionsSurvey = response.questions
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Utils
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.isPagingEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func onCloseSurvey(_ sender: UIButton) {
        delegate?.onDimissSurveyDetails()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { _ in
            self.removeFromParent()
            self.view.removeFromSuperview()
            self.didMove(toParent: nil)
        }
    }

}

extension SurveyDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayQuestionsSurvey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyQuestionCollectionViewCell", for: indexPath) as? SurveyQuestionCollectionViewCell else {
            fatalError("Can not dequeue cell")
        }
        cell.indexLabel.text = "\(indexPath.row + 1)/\(self.arrayQuestionsSurvey.count)"
        cell.configureCellWithQuestion(self.arrayQuestionsSurvey[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
