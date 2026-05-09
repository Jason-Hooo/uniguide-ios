//
//  LatestPlacement.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/24.
//

import Foundation
import SwiftCSV

struct LatestPlacement: Placement, Identifiable {
    
    var id: Int
    var schoolName: String
    var departmentName: String
    var subjectCriteriaChinese: String
    var subjectCriteriaEnglish: String
    var subjectCriteriaMathA: String
    var subjectCriteriaMathB: String
    var subjectCriteriaSocial: String
    var subjectCriteriaScience: String
    var subjectCriteriaEnglishListening: String
    var weightingMathGay: String // 數甲
    var weightingMathChair: String // 數乙
    var weightingPhysics: String
    var weightingChemistry: String
    var weightingBiology: String
    var weightingHistory: String
    var weightingGeography: String
    var weightingCivics: String
    var weightingChinese: String
    var weightingEnglish: String
    var weightingMathA: String
    var weightingMathB: String
    var weightingSocial: String
    var weightingScience: String
    var weightingPractical: String
    var practicalKind: String
    var tieSubject1: String
    var tieSubject2: String
    var tieSubject3: String
    var tieSubject4: String
    var tieSubject5: String
    var illustration: String
    var isFavorite: Bool
    
    init(id: Int,
         schoolName: String,
         departmentName: String,
         subjectCriteriaChinese: String,
         subjectCriteriaEnglish: String,
         subjectCriteriaMathA: String,
         subjectCriteriaMathB: String,
         subjectCriteriaSocial: String,
         subjectCriteriaScience: String,
         subjectCriteriaEnglishListening: String,
         weightingMathGay: String,
         weightingMathChair: String,
         weightingPhysics: String,
         weightingChemistry: String,
         weightingBiology: String,
         weightingHistory: String,
         weightingGeography: String,
         weightingCivics: String,
         weightingChinese: String,
         weightingEnglish: String,
         weightingMathA: String,
         weightingMathB: String,
         weightingSocial: String,
         weightingScience: String,
         weightingPractical: String,
         practicalKind: String,
         tieSubject1: String,
         tieSubject2: String,
         tieSubject3: String,
         tieSubject4: String,
         tieSubject5: String,
         illustration: String
    ) {
        self.id = id
        self.schoolName = schoolName
        self.departmentName = departmentName
        self.subjectCriteriaChinese = subjectCriteriaChinese
        self.subjectCriteriaEnglish = subjectCriteriaEnglish
        self.subjectCriteriaMathA = subjectCriteriaMathA
        self.subjectCriteriaMathB = subjectCriteriaMathB
        self.subjectCriteriaSocial = subjectCriteriaSocial
        self.subjectCriteriaScience = subjectCriteriaScience
        self.subjectCriteriaEnglishListening = subjectCriteriaEnglishListening
        self.weightingMathGay = weightingMathGay
        self.weightingMathChair = weightingMathChair
        self.weightingPhysics = weightingPhysics
        self.weightingChemistry = weightingChemistry
        self.weightingBiology = weightingBiology
        self.weightingHistory = weightingHistory
        self.weightingGeography = weightingGeography
        self.weightingCivics = weightingCivics
        self.weightingChinese = weightingChinese
        self.weightingEnglish = weightingEnglish
        self.weightingMathA = weightingMathA
        self.weightingMathB = weightingMathB
        self.weightingSocial = weightingSocial
        self.weightingScience = weightingScience
        self.weightingPractical = weightingPractical
        self.practicalKind = practicalKind
        self.tieSubject1 = tieSubject1
        self.tieSubject2 = tieSubject2
        self.tieSubject3 = tieSubject3
        self.tieSubject4 = tieSubject4
        self.tieSubject5 = tieSubject5
        self.illustration = illustration
        self.isFavorite = false
    }

}

