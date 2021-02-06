import SwiftUI
import CoreData

struct AssessmentForm: View {
    var assessment: Assessment
    var fetchRequest: FetchRequest<Answer>
    var dbAnswers: FetchedResults<Answer> { fetchRequest.wrappedValue }
    
    init(assessment: Assessment) {
        self.assessment = assessment
        self.fetchRequest = FetchRequest<Answer>(entity: Answer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "assessment.id == %@", assessment.id! as CVarArg))
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentingDetailsSheet = false
    @State private var selectedAnswerKey: String? = nil
    
    static let questionSchema: QuestionSchema = {
        return try! loadQuestionSchema()
    }()
    
    func isPresentingAnswerEditorSheet() -> Binding<Bool> {
        return Binding<Bool>( get: {
            return selectedAnswerKey != nil
        }, set: { newValue in selectedAnswerKey = nil })
    }
    
    func answerForKey(forKey key: String) -> Answer? {
        return dbAnswers.first(where: { $0.question == key })
    }
    
    var showDetailsBtn: some View {
        Button(action: {
            presentingDetailsSheet = true
        }, label: {
            Image(systemName: "info.circle")
                .imageScale(.large)
        })
    }
    
    var bottomToolbarProgress: some View {
        HStack(alignment: .center, spacing: 40) {
            ProgressHorizontal(value: Double(dbAnswers.count), maxValue: Double(AssessmentForm.questionSchema.properties.count))
                .frame(width: 100, height: 3, alignment: .center)
        }.frame(maxWidth: .infinity)
    }
    
    var body: some View {
        Form {
            ForEach(AssessmentForm.questionSchema.properties.sorted(by: { $0.key < $1.key }), id: \.key) { key, field in
                AnswerPreview(key: key, answer: answerForKey(forKey: key))
                    .onTapGesture {
                        selectedAnswerKey = key
                    }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                showDetailsBtn
            }
            ToolbarItem(placement: .bottomBar) {
                bottomToolbarProgress
            }
        })
        .sheet(isPresented: $presentingDetailsSheet) {
            VStack(spacing: 0) {
                AssessmentDetailsView()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { presentingDetailsSheet = false }) {
                        Text("Done")
                    }
                }
            }
            .environmentObject(assessment)
        }
        .sheet(isPresented: isPresentingAnswerEditorSheet()) {
            if let key = selectedAnswerKey {
                AnswerEditor(key: key, answer: answerForKey(forKey: key), assessment: assessment)
            }
        }
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessment: PersistenceController.preview.createAssessment())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
