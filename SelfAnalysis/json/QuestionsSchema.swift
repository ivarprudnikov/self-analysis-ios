import Foundation

struct Question: Codable, Identifiable {
    var id: String { title }
    let title: String
    let description: String?
}

struct QuestionSchema: Codable {
    let type: String
    let properties: [String: Question]
}

func loadQuestionSchema() throws -> QuestionSchema {
    let decoder = JSONDecoder()
    let url = Bundle.main.url(forResource: "questions.schema", withExtension: "json")
    let data = try Data(contentsOf: url!)
    let schema = try decoder.decode(QuestionSchema.self, from: data)
    return schema
}
