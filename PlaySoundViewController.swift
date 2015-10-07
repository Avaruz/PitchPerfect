//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Adhemar Soria Galvarro on 3/10/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundViewController: UIViewController {

    @IBOutlet weak var slowButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var recordReceive : RecordedAudio!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOfURL:recordReceive.filePathUrl,fileTypeHint:nil)
            audioPlayer.enableRate=true
            audioEngine = AVAudioEngine()
            try audioFile = AVAudioFile(forReading: recordReceive.filePathUrl)
            
            
        }catch {
            print("Error founds")
        }
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var stopButton: UIButton!
    

    @IBAction func soundStop(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
    @IBAction func playFast(sender: UIButton) {
        playSound(1.5)
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playSound(0.5)
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playEchoEffect(sender: UIButton) {
        playAudioWithEcho()
    }
    @IBAction func playReverbEffect(sender: UIButton) {
        playAudioWithReverb()
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch=pitch
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        let reverbEffect = AVAudioUnitReverb()
        let delayEffect = AVAudioUnitDelay()
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(reverbEffect)
        audioEngine.attachNode(delayEffect)
        
        audioEngine.connect(audioPlayerNode, to: delayEffect, format: nil)
        audioEngine.connect(delayEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithEcho(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        let delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = NSTimeInterval( 0.2 )
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(delayEffect)
        
        audioEngine.connect(audioPlayerNode, to: delayEffect, format: nil)
        audioEngine.connect(delayEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playSound(rate:Float){
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.rate=rate
        audioPlayer.currentTime=0.0
        audioPlayer.play()
        
    }
    
    
}
