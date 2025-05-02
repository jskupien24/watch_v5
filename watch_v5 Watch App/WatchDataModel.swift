//
//  WatchDataModel.swift
//  watch_v5
//
//  Created by Fort Hunter on 5/2/25.
//

import Foundation
import Combine

class WatchDataModel: ObservableObject {
    @Published var diveLocations: [String] = []  // Published property to track dive locations
}
