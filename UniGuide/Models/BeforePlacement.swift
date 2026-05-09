//
//  AdmissionPlacementResult.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/4.
//

import Foundation
import SwiftCSV

struct BeforePlacement: Placement, Identifiable {
    
    var id: Int
    var schoolName: String
    var departmentName: String
    var weighting: String
    var generalScore: String
    var generalTieScore: String
    var indigenousScore: String
    var veteranScore: String
    var overseasStudentScore: String
    var mongolianScore: String
    var overseasChildScore: String
    var subjectCriteria: String
    var englishListening: String
    var tieSubjectOrder: String
    var approvedQuota: String
    var returnQuota: String
    var admissionQuota: String
    var admittedMale: String
    var admittedFemale: String
    var extraMale: String
    var extraFemale: String
    var totalAdmitted: String
    
    init(id: Int,
         schoolName: String,
         departmentName: String,
         weighting: String,
         generalScore: String,
         generalTieScore: String,
         indigenousScore: String,
         veteranScore: String,
         overseasStudentScore: String,
         mongolianScore: String,
         overseasChildScore: String,
         subjectCriteria: String,
         englishListening: String,
         tieSubjectOrder: String,
         approvedQuota: String,
         returnQuota: String,
         admissionQuota: String,
         admittedMale: String,
         admittedFemale: String,
         extraMale: String,
         extraFemale: String,
         totalAdmitted: String) {
        
        self.id = id;
        self.schoolName = schoolName
        self.departmentName = departmentName
        self.weighting = weighting
        self.generalScore = generalScore
        self.generalTieScore = generalTieScore
        self.indigenousScore = indigenousScore
        self.veteranScore = veteranScore
        self.overseasStudentScore = overseasStudentScore
        self.mongolianScore = mongolianScore
        self.overseasChildScore = overseasChildScore
        self.subjectCriteria = subjectCriteria
        self.englishListening = englishListening
        self.tieSubjectOrder = tieSubjectOrder
        self.approvedQuota = approvedQuota
        self.returnQuota = returnQuota
        self.admissionQuota = admissionQuota
        self.admittedMale = admittedMale
        self.admittedFemale = admittedFemale
        self.extraMale = extraMale
        self.extraFemale = extraFemale
        self.totalAdmitted = totalAdmitted
        
    }

}

