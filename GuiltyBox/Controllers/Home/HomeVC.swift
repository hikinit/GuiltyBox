//
//  HomeVC.swift
//  GuiltyBox
//
//  Created by rshier on 18/05/19.
//  Copyright © 2019 rshier. All rights reserved.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {
    
    var audioRecorder: AGAudioRecorder = AGAudioRecorder(withFileName: "guilty")
    var audioInterval: TimeInterval = 0.0 {
        didSet {
            setRecordingTimeLabel(oldValue)
        }
    }

    @IBOutlet weak var recordingBorder: DesignableView!
    @IBOutlet weak var recordingButton: DesignableButton!
    @IBOutlet weak var recordingTimeLabel: UILabel!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioRecorder.delegate = self
        recordingButton.addTarget(self, action: #selector(recordingTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordingButton.backgroundColor = Color.primary.get()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func recordingTapped(){
        switch audioRecorder.getState() {
        case .Ready:
            audioRecorder.doRecord()
        case .Recording:
            audioRecorder.doStopRecording()
        default:
            return
        }
    }
    
}

extension HomeVC {
    func animate(duration: Double, _ function: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            function()
        })
    }
    
    func playing() {
        self.recordingStatusLabel.text = "Reflecting"
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {timer in
            self.audioInterval -= timer.timeInterval
//            print("Playing \(count)")
            
            if self.audioInterval <= 0 {
                timer.invalidate()
                self.audioRecorder.setState(.Ready)
            }
        })
    }
    
    func setRecordingTimeLabel(_ timeInterval: TimeInterval){
        let audioIntervalLabel = String(Int(timeInterval))
        recordingTimeLabel.text = audioIntervalLabel
    }
}

extension HomeVC: AGAudioRecorderDelegate {
    func agAudioRecorder(_ recorder: AGAudioRecorder, withStates state: AGAudioRecorderState) {
        switch state {
        case .Recording:
            print("Now recording")
            
            animate(duration: 0.2, {
                self.view.backgroundColor = Color.primary.get()
                self.recordingButton.backgroundColor = .white
                self.recordingButton.cornerRadius = 16
                self.recordingButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                self.recordingTimeLabel.isHidden = false
            })
            
            self.recordingStatusLabel.text = "Listening"
            
        case .Finish:
            print("Finished")
            animate(duration: 0.2, {
                self.view.backgroundColor = Color.secondary.get()
                self.recordingButton.backgroundColor = Color.primary.get()
                self.recordingButton.cornerRadius = self.recordingButton.bounds.width / 2
                self.recordingButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            audioRecorder.playEngine(pitch: -500)
        case .Play:
            print("Playing")
            playing()
        case .Ready:
            print("Ready to record!!")
            self.recordingStatusLabel.text = "Confess"
            recordingTimeLabel.isHidden = true
        case .error(let e):
            debugPrint(e)
        default:
            debugPrint(state)
        }
    }
    
    func agAudioRecorder(_ recorder: AGAudioRecorder, currentTime timeInterval: TimeInterval, formattedString: String) {
        audioInterval = timeInterval
    }
}

