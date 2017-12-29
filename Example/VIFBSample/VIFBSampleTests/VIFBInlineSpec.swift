//
//  VIFBInlineSpec.swift
//  VIFBInlineSpec
//
//  Created by Maksym Kravchenko on 12/15/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

import Nimble
import Quick

import VISDK
import VIFBSample


/*
 - (void)pause;
 - (void)resume;
 
 Can't be tested because of FB not working with Simulator
 */


class VIFBInlineSpec: QuickSpec {
    let accId = "2007707356109450_2017462025133983"

    var adapter: FacebookVIInlineAdapter!
    var viewController: UIViewController!
    
    var ad: VIVideoAd?

    var error: Error?
    var event: VIAdEvent?


    override func spec() {
        context("Mediation") {
            beforeEach {
                self.event = nil
                self.error = nil
                self.ad = self.makeAd()
            }

            describe("Init") {
                it("Should have initiated properties") {
                    expect(self.ad?.delegate).notTo(beNil())
                    expect(self.ad?.cacheMediaContent).to(beTrue())

                    expect(self.ad?.isReady).to(beFalse())
                    expect(self.ad?.isLoading).to(beFalse())
                    expect(self.ad?.isPaused).to(beFalse())
                    expect(self.ad?.isPlaying).to(beFalse())

                    expect(self.error).to(beNil())
                    expect(self.event).to(beNil())
                }
            }


            describe("Load") {
				afterEach {
					self.ad?.close()
				}

                describe("Load fail") {
                    it("Should receive error") {
                        self.ad = self.makeAd(faulty: true)
                        self.ad?.load()

                        expect(self.ad?.isLoading).to(beTrue())
                        expect(self.error).toEventuallyNot(beNil(), timeout: 10, pollInterval: 0.2)
						expect(self.ad?.isReady).toEventually(beFalse())

                        expect(self.event).to(beNil())
                    }
                }

                describe("Load success") {
                    it("Should be loaded") {
                        self.ad?.load()

                        expect(self.ad?.isLoading).to(beTrue())
                        expect(self.error).toEventually(beNil())
                        expect(self.event?.type).toEventually(equal(VIAdEventType.loaded), timeout: 10, pollInterval: 0.2)
                    }
                }
            }

            describe("Play") {
                it("Should play and close") {
                    self.ad?.load()
                    expect(self.ad?.isReady).toEventually(beTrue(), timeout: 10, pollInterval: 0.2)
                    if self.ad?.isReady ?? false {
                        let vc = UIViewController()
                        expect(vc.view.frame).notTo(equal(CGRect.zero)) //also triggers viewDidLoad()
                        vc.beginAppearanceTransition(true, animated: false)

                        self.ad?.start()
                        expect(self.ad?.isPlaying).toEventually(beTrue(), timeout: 10, pollInterval: 0.5)

                        self.ad?.close()
                        expect(self.event?.type).toEventually(equal(VIAdEventType.closed))
                    }
                }
            }
        }

        context("Just adapter") {
            beforeEach {
                self.adapter = FacebookVIInlineAdapter(placementID: self.accId)
            }

            describe("Init") {

                it("Should have initiated properties") {
                    expect(self.adapter.title()).to(equal("facebook"))
                    expect(self.adapter.status).to(equal(MediatorState.idle))
                }
            }

            describe("Load") {
                it("Should be loading") {
                    self.adapter.load()

                    expect(self.adapter.status).to(equal(MediatorState.loading))
                    expect(self.adapter.status).toEventually(equal(MediatorState.ready), timeout: 30, pollInterval: 0.2)
                }
            }
            
            describe("Close") {
                it("Should close") {
                    self.adapter.load()
                    
                    expect(self.adapter.status).to(equal(MediatorState.loading))
                    self.adapter.close()
                    expect(self.adapter.status).to(equal(MediatorState.idle))
                }
            }
        }
    }

    private func makeAd(faulty: Bool = false) -> VIVideoAd? {
        self.viewController = UIViewController()
        let _ = viewController.view
        
        let placement = VIPlacement("plt59gczn8crjr99us7", options: nil)
        let result = VISDK.sharedInstance().createVideoAd(for: placement, inContainer: self.viewController.view, useCahe: true)
        result?.delegate = self
        
        let adapter = FacebookVIInterstitialAdapter(placementID: faulty ? "" : self.accId)
        if let adapter = adapter
        {
            result?.registerMediation?(adapter)
        }
        return result
    }
}

extension VIFBInlineSpec: VIAdDelegate {
    func adDidReceiveError(_ error: Error) {
        self.error = error
    }
    
    func adDidReceive(_ event: VIAdEvent) {
        self.event = event
    }
}




