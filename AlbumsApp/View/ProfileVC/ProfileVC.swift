//
//  ViewController.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import UIKit
import Combine

class ProfileVC: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var AlbumsTableView: UITableView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    

    private let viewModel = AlbumViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerAlbumCell()
        viewModel.fetchUsers()
        viewModel.fetchAlbums()
        bindViewModel()
    }

    //MARK: helper function
    
    func registerAlbumCell() {
        AlbumsTableView.register(UINib(nibName: AlbumTableViewCell.albumCellIdentifier, bundle: nil), forCellReuseIdentifier: AlbumTableViewCell.albumCellIdentifier)
    }
    
    
    private func bindViewModel() {
        // users
        viewModel.$users
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    guard let firstUser = self?.viewModel.users.first else {
                        self?.userNameLBL.text = "No User Found"
                        self?.userAddress.text = "No Address Available"
                        return
                    }
                    self?.userNameLBL.text = firstUser.name
                    self?.userAddress.text = firstUser.fullAddress
                }
            }
            .store(in: &cancellables)
        
        
        //Albums
        viewModel.$albums
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.AlbumsTableView.reloadData()
                }
                
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { [weak self] message in
                guard let message = message else { return }
                self?.showError(message)
            }
            .store(in: &cancellables)
    }
     
     private func showError(_ message: String) {
         let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }
    

}
//MARK: - AlbumTableView Extension

extension ProfileVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.albumCellIdentifier) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        let album = viewModel.albums[indexPath.row]
        cell.setupCell(name: album.title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = storyboard?.instantiateViewController(identifier: "AlbumDetailsVC") as! AlbumDetailsVC
        detailsVC.screenTitle = viewModel.albums[indexPath.row].title
        detailsVC.albumId = viewModel.albums[indexPath.row].id
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }
    
}
