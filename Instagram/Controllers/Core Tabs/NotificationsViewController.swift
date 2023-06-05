//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Arnaud Casame on 2/23/21.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var models = [UserNotification]()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.isHidden = true
        tableView.register(NotificationLikeEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
       return tableView
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
//        view.addSubview(spinner)
//        spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func layoutNoNotificationView(){
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
            case .like(_):
                // like cell
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier,
                                                         for: indexPath) as! NotificationLikeEventTableViewCell
                cell.configure(with: model)
                cell.delegate = self
                return cell
            case .follow:
                // follow cell
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier,
                                                         for: indexPath) as! NotificationFollowEventTableViewCell
                cell.configure(with: model)
                cell.delegate = self
                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    private func fetchNotifications(){
        for x in 0...50 {
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
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .following),
                                         text: "Hello World",
                                         user: user)
            models.append(model)
        }
    }
}


extension NotificationsViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapViewPostButton(model: UserNotification) {
        // Open the related post tapped by user
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should never get called!")
        }
    }
}

extension NotificationsViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnfollowButton(model: UserNotification) {
        // Perform database update
        print(model.type)
    }
}
