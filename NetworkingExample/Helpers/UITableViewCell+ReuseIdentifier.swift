//
// Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation
import UIKit.UITableViewCell

extension UITableViewCell {
    static var reuseIdentifier: String {
        get {
            return String(describing: self)
        }
    }
}