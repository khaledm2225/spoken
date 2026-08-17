import AVFoundation

/// Says a word out loud. A protocol so the home screen can be built without the
/// speech engine, and so nothing reaches for a shared instance.
protocol WordSpeaker {
    func speak(_ text: String)
}

/// Reads words with the system voice.
///
/// Deliberately the smallest thing that works: one utterance, the default voice,
/// no rate or pitch tuning and no audio session handling. The synthesiser is
/// held for the life of the object because speech stops if it is released while
/// still talking.
final class SystemWordSpeaker: WordSpeaker {
    private let synthesiser = AVSpeechSynthesizer()

    func speak(_ text: String) {
        // Cut off anything still being said so two taps do not queue up.
        synthesiser.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesiser.speak(utterance)
    }
}
