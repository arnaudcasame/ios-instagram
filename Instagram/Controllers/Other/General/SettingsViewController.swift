//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Arnaud Casame on 2/23/21.
//
import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (()-> Void)
}


final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModel()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModel(){
        data.append([
            SettingCellModel(title: "Edit Profile"){ [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite Friends"){ [weak self] in
                self?.didTapInviteFriends()
            },
            SettingCellModel(title: "Save Original Posts"){ [weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        data.append([
            SettingCellModel(title: "Terms of Service"){ [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy"){ [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "Help / Feedback"){ [weak self] in
                self?.openURL(type: .help)
            }
        ])
        data.append([
            SettingCellModel(title: "Log Out"){ [weak self] in
                self?.didTaplogOut()
            }
        ])
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends(){}
    
    private func didTapSaveOriginalPosts(){}
    
    private func openURL(type: SettingsURLType) {
        var urlString: String
        switch type {
            case .terms:
                urlString = "https://soiread.com"
            case .privacy:
                urlString = "https://soiread.com"
            case .help:
                urlString = "https://soiread.com"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTaplogOut(){
        let actionSheet =  UIAlertController(title: "Log Out",
                                             message: "Are you sure you want to log out?",
                                             preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        let loginViewController = LoginViewController()
                        loginViewController.modalPresentationStyle = .fullScreen
                        self.present(loginViewController, animated: true, completion: {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        })
                    }else{
                        fatalError("Could not log out user")
                    }
                }
            })
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
