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
		let predicate = createPredicate()
		
		let query = statisticsQuery(quantityType: stepsCountType, predicate: predicate, calcType: nil) { (result) in
			callback(result)
		}
		healthStore?.execute(query)
	}
	
	func getCalories(callback: @escaping (Double) -> Void) {
		let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
		let predicate = createPredicate()
		
		let query = statisticsQuery(quantityType: caloriesType, predicate: predicate, calcType: "calories") { (result) in
			callback(result)
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
	
	private func createPredicate() -> NSPredicate {
		let now = Date()
		let startOfDay = Calendar.current.startOfDay(for: now)
		
		return HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
	}
	
	private func statisticsQuery(quantityType: HKQuantityType, predicate: NSPredicate, calcType: String?, completion: @escaping (Double) -> Void) -> HKStatisticsQuery {
		let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
			guard let result = result, let sum = result.sumQuantity() else {
				return
			}
			
			if (calcType == "calories") {
				completion(sum.doubleValue(for: HKUnit.kilocalorie()))
			} else {
				completion(sum.doubleValue(for: HKUnit.count()))
			}
		}
		
		return query
	}	
}
