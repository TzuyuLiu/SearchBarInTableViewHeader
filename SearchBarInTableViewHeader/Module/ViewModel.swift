//
//  ViewModel.swift
//  SearchBarInTableViewHeader
//
//  Created by 劉子瑜 on 2021/4/22.
//

import Foundation

class SongViewModel {
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    var apiService: APIServiceProtocol
    
    private var songs:[Song] = [Song]()
    
    private var cellViewModels: [SongCellViewModel] = [SongCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (()->())?

    func initFetch(parms:[String:String]) {
        self.isLoading = true
        apiService.fetchSongs(parameters: parms) { (result, songs, error) in
            self.isLoading = false
            if let error = error {
                self.alertMessage = error.rawValue
            } else {
                if let songs = songs {
                    self.processFetchedSong(songs: songs)
                }
            }
        }
    }
    
    private func createCellViewModel(song: Song) -> SongCellViewModel {
        return SongCellViewModel(name: song.trackName, imageUrl: song.artworkUrl100)
    }
    
    private func processFetchedSong(songs: [Song]) {
        self.songs = songs
        var vms = [SongCellViewModel]()
        for song in songs {
            vms.append(self.createCellViewModel(song: song))
        }
        self.cellViewModels = vms
    }
    
    func getCellViewMode( at indexPath: IndexPath) -> SongCellViewModel {
        return cellViewModels[indexPath.row]
    }
}


struct SongCellViewModel {
    let name:String
    let imageUrl:URL
}
