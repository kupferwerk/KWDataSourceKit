//
//  Reusable.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit

/// A protocol that marks type as beeing reusable
/// Every type implementing `Reusable` will receive a computed static property `reuseId` that
/// can be used to identifiy the type. `Reusable` also provides a default implementation 
/// for `reuseId`, which returns the type's name, i.e. for the type `SomeTableViewCell` 
/// the string `SomeTableViewCell` will be returned.
/// - Note: Overriding `reuseId` is supported for type's that do not match the above description.
public protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    public static var reuseId: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }

extension UICollectionViewCell: Reusable { }
