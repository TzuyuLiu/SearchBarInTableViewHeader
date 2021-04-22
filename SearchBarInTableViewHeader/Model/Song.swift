//
//  Song.swift
//  SearchBarInTableViewHeader
//
//  Created by 劉子瑜 on 2021/4/22.
//

import Foundation

struct Songs: Codable {
    let resultCount:Int
    let results: [Song]
}

struct Song: Codable {
    let trackName: String
    let artistName: String
    var kind: String
    var artworkUrl100: URL
}


