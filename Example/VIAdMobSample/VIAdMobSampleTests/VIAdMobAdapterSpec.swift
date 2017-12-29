//
//  VIAdMobAdapterSpec.swift
//  VIAdMobAdapterSpec
//
//  Created by Maksym Kravchenko on 12/15/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

import XCTest
import Nimble
import Quick

import VISDK
import VIAdMobSample

class VIAdMobAdapterSpec: QuickSpec {
    let accId = "ca-app-pub-4499248058256064/8430446295"
    
    var adapter: AdMobVIInterstitialAdapter!
    
    var ad: VIInterstitialAd?
    
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

                describe("Load fail") {
                    it("Should receive error") {
                        self.ad = self.makeAd(faulty: true)
                        self.ad?.load()

                        expect(self.ad?.isLoading).to(beTrue())
                        expect(self.error).toEventuallyNot(beNil(), timeout: 10, pollInterval: 0.2)
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
                        
                        self.ad?.show(from: vc)
                        expect(self.ad?.isPlaying).toEventually(beTrue(), timeout: 10, pollInterval: 0.5)
                       
                        self.ad?.close()
                        expect(self.event?.type).toEventually(equal(VIAdEventType.closed))
                    }
                }
            }
        }
        
        context("Just adapter") {
            beforeEach {
                self.adapter = AdMobVIInterstitialAdapter(placementID: self.accId)
            }

            describe("Init") {

                it("Should have initiated properties") {
                    expect(self.adapter.title()).to(equal("google_admob"))
                    expect(self.adapter.status).to(equal(MediatorState.idle))
                }
            }

            describe("Load") {
                it("Should be loading and loaded") {
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
    
    private func makeAd(faulty: Bool = false) -> VIInterstitialAd? {
        let placement = VIPlacement("plt59gczn8crjr99us7", options: nil)
        let result = VISDK.sharedInstance().createInterstitialAd(for: placement)
        result?.delegate = self
        
        let adapter = AdMobVIInterstitialAdapter(placementID: faulty ? "" : self.accId)
        result?.registerMediation?(adapter)
        return result
    }
}

extension VIAdMobAdapterSpec: VIAdDelegate {
    func adDidReceiveError(_ error: Error) {
        self.error = error
    }
    
    func adDidReceive(_ event: VIAdEvent) {
        print("event = \(event)")
        self.event = event
    }
}

