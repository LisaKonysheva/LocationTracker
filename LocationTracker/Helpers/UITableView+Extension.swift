//
//  UITableView+Extension.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import UIKit

public protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    public func register(cellWithClass cell: UITableViewCell.Type) {
        register(cell.self, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath, identifier: String? = nil) -> T {
        let reuseIdentifier = identifier ?? T.reuseIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }

        return cell
    }
}
