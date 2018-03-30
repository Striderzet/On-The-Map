//
//  GDCBlackBox.swift
//  On The Map
//
//  Created by Tony Buckner on 2/5/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
