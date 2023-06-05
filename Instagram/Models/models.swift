//
//  models.swift
//  Instagram
//
//  Created by Arnaud Casame on 3/19/21.
//

import Foundation


enum Gender {
    case female, male, other
}

public struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let profilePhoto: URL
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

public struct UserPost {
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let likeCount: [PostLikes]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUser: [User]
    let owner: User
}

public struct PostLikes {
    let username: String
    let postIdentifier:  String
}

public struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

public struct CommentLike {
    let username: String
    let commentIdentifier: String
}
