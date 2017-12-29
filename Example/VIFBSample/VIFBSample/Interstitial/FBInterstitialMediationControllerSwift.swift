//
//  FBInterstitialMediationControllerSwift.swift
//  VIFBSample
//
//  Created by Vitalii Cherepakha on 10/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

import UIKit
import VISDK

class FBInterstitialMediationControllerSwift: UIViewController {

    fileprivate lazy var ad:VIInterstitialAd? = {
        let placement = VIPlacement("pltsn8iz6zueb3wl7hm", options: nil)
        let result = VISDK.sharedInstance().createInterstitialAd(for: placement)
        result?.delegate = self
        
        let adapter = FacebookVIInterstitialAdapter(placementID: "2007707356109450_2008142456065940")
        if let adapter = adapter
        {
            result?.registerMediation?(adapter)
        }
        return result
    }()
    
    @IBOutlet var statusLabel:UILabel?
    @IBOutlet var playButton:UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.playButton?.isEnabled = false
        self.statusLabel?.text = "Idling"
    }
    
    
    @IBAction func playButtonTouched(_ sender:UIButton)
    {
        ad?.show(from: self)
    }
    
    @IBAction func loadButtonTouched(_ sender:UIButton)
    {
        ad?.load()
        statusLabel?.text = "Loading..."
    }

}

extension FBInterstitialMediationControllerSwift : VIAdDelegate
{
    
    func adDidReceiveError(_ error: Error)
    {
        let controller = UIAlertController(title: "Error",
                                           message: error.localizedDescription,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close",
                                           style: .cancel,
                                           handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func adDidReceive(_ event: VIAdEvent)
    {
        switch event.type {
        case .loaded:
            self.playButton?.isEnabled = true
            self.statusLabel?.text = "Loaded"
            print("Ad loaded")
        case .started:
            print("Ad started")
        case .closed:
            print("Ad closed")
            playButton?.isEnabled = false;
            statusLabel?.text = "Idling";
        case .clicked:
            print("Ad clicked")
        case .paused:
            print("Ad paused")
        case .resumed:
            print("Ad resumed")
        case .expired:
            print("Ad expired")
        case .completed:
            print("Ad completed")
            playButton?.isEnabled = false;
            statusLabel?.text = "Idling";
            ad = nil;
        }
    }
}
