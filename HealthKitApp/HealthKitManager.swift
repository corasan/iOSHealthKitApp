//
//  HealthKitManager.swift
//  HealthKitApp
//
//  Created by Henry Paulino on 10/18/18.
//  Copyright © 2018 Henry Paulino. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
	let healthStore = HKHealthStore()
	
	func authorizeHealthKit() -> Bool {
		var isEnabled = true
		
		if HKHealthStore.isHealthDataAvailable() {
			let stepCount = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
			
//			let dataTypeToRead = NSSet(object: stepCount)
			
			healthStore.requestAuthorization(toShare: nil, read: (stepCount as! Set<HKObjectType>)) {
				(success, error) -> Void in
					isEnabled = success
			}
		} else {
			isEnabled = false
		}

		return isEnabled
	}
}
