//
//  ViewController.swift
//  SearchBarInTableViewHeader
//
//  Created by 劉子瑜 on 2021/4/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var songTableView: UITableView!
    
    lazy var viewModel: SongViewModel = {
        return SongViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        songTableView.delegate = self
        songTableView.dataSource = self
                
        initVM()
    }

    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.songTableView.alpha = 0.0
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.songTableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.songTableView.reloadData()
            }
        }

        let parms = ["term":"劉德華","media":"music","country":"TW"]
        viewModel.initFetch(parms: parms)
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewMode(at: indexPath)
        cell.songViewModel = cellVM
        
        return cell
    }
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var songViewModel: SongCellViewModel? {
        didSet {
            nameLabel.text = songViewModel?.name
            photoImageView.sd_setImage(with: songViewModel?.imageUrl, completed: nil)
        }
    }
}

