//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by Arnaud Casame on 3/5/21.
//

import UIKit

protocol IGFeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapPostMoreButton()
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = nil
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .label
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(nameLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(profilePhotoImageView)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with user: User) {
        nameLabel.text = user.username
        profilePhotoImageView.sd_setImage(with: user.profilePhoto)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePhotoImageView.image = nil
        nameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        profilePhotoImageView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilePhotoImageView.layer.cornerRadius = size/2
        
        moreButton.frame = CGRect(x: contentView.width - size, y: 2, width: size, height: size)
        
        nameLabel.frame = CGRect(x: profilePhotoImageView.right + 10, y: 2, width: contentView.width - (size*2) - 15, height: contentView.height - 4)
        
    }
    
    @objc private func didTapMoreButton(){
        delegate?.didTapPostMoreButton()
    }

}
