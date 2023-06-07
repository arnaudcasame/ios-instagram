//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Arnaud Casame on 2/23/21.
//

import UIKit

class ExploreViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    private var collectionView: UICollectionView?
    private var tabbedSearchCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchBar()
        configureExploreCollection()
        configureTabbedSearchView()
        configureDimmedView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 72)
    }
    
    private func configureTabbedSearchView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabbedSearchCollectionView?.backgroundColor = .yellow
        tabbedSearchCollectionView?.isHidden = true
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func configureSearchBar(){
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    private func configureDimmedView(){
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureExploreCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width - 4)/3, height: (view.width - 4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(debug: "abstract")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == tabbedSearchCollectionView {
            //change search context
            return
        }
//        let model = models[indexPath.row]
        let user = User(username: "joe",
                        bio: "",
                        name: (first: "", last: ""),
                        birthDate: Date(),
                        profilePhoto: URL(string: "https://firebasestorage.googleapis.com/v0/b/debtors2-0.appspot.com/o/authors%2Fprofile-placeholder.png?alt=media&token=23e2336b-c05c-4151-8670-b8a930fa4a29")!,
                        gender: .male,
                        counts: UserCount(followers: 1,
                                          following: 5,
                                          posts: 25),
                        joinDate: Date())
        let post = UserPost(postType: .photo,
                            thumbnailImage: URL(string: "https://firebasestorage.googleapis.com/v0/b/debtors2-0.appspot.com/o/bequeen%2Fimaan-hammam.jpeg?alt=media&token=16fd3c5f-4891-455a-ab2f-d237fc082a3c")!,
                            postURL: URL(string: "https://www.google.com")!,
                            caption: "This is photo post",
                            likeCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUser: [],
                            owner: user)
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        query(text)
    }
    
    private func query(_ text: String){
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }){ done in
            if done {
                self.tabbedSearchCollectionView?.isHidden = false
            }
        }
    }
    
    @objc private func didCancelSearch(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        tabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }
}
