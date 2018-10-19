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
	var healthStore: HKHealthStore?

	init() {
		print("initializing...")
		initHealthKit()
	}
	
	func getSteps(callback: @escaping (Double) -> Void) {
		let stepsCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
		let now = Date()
		let startOfDay = Calendar.current.startOfDay(for: now)
		let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
		
		let query = HKStatisticsQuery(quantityType: stepsCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
			guard let result = result, let sum = result.sumQuantity() else {
				return
			}
			callback(sum.doubleValue(for: HKUnit.count()))
		}
		healthStore?.execute(query)
	}

	private func initHealthKit() {
		if HKHealthStore.isHealthDataAvailable() {
			healthStore = HKHealthStore()
			
			let allTypes = Set([
				HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
				HKObjectType.characteristicType(forIdentifier: .biologicalSex),
				HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
				HKObjectType.quantityType(forIdentifier: .height),
				HKObjectType.quantityType(forIdentifier: .heartRate),
				HKObjectType.quantityType(forIdentifier: .stepCount),
				HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
			])
			
			healthStore!.requestAuthorization(toShare: nil, read: allTypes as? Set<HKObjectType>) { (success, error) in
				if !success {
					print("Error authorizing HealthKit")
				}
			}
		}
	}
}
