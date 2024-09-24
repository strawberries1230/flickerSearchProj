//
//  FSItemDetailView.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import SwiftUI

struct FSItemDetailView: View {
    let item: ImageInfo
    var body: some View {
        VStack {
            if let imagePath = item.media?.imagePath, let url = URL(string: imagePath) {
                AsyncImage(url: url) {
                    phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure(_):
                        Image(systemName: "photo").resizable().scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                    
                }
                .padding()
            } else {
                Image(systemName: "photo").resizable().scaledToFit()
                    .padding()
            }
            VStack(alignment: .leading) {
                //title section
                Text(item.title ?? "No Title")
                    .font(.headline)
                    .foregroundColor(.black)
                //author section
                Text(extractedAuthor(from: item.author))
                    .font(.subheadline)
                    .foregroundColor(.black)
                //description section
                Text(extractPlainText(from: item.description))
                    .font(.body)
                    .foregroundColor(.gray)
                //publishedDate section
                Text(formatDate(from: item.publishedDate))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
    func formatDate(from dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    func extractedAuthor(from inputString: String?) -> String {
        guard let inputString = inputString else { return "" }
        if let startRange = inputString.range(of: "("),
           let endRange = inputString.range(of: ")", range: startRange.upperBound..<inputString.endIndex) {
            var extractedText = String(inputString[startRange.upperBound..<endRange.lowerBound])
            extractedText.removeFirst()
            extractedText.removeLast()
            return extractedText
        }
        return ""
    }
    
    
    func extractPlainText(from html: String?) -> String {
        
        guard let html = html else { return "" }
        guard let data = html.data(using: .utf8) else { return "" }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            var text = attributedString.string
            if let firstLineRange = text.range(of: ".*\n", options: .regularExpression) {
                text.removeSubrange(firstLineRange)
            }
            return text
        } else {
            return ""
        }
    }
}

//#Preview {
//    FSItemDetailView()
//}
