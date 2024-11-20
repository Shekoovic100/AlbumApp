//
//  AlbumDetailsVC.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import UIKit
import Combine


class AlbumDetailsVC: UIViewController {
    
    //MARK: outlets
    
    @IBOutlet weak var imagesSerachBar: UISearchBar!
    @IBOutlet weak var albumImagesCollectionView: UICollectionView!
    
    private let viewModel = AlbumViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // for search
    private var allAlbums: [AlbumImages] = []
    private var filteredAlbums: [AlbumImages] = []
    
    
    var screenTitle: String?
    var albumId: Int?
    
    
    //MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbarUI()
        setupCollectionView()
        setupSearchBar()
        viewModel.fetchImages(albumId: albumId ?? 0)
        bindViewModel()
    }
    
    //MARK: helper function
    
    func setupNavbarUI() {
        self.title = screenTitle
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupSearchBar() {
        imagesSerachBar.delegate = self
        imagesSerachBar.placeholder = "Search in images.."
        imagesSerachBar.sizeToFit()
    }
    
    func setupCollectionView() {
        albumImagesCollectionView.register(UINib(nibName: DetailsCollectionViewCell.collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: DetailsCollectionViewCell.collectionViewCellIdentifier)
    }
    
    func bindViewModel() {
        viewModel.$albumImages
            .sink { [weak self] albums in
                    self?.filteredAlbums = albums
                    self?.allAlbums = albums
                    self?.albumImagesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

//MARK: collectionView Extension

extension AlbumDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell.collectionViewCellIdentifier, for: indexPath) as? DetailsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageUrl = viewModel.albumImages[indexPath.row].url
        cell.setupImage(imageUrl: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedImageUrl = viewModel.albumImages[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(identifier: "ImageDetailVC") as! ImageDetailVC
        detailVC.imageUrl = selectedImageUrl.url
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: UISearchBarDelegate

extension AlbumDetailsVC: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredAlbums = allAlbums
        } else {
            filteredAlbums = allAlbums.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        albumImagesCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredAlbums = allAlbums
        albumImagesCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}
