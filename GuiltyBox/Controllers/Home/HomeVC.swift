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
    
    var audioState: AGAudioRecorderState = .Ready
    var audioRecorder: AGAudioRecorder = AGAudioRecorder(withFileName: "guilty")

    @IBOutlet weak var recordingBorder: DesignableView!
    @IBOutlet weak var recordingButton: DesignableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioRecorder.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordingButton.backgroundColor = Color.primary.get()
    }
    
}

extension HomeVC: AGAudioRecorderDelegate {
    func agAudioRecorder(_ recorder: AGAudioRecorder, withStates state: AGAudioRecorderState) {
        switch state {
        case .Recording:
            view.backgroundColor = Color.primary.get()
        case .error(let e):
            debugPrint(e)
        default:
            debugPrint(state)
        }
    }
    
    func agAudioRecorder(_ recorder: AGAudioRecorder, currentTime timeInterval: TimeInterval, formattedString: String) {
        debugPrint(formattedString)
    }
}

