import SwiftUI

struct AnswerEditor: View {
    var key: String
    var answer: Answer?
    var assessment: Assessment
    
    @Environment(\.managedObjectContext) private var viewContext
    
    func createBindingToAnswer() -> Binding<String> {
        return Binding<String>( get: {
            return answer?.value ?? ""
        }, set: { newValue in
            let ans: Answer
            if let existing = answer {
                ans = existing
            } else {
                ans = Answer(context: viewContext)
                ans.question = key
                ans.assessment = assessment
            }
            ans.value = newValue
            assessment.updatedAt = Date()
            do {
                try viewContext.save()
            } catch {
                print("failed")
            }
        })
    }
    
    var body: some View {
        let field = AssessmentForm.questionSchema.properties[key]
        Form {
            Section {
                if let title = field?.title {
                    Text(title)
                        .foregroundColor(.secondary)
                        .font(.body)
                        .bold()
                        
                }
            
                if let description = field?.description {
                    Text(description)
                        .italic()
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            
                TextEditor(text: createBindingToAnswer())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct AnswerEditor_Previews: PreviewProvider {
    static var previews: some View {
        
        let answer: Answer = {
            let a = Answer(context: PersistenceController.preview.container.viewContext)
            a.value = "Foo bar baz"
            return a
        }()
        
        let assessment: Assessment = {
            let a = Assessment(context: PersistenceController.preview.container.viewContext)
            return a
        }()
        
        Group {
            AnswerEditor(key: "attained_goal", answer: answer, assessment: assessment)
        }
        .frame(width: 350, height: 350, alignment: .leading)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
    }
}
