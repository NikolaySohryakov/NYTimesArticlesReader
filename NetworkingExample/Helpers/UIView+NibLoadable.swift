//
// Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation
import UIKit

extension UIView {
    static var nib: UINib {
        get {
            return UINib(nibName: String(describing: self), bundle: nil)
        }
    }
}