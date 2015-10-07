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
        playAudio(1.5, pitch:0.0, echo: 0.0, reverb: 0.0)
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudio(0.5, pitch:0.0, echo: 0.0, reverb: 0.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(1.0, pitch:1000, echo: 0.0, reverb: 0.0)
        
    }
    
    @IBAction func playEchoEffect(sender: UIButton) {
        playAudio(1.0, pitch:0.0, echo: 0.2,reverb: 0.0)
    }
    
    @IBAction func playReverbEffect(sender: UIButton) {
        playAudio(1.0, pitch:0.0, echo: 0.1,reverb: 50.0)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudio(1.0, pitch:-1000, echo: 0.0, reverb: 0.0)
    }
    
    func playAudio(rate: Float, pitch:Float, echo:Float, reverb:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //Declare & Initialize the differents units
        let audioPlayerNode = AVAudioPlayerNode()
        let reverbEffect = AVAudioUnitReverb()
        let varyEffect = AVAudioUnitVarispeed()
        let delayEffect = AVAudioUnitDelay()
        let pitchEffect = AVAudioUnitTimePitch()
        
        //Adjust parameters
        varyEffect.rate = rate
        reverbEffect.wetDryMix = reverb
        pitchEffect.pitch = pitch
        delayEffect.delayTime = NSTimeInterval( echo )
     
        //Attach all units to the AudioEngine
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(varyEffect)
        audioEngine.attachNode(reverbEffect)
        audioEngine.attachNode(pitchEffect)
        audioEngine.attachNode(delayEffect)
        
        //Connect all the Nodes
        audioEngine.connect(audioPlayerNode, to: delayEffect, format: nil)
        audioEngine.connect(delayEffect, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: varyEffect, format: nil)
        audioEngine.connect(varyEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    
}
