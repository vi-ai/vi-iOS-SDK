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
        let placement = VIPlacement("pltshsukfa1bsrdo9hz", options: nil)
        let result = VISDK.sharedInstance().createVideoAd(for: placement, inContainer: self.containerView ?? self.view, useCahe: true)
        result?.delegate = self
        return result
    }()
    
    @IBOutlet var containerView:UIView?
    @IBOutlet var statusLabel:UILabel?
    @IBOutlet var playButton:UIButton?
	@IBOutlet var closeButton:UIButton?

    override func viewDidLoad()
    {
        super.viewDidLoad()

		resetView()
	}
    
    
    @IBAction func playButtonTouched(_ sender:UIButton)
    {
		guard let ad = self.ad else { return }
		
		if ad.isPlaying {
			ad.pause()
		} else if ad.isPaused {
			ad.resume()
		} else {
			ad.start()
			ad.startsWhenReady = true
		}
    }
    
    @IBAction func loadButtonTouched(_ sender:UIButton)
    {
        ad?.load()
        statusLabel?.text = "Loading..."
    }

	@IBAction func closeButtonTouched(_ sender:UIButton)
	{
		ad?.close()
	}

	fileprivate func resetView() {
		playButton?.isEnabled = false
		statusLabel?.text = "Idling"
		closeButton?.isEnabled = false
		playButton?.setTitle("Play", for: .normal)
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
			playButton?.isEnabled = true
			statusLabel?.text = "Loaded"
			closeButton?.isEnabled = true
			playButton?.setTitle("Play", for: .normal)
			print("Ad loaded")
		case .started:
			playButton?.setTitle("Pause", for: .normal)
			print("Ad started")
		case .closed:
			resetView()
			print("Ad closed")
		case .clicked:
			print("Ad clicked")
		case .paused:
			statusLabel?.text = "Paused";
			playButton?.setTitle("Resume", for: .normal)
			print("Ad paused")
		case .resumed:
			statusLabel?.text = "Resumed";
			playButton?.setTitle("Pause", for: .normal)
			print("Ad resumed")
		case .expired:
			print("Ad expired")
		case .completed:
			print("Ad completed")
			resetView()
			ad = nil;
		}
	}
}
