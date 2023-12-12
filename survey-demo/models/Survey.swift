//
//  Survey.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation

struct SurveyList: Codable {
    let data: [Survey]
    let meta: SurveyListMeta
    
    struct SurveyListMeta: Codable {
        let page: Int
        let pages: Int
        let pageSize: Int
        let records: Int
        
        enum CodingKeys: String, CodingKey {
            case page, pages, records
            case pageSize = "page_size"
        }
    }
}

struct Survey: Codable {
    let id: String
    let type: String
    let attributes: SurveyAttributes
    struct SurveyAttributes: Codable {
        let title: String
        let description: String
        let coverImageURL: String
        let surveyType: String
        
        enum CodingKeys: String, CodingKey {
            case title, description
            case coverImageURL = "cover_image_url"
            case surveyType = "survey_type"
        }
    }
}
