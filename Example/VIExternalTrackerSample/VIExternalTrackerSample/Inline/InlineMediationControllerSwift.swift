//
//  InlineMediationControllerSwift.swift
//  VIExternalTrackerSample
//
//  Created by Vitalii Cherepakha on 10/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

import UIKit
import VISDK

class InlineMediationControllerSwift: UIViewController {

    fileprivate lazy var ad:VIVideoAd? = {
		// FIXME: use your placementId.
        let placement = VIPlacement("plttwmion1hu5al7mmu", options: nil)
        let result = VISDK.sharedInstance().createVideoAd(for: placement, inContainer: self.containerView ?? self.view, useCahe: true)
        result?.delegate = self
        return result
    }()
    
    @IBOutlet var containerView:UIView?
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
        ad?.start()
        ad?.startsWhenReady = true
    }
    
    @IBAction func loadButtonTouched(_ sender:UIButton)
    {
        ad?.load()
        statusLabel?.text = "Loading..."
    }

}

extension InlineMediationControllerSwift : VIAdDelegate
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
