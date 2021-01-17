import SwiftUI

struct AsyncAddAssessmentButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var actionState: ActionState? = .initial
    @State var inProgress: Bool = false
    @State var newAssessmentId: UUID? = nil
    
    enum ActionState: Int {
        case initial = 0
        case ready = 1
    }
    
    // Async action that creates an assessment
    func onClick(_ completion: @escaping ((UUID?, String?)->())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newAssessment = Assessment(context: viewContext)
            newAssessment.createdAt = Date()
            newAssessment.id = UUID()
            do {
                try viewContext.save()
                completion(newAssessment.id, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        // Navigation will be triggered after $actionState switches to .ready
        NavigationLink(
            destination: AssessmentForm(assessmentId: newAssessmentId),
            tag: .ready,
            selection: $actionState) {

            Button(action: {
                if !self.inProgress {
                    self.onClick() { uuid, err in
                        if let id = uuid {
                            self.newAssessmentId = id
                            self.actionState = .ready
                        } else {
                            self.newAssessmentId = nil
                            self.actionState = .initial
                        }
                        self.inProgress = false
                    }
                }
                withAnimation(Animation.easeInOut(duration: 0.4)) {
                    self.inProgress = true
                }
            }, label: {
                VStack(alignment: .trailing) {
                    if self.inProgress {
                        ProgressView()
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            })
        }
    }
}

struct AsyncAddAssessmentButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AsyncAddAssessmentButton()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            AsyncAddAssessmentButton(inProgress: true)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        .frame(width: 200, height: 100)
        .previewLayout(.sizeThatFits)
    }
}
