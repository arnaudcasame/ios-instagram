//
//  IGFeedPostActionsTableViewCell.swift
//  Instagram
//
//  Created by Arnaud Casame on 3/6/21.
//

import UIKit

protocol IGFeedPostActionsTableViewCellDelegate: AnyObject {
    func didTapPostLikeButton()
    func didTapPostCommentButton()
    func didTapPostSendButton()
}

class IGFeedPostActionsTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostActionsTableViewCell"
    
    weak var delegate: IGFeedPostActionsTableViewCellDelegate?
    
    private let likeButton: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        btn.setImage(image, for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let commentButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "message", withConfiguration: config)
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        btn.setImage(image, for: .normal)
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 10
        let buttons = [likeButton, commentButton, sendButton]
        for i in 0..<buttons.count {
            buttons[i].frame = CGRect(x: (CGFloat(i) * size) + (10 * CGFloat(i+1)), y: 5, width: size, height: size)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc private func didTapLikeButton(){
        delegate?.didTapPostLikeButton()
    }
    @objc private func didTapCommentButton(){
        delegate?.didTapPostCommentButton()
    }
    @objc private func didTapSendButton(){
        delegate?.didTapPostSendButton()
    }
    
}
