//
//  ViewController.swift
//  HealthKitApp
//
//  Created by Henry Paulino on 10/18/18.
//  Copyright © 2018 Henry Paulino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var healthkitStore: HealthKitManager?
	var stepCount: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		healthkitStore = HealthKitManager()
	}


}

