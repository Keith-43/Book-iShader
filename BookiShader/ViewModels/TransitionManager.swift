/*
 TransitionManager.swift
 Book iShader

 Created by Treata Norouzi on 4/21/24.
 
 Abstract:
 A simple manager for TransitionPreviews which handles the pause/resume of transitions
*/

import Foundation

@Observable
class TransitionManager {
    
    /// The duration of the transition
    @ObservationIgnored var duration: TimeInterval = 1.618
    /// The rest duration between the transitions
    @ObservationIgnored var restDuration: TimeInterval = 1.618 * 1.5
    
    init(duration: TimeInterval = 1.618, paused: Bool = true, restDuration: TimeInterval = 1.618 * 1.5) {
        self.duration = duration
        self.paused = paused
        
        // The restDuration should always be atleast 5_10% longer than the transitionDuration
        // or the transitions would stop working
        let smallPause = self.duration * 1.1
        if restDuration < smallPause {
            self.restDuration = smallPause
            print("TransitionManager; Adjusted restDuration")
        }
    }
    
    /// Variable to keep track of elapsed time
    private(set) var elapsedTime: TimeInterval = 0
    
    var paused = true {
        willSet {
            if !newValue {
                if automationTimer == nil { startTimer() }
            } else {
                pauseTimer()
            }
        }
    }
    
    /**
     Automates the transitions between views with the `restDuration` interval
     */
    private(set) var automationTimer: Timer?
    
    // MARK: - Instance Methods
    
    private func startTimer() {
        self.automationTimer = Timer.scheduledTimer(withTimeInterval: restDuration, repeats: true) { [weak self] timer in
            self?.elapsedTime += timer.timeInterval
        }
    }
    
    private func pauseTimer() {
        self.automationTimer?.invalidate()
        automationTimer = nil
    }
}
