import Foundation

/// Supplies the vocabulary list. A protocol so views and view models never
/// reach for the bundle themselves, and so a test can hand over a fixed list.
protocol WordsLoader {
    func loadWords() throws -> [Word]
}

/// Reads the words from a JSON file inside the app bundle.
struct BundledWordsLoader: WordsLoader {
    enum LoadError: LocalizedError {
        case fileNotFound(String)
        case unreadable(String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound(let name):
                "Could not find \(name).json in the app bundle."
            case .unreadable(let name):
                "Could not read the words in \(name).json."
            }
        }
    }

    private let bundle: Bundle
    private let fileName: String

    init(bundle: Bundle = .main, fileName: String = "words") {
        self.bundle = bundle
        self.fileName = fileName
    }

    func loadWords() throws -> [Word] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw LoadError.fileNotFound(fileName)
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Word].self, from: data)
        } catch {
            throw LoadError.unreadable(fileName)
        }
    }
}
