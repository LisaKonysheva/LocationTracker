//
//  UIView+Stylable.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import UIKit

protocol Stylable {}

extension UIView: Stylable {}

extension Stylable where Self: UIView {
    @discardableResult
    func disableConstraintsTranslation() -> Self {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }

    @discardableResult
    func add(into container: UIView, insets: UIEdgeInsets = .zero) -> Self {
        disableConstraintsTranslation()
        container.addSubview(self)
        return edges(insets: insets, to: container)
    }

    @discardableResult
    func edges(insets: UIEdgeInsets = .zero, to view: UIView) -> Self {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left)
        ])
        return self
    }
}

