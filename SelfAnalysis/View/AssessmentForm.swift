//
//  AssessmentForm.swift
//  SelfAnalysis
//
//  Created by Aivaras Prudnikovas on 17/01/2021.
//

import SwiftUI

struct AssessmentForm: View {
    var assessmentId: UUID?
    var body: some View {
        if let id = assessmentId {
            Text("Assessment form for " + id.uuidString)
        } else {
            Text("Assessment not found 😭")
        }
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessmentId: UUID())
    }
}