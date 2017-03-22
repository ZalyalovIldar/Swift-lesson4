//
//  TestViewController.swift
//  SwiftMapRequest
//
//  Created by Наталья on 21.03.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class TestViewController: UIViewController {
    
    
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    let timerSignal = Signal<String, NoError> { observer in
        
        observer.send(value: "4")
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (_) in
            observer.send(value: "5")
        })
//        var counter = 0
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
//            
//            observer.send(value: "Counter: \(counter)")
//            counter += 1
//        })
        return nil;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timerSignal.observeValues { (value) in
            self.firstTextField.text = value;
        }
        
        timerSignal.observeValues { (value) in
            self.secondTextField.text = value
        }
//        let mergeSignal = Signal.merge(firstTextField.reactive.continuousTextValues.signal, secondTextField.reactive.continuousTextValues.signal)
//        let (signal, observer) = Signal<Int, NoError>.pipe()
//        
//        signal.observeValues { (value) in
//            print(value)
//        }
//        
//        let observerIs = signal.observeValues { (values) in
//            print("Value: \(values)")
//        }
////        observerIs?.dispose()
//        
//        observer.send(value: 4)
//        observer.send(value: 5)
//        
//        
//        mergeSignal.observeValues { (value) in
//            self.timerLabel.text? += value!
//        }
//        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
