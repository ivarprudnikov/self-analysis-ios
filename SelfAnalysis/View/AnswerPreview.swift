import SwiftUI

struct AnswerPreview: View {
    var key: String
    var answer: Answer?
    var body: some View {
        let field = AssessmentForm.questionSchema.properties[key]
        VStack(alignment: .leading, spacing: 5) {
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
            
            Text(answer?.value ?? "")
                .font(.body)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
    }
}

struct AnswerPreview_Previews: PreviewProvider {
    static var previews: some View {
        let answer: Answer = {
            let a = Answer(context: PersistenceController.preview.container.viewContext)
            a.value = "Foo bar baz"
            return a
        }()
        
        Group {
            AnswerPreview(key: "attained_goal", answer: answer)
        }
        .frame(width: 350, alignment: .leading)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
    }
}
