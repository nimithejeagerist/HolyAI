//
//  OpenAIService.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-10-19.
//

import Foundation
import OpenAI

final class OpenAIService {
    private let openAI: OpenAI
    private let nimi = "I am amazing ikr"
    
    init() {
        // Use environment variable for API key
        guard let apiToken = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("OpenAI API Key not found in environment variables")
        }
        openAI = OpenAI(apiToken: apiToken)
    }
    
    // This function gets a reply from the OpenAI API
    func getBotReply(messages: [Message], systemMessageContent: String, completion: @escaping (String?) -> Void) {
        guard let systemMessage = ChatQuery.ChatCompletionMessageParam(role: .system, content: systemMessageContent) else {
            completion(nil)
            return
        }
        
        let userMessages = messages.compactMap { ChatQuery.ChatCompletionMessageParam(role: .user, content: $0.content) }
        
        
        // Create the query for the OpenAI API by combining system message with user messages.
        let query = ChatQuery(
            messages: [systemMessage] + userMessages,
            model: .gpt3_5Turbo
        )
        
        // Perform the API call to get the bot's reply.
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first, let message = choice.message.content?.string else {
                    completion(nil)
                    return
                }
                completion(message)
            case .failure(let error):
                // Handle API error.
                print("OpenAI Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
