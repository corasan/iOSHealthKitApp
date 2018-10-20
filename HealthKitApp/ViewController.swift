//
//  ViewController.swift
//  HealthKitApp
//
//  Created by Henry Paulino on 10/18/18.
//  Copyright © 2018 Henry Paulino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var steps: UILabel!
	@IBOutlet weak var calories: UILabel!
	
	var healthkitStore: HealthKitManager?
	var stepCount: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		steps.sizeToFit()
		calories.sizeToFit()
		healthkitStore = HealthKitManager()
		
		setSteps()
		setCalrories()
	}

	func setSteps() {
		healthkitStore?.getSteps(callback: { (stepCount) in
			DispatchQueue.main.async {
				self.steps.text = self.formatDouble(stepCount)
			}
		})
	}
	
	func setCalrories() {
		healthkitStore?.getCalories(callback: { (calories) in
			DispatchQueue.main.async {
				self.calories.text = self.formatDouble(calories)
			}
		})
	}
	
	private func formatDouble(_ number: Double) -> String {
		return String(format: "%.0f", number)
	}
}

