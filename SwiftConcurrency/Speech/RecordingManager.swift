//
//  RecordingManager.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-18.
//

import AVFoundation

//class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
//    var audioRecorder: AVAudioRecorder?
//    
//    func requestPermissionAndRecord() async {
//        
//        if await AVAudioApplication.requestRecordPermission() {
//            self.startRecording()
//        } else {
//            print("Доступ до мікрофона заборонено")
//        }
//    }
//
//    func startRecording() {
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setCategory(.playAndRecord, mode: .default)
//            try session.setActive(true)
//
//            let url = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
//            let settings = [
//                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                AVSampleRateKey: 12000,
//                AVNumberOfChannelsKey: 1,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]
//
//            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
//            audioRecorder?.delegate = self
//            audioRecorder?.record()
//            print("🎙 Запис розпочато")
//        } catch {
//            print("Помилка при записі: \(error)")
//        }
//    }
//
//    func stopRecording() {
//        audioRecorder?.stop()
//        print("⏹ Запис зупинено")
//    }
//}

import Speech
import SwiftUI

class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "uk-UA"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var recognizedText = ""
    
    @Published var showSettingsAlert = false

       func checkSpeechPermission(completion: @escaping (Bool) -> Void) {
           SFSpeechRecognizer.requestAuthorization { status in
               DispatchQueue.main.async {
                   switch status {
                   case .authorized:
                       completion(true)
                   case .denied, .restricted, .notDetermined:
                       self.showSettingsAlert = true
                       completion(false)
                   @unknown default:
                       self.showSettingsAlert = true
                       completion(false)
                   }
               }
           }
       }

       func openSettings() {
           if let url = URL(string: UIApplication.openSettingsURLString) {
               UIApplication.shared.open(url)
           }
       }

    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("✅ Speech доступ дозволено")
                default:
                    print("❌ Немає доступу до розпізнавання мови")
                }
            }
        }
    }
    
    func startTranscribing() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                guard authStatus == .authorized else {
                    print("Speech не дозволено")
                    return
                }

                self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                guard let recognitionRequest = self.recognitionRequest else { return }

                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                } catch {
                    print("AVAudioSession error: \(error)")
                    return
                }

                let inputNode = self.audioEngine.inputNode
                let recordingFormat = inputNode.outputFormat(forBus: 0)

                inputNode.removeTap(onBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
                    self.recognitionRequest?.append(buffer)
                }

                self.recognitionTask = self.speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                    if let result = result {
                        self.recognizedText = result.bestTranscription.formattedString
                    }
                    if error != nil || (result?.isFinal ?? false) {
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        self.recognitionRequest = nil
                        self.recognitionTask = nil
                    }
                }

                do {
                    try self.audioEngine.start()
                    print("🎤 Розпізнавання розпочато")
                } catch {
                    print("Не вдалося стартувати аудіо-двигун: \(error.localizedDescription)")
                }
            }
        }
    }

    func stopTranscribing() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        print("⏹ Розпізнавання зупинено")
    }
}
