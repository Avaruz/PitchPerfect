//
//  RecordSoundsViewController
//  Pitch Perfect
//
//  Created by Adhemar Soria Galvarro on 2/10/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    var isInRecord : Bool!
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setInitialState()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordInProgress.text="record in progress..."
        recordButton.enabled=false
        stopButton.hidden=false
        pauseResumeButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate=self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            recordedAudio=RecordedAudio(filePathUrl:recorder.url,title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else
        {
            print("An Errorr ocurred when we are Recording")
            setInitialState()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="stopRecording"){
            let playVCReceive:PlaySoundViewController=segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            
            playVCReceive.recordReceive=data
            
        }
    }
    @IBAction func stopAdudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        setInitialState()
        
    }
    
    @IBAction func pauseResumeRecord(sender: UIButton) {
        // Check if the recorder is currently recording
        if (audioRecorder.recording) {
            audioRecorder.pause()
            recordInProgress.text="record in pause"
            // Change the image of the button to resume
            pauseResumeButton.setImage(UIImage(named: "resume"), forState: UIControlState.Normal)
        } else {
            audioRecorder.record()
            recordInProgress.text="record in progress..."
            // Set back the pause image for the button
            pauseResumeButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        }
    }
    
    func setInitialState()
    {
        recordInProgress.text = "Tap for Record"
        recordButton.enabled = true
        pauseResumeButton.hidden = true
        stopButton.hidden = true
        isInRecord = false
    }

}

