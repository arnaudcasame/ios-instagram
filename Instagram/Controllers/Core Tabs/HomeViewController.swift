//
//  ViewController.swift
//  Instagram
//
//  Created by Arnaud Casame on 2/23/21.
//
import FirebaseAuth
import UIKit

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createMockModels()
    }
    
    private func createMockModels(){
        var comments = [PostComment]()
        for _ in 0...5 {
            comments.append(PostComment(identifier: "Identity", username: "Joe", text: "This is the comment text", createdDate: Date(), likes: [CommentLike(username: "Junior", commentIdentifier: "Identifier")]))
        }
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
        for _ in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated(){
        // Check auth status
        if Auth.auth().currentUser == nil {
            // show login page
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: false)
        }
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }else{
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        if subSection == 0 {
            // Header
            return 1
        }else if subSection == 1 {
            // Post
            return 1
        }else if subSection == 2 {
            // Actions
            return 1
        }else if subSection == 3 {
            // Comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments):
                return comments.count > 2 ? 2 : comments.count
            case .header, .primaryContent, .actions: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }else{
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        if subSection == 0 {
            // Header
            let headerModel = model.header
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .primaryContent, .actions: return UITableViewCell()
            }
        }else if subSection == 1 {
            // Post
            let postModel = model.post
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .header, .comments, .actions: return UITableViewCell()
            }
        }else if subSection == 2 {
            // Actions
            let actionsModel = model.actions
            switch actionsModel.renderType {
            case .actions(let actions):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .header, .primaryContent, .comments: return UITableViewCell()
            }
        }else if subSection == 3 {
            // Comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .header, .primaryContent, .actions: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {
            // Header
            return 70
        }else if subSection == 1 {
            // Post
            return tableView.width
        }else if subSection == 2 {
            // Actions
            return 60
        }else if subSection == 3 {
            // Comments
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section % 4 == 3 ? 70 : 0
    }
}


extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapPostMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: {[weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func reportPost(){
        
    }
}


extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapPostLikeButton() {
        print("Like")
    }
    
    func didTapPostCommentButton() {
        print("Comment")
    }
    
    func didTapPostSendButton() {
        print("Send")
    }
    
    
}
