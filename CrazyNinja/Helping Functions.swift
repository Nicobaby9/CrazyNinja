//
//  Helping Functions.swift
//  CrazyNinja
//
//  Created by sarkom-1 on 14/06/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import Foundation
import UIKit

func randomCGFloat(_ lowerlimit: CGFloat, _ upperLimit: CGFloat) -> CGFloat {
    return lowerlimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerlimit)
}
