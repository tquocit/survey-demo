//
//  SurveyDetails.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 13/12/2023.
//

import Foundation

// MARK: - Raw Data Struct

struct SurveyDetailsResponse: Codable {
    let data: SurveyDetailsData
    let included: [ItemData]?
}

struct SurveyDetailsData: Codable {
    let id: String
    let type: String
    let attributes: SurveyAttributes
    let relationships: QuestionRelationships
}

struct SurveyAttributes: Codable {
    let title: String
    let description: String
//    let thankEmailAboveThreshold: String
//    let thankEmailBelowThreshold: String
    let isActive: Bool
//    let coverImageUrl: String
//    let createdAt: String
//    let activeAt: String
//    let inactiveAt: String?
//    let surveyType: String
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case isActive = "is_active"
        
    }
}

struct QuestionRelationships: Codable {
    let questions: QuestionData
}

struct QuestionData: Codable {
    let data: [ItemData]
}

struct ItemData: Codable {
    let id: String
    let type: String
    let attributes: ItemAttributes?
    let relationships: AnswerRelationships?
}

struct ItemAttributes: Codable {
    let text: String?
    let helpText: String?
    let displayOrder: Int
    let shortText: String?
    let pick: String?
    let displayType: String
    let isMandatory: Bool
//    let correctAnswerId: String?
//    let imageUrl: String?
//    let coverImageUrl: String?
//    let coverImageOpacity: Double
//    let coverBackgroundColor: String?
//    let isShareableOnFacebook: Bool
//    let isShareableOnTwitter: Bool
//    let fontFace: String?
//    let fontSize: String?
//    let tagList: String?
    
    enum CodingKeys: String, CodingKey {
        case text, pick
        case helpText = "help_text"
        case displayOrder = "display_order"
        case shortText = "short_text"
        case displayType = "display_type"
        case isMandatory = "is_mandatory"
    }
}

struct AnswerRelationships: Codable {
    let answers: AnswerData
}

struct AnswerData: Codable {
    let data: [ItemData]
}


// MARK: - Parse Model

struct SurveyDetailsModel: Codable {
    let id: String
    let type: String
    let questions: [QuestionModel]
}

struct QuestionModel: Codable {
    let id: String
    let type: String
    let attributes: ItemAttributes?
    let answers: [ItemData]
}
