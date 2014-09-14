//
//  SEPushNoAnimationSegue.swift
//  swiftPeaceTrack<3
//
//  Created by Shelagh McGowan on 8/8/14.
//  Copyright (c) 2014 Shelagh McGowan. All rights reserved.
//

import Foundation
import UIKit

//creating a Swift class that inherits from an objective C class here
//used to control my segue manually

@objc(SEPushNoAnimationSegue)
class SEPushNoAnimationSegue: UIStoryboardSegue {
    
    override func perform () {
        var src = self.sourceViewController as UIViewController
        var dst = self.destinationViewController as UIViewController
        src.navigationController.pushViewController(dst, animated:false)
    }
}