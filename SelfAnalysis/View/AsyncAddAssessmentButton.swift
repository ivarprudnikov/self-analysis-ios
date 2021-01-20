import SwiftUI

struct AsyncAddAssessmentButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var actionState: ActionState? = .initial
    @State var inProgress: Bool = false
    @State var newAssessment: Assessment? = nil
    
    enum ActionState: Int {
        case initial = 0
        case ready = 1
    }
    
    // Async action that creates an assessment
    func onClick(_ completion: @escaping ((Assessment?, String?)->())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let a = Assessment(context: viewContext)
            a.createdAt = Date()
            a.id = UUID()
            do {
                try viewContext.save()
                completion(a, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        // Navigation will be triggered after $actionState switches to .ready
        NavigationLink(
            destination: AssessmentForm(assessment: newAssessment),
            tag: .ready,
            selection: $actionState) {

            Button(action: {
                if !self.inProgress {
                    self.onClick() { newAssessment, err in
                        if let a = newAssessment {
                            self.newAssessment = a
                            self.actionState = .ready
                        } else {
                            self.newAssessment = nil
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
