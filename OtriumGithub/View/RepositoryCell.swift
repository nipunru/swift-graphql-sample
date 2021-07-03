//
//  RepositoryCell.swift
//  OtriumGithub
//
//  Created by Nipun Ruwanpathirana on 2021-07-02.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    let imgProfile = UIImageView(frame: .init(x: 0, y: 0, width: 32, height: 32))
    let imgStar = UIImageView(frame: .init(x: 0, y: 0, width: 12, height: 12))
    let imgOval = UIImageView(frame: .init(x: 0, y: 0, width: 10, height: 10))
    let lblUsername = UILabel()
    let lblRepoName = UILabel()
    let lblRepoDesc = UILabel()
    let lblStarCount = UILabel()
    let lblLanguage = UILabel()
    
    func setData(repository: Repository, profile: Profile) {
        setupUI()
        lblUsername.text = profile.login
        lblRepoName.text = repository.name
        lblStarCount.text = "\(repository.stars)"
        lblRepoDesc.text = repository.description
        lblLanguage.text = repository.primaryLanguage
        
        if let imageURL = URL(string:profile.avatarUrl ?? "") {
            ImageDownloadManager.shared.downloadImage(from: imageURL, imageView: imgProfile, username: profile.login!)
        }
    }
    
    //MARK: UI Setup
    private func setupUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 15
        
        imgProfile.makeRounded()
        imgProfile.image  = UIImage(named: "avatar_placeholder")
        imgProfile.contentMode = .scaleAspectFit
        
        imgStar.image = UIImage(named: "icon_star")
        imgOval.image = UIImage(named: "icon_oval")
        
        lblUsername.textNormal()
        lblRepoName.textBold()
        lblRepoDesc.textNormal()
        lblStarCount.textNormal()
        lblLanguage.textNormal()
        
        [imgProfile,lblUsername,lblRepoName,lblRepoDesc,imgStar,lblStarCount,imgOval,lblLanguage].forEach { (view) in
            self.addSubview(view)
        }
        
        imgProfile.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
        lblUsername.anchor(top: self.topAnchor, leading: imgProfile.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 20, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        lblRepoName.anchor(top: imgProfile.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 2, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        lblRepoDesc.anchor(top: lblRepoName.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 2, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        imgStar.anchor(top: lblRepoDesc.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 12, height: 12))
        
        lblStarCount.anchor(top: lblRepoDesc.bottomAnchor, leading: imgStar.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 4, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        imgOval.anchor(top: lblRepoDesc.bottomAnchor, leading: lblStarCount.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 10, height: 10))
        
        lblLanguage.anchor(top: lblRepoDesc.bottomAnchor, leading: imgOval.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 4, bottom: 0, right: 0), size: .init(width: 0, height: 24))
    }
}
