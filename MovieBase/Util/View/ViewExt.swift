//
//  ViewExt.swift
//  MovieBase
//
//  Created by merengue on 31/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import CoreData

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

var persistentContainer: NSPersistentContainer {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
}
