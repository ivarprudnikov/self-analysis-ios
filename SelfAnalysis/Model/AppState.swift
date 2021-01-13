import Foundation

class AppState: ObservableObject {
    var assessments = [Assessment]()
}

extension AppState {
    func addAssessment(_ assessment: Assessment) -> AppState {
        if !assessments.contains(where: { $0.id == assessment.id }) {
            assessments.append(assessment)
        }
        return self
    }
    
    func removeAssessment(_ assessment: Assessment) -> AppState {
        if let idx = assessments.firstIndex(where: { $0.id == assessment.id }) {
            assessments.remove(at: idx)
        }
        return self
    }
}
