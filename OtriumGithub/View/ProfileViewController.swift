//
//  ProfileViewController.swift
//  OtriumGithub
//
//  Created by Nipun Ruwanpathirana on 2021-07-01.
//

import UIKit

class ProfileViewController: BaseViewController, ProfilePresenterDelegate {
    
    //MARK: UI Referances
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    let viewContent = UIView()
    let imgProfile = UIImageView(frame: .init(x: 0, y: 0, width: 80, height: 80))
    let lblFullName = UILabel()
    let lblUsername = UILabel()
    let lblEmail = UILabel()
    let lblFollowerCount = UILabel()
    let lblFollower = UILabel()
    let lblFollowingCount = UILabel()
    let lblFollowing = UILabel()
    let lblPinned = UILabel()
    let lblTop = UILabel()
    let lblStarred = UILabel()
    var pinnedRepoCV: UICollectionView?
    var topRepoCV: UICollectionView?
    var starredRepoCV: UICollectionView?
    let activityView = UIActivityIndicatorView()
    var refreshControl: UIRefreshControl!
    
    //MARK: Refetances
    private let presenter = ProfilePresenter()
    private var profile: Profile?
    private var pinnedRepoArray: [Repository] = [Repository]()
    private var topRepoArray: [Repository] = [Repository]()
    private var starredRepoArray: [Repository] = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title_main".localized()
        
        //UI
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
        scrollView.isHidden = true
        setupScrollView()
        setupTopUI()
        setupPinnedRepoUI()
        setupTopRepoUI()
        setupStarredRepoUI()
        
        //Presenter
        presenter.setViewDelegate(delegate: self)
        //Haven't get the user name as user input since not required
        presenter.fetchProfile(username: "rmosolgo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    //MARK: Presenter
    func presentProfile(profile: Profile) {
        self.profile = profile
        
        DispatchQueue.main.async { [weak self] in
            self?.lblFullName.text = profile.name
            self?.lblUsername.text = profile.login
            self?.lblEmail.text = profile.email
            self?.lblFollowerCount.text = "\(profile.followerCount)"
            self?.lblFollowingCount.text = "\(profile.followinCount)"
            
            self?.pinnedRepoArray = profile.pinnedRepos
            self?.topRepoArray = profile.topRepos
            self?.starredRepoArray = profile.starRepos
            
            self?.pinnedRepoCV?.reloadData()
            self?.topRepoCV?.reloadData()
            self?.starredRepoCV?.reloadData()
            
            self?.scrollView.isHidden = false
            self?.activityView.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
        
        if let imageURL = URL(string:profile.avatarUrl ?? "") {
            ImageDownloadManager.shared.downloadImage(from: imageURL, imageView: imgProfile, username: profile.login!)
        }
    }
    
    @objc func refresh() {
        presenter.fetchProfile(username: "rmosolgo")
    }
}

//MARK: UI Setup
extension ProfileViewController {
    //MARK: UI
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(viewContent)
        
        viewContent.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: .zero, size: .init(width: view.bounds.width, height: 1300))
    }
    
    func setupTopUI() {
        //Image | Full Name | Username
        imgProfile.makeRounded()
        imgProfile.image  = UIImage(named: "avatar_placeholder")
        imgProfile.contentMode = .scaleAspectFit
        
        lblFullName.titleMain()
        lblUsername.textNormal()
        lblEmail.textBold()
        lblFollowerCount.textBold()
        lblFollower.textNormal()
        lblFollowingCount.textBold()
        lblFollowing.textNormal()
        
        [imgProfile, lblFullName, lblUsername, lblEmail, lblFollowerCount, lblFollower, lblFollowingCount, lblFollowing].forEach { (view) in
            self.scrollView.addSubview(view)
        }
        
        imgProfile.anchor(top: viewContent.topAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        lblFullName.anchor(top: viewContent.topAnchor, leading: imgProfile.trailingAnchor, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 32, left: 8, bottom: 0, right: 16),size: .init(width: 0, height: 38))
        
        lblUsername.anchor(top: lblFullName.bottomAnchor, leading: imgProfile.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 16),size: .init(width: 0, height: 24))
        
        lblEmail.anchor(top: imgProfile.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16),size: .init(width: 0, height: 24))
        
        lblFollowerCount.anchor(top: lblEmail.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        lblFollower.anchor(top: lblEmail.bottomAnchor, leading: lblFollowerCount.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 4, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        lblFollowingCount.anchor(top: lblEmail.bottomAnchor, leading: lblFollower.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 24))
        
        lblFollowing.anchor(top: lblEmail.bottomAnchor, leading: lblFollowingCount.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 4, bottom: 0, right: 0), size: .init(width: 0, height: 24))
    }
    
    func setupPinnedRepoUI() {
        //Title
        lblPinned.text = "title_pinned".localized()
        lblPinned.titleSub()
        
        let lblViewAll = UILabel()
        let underlineAttriString = NSAttributedString(string: "btn_view_all".localized(),
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        lblViewAll.attributedText = underlineAttriString
        lblViewAll.textBold()
        
        //CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 160)
        
        pinnedRepoCV = UICollectionView(frame: self.viewContent.frame, collectionViewLayout: layout)
        pinnedRepoCV?.register(RepositoryCell.self, forCellWithReuseIdentifier: "PinnedCell")
        pinnedRepoCV?.backgroundColor = UIColor.white
        pinnedRepoCV?.isScrollEnabled = false
        
        pinnedRepoCV?.dataSource = self
        
        [lblPinned, lblViewAll, pinnedRepoCV ?? UICollectionView()].forEach { (view) in
            self.scrollView.addSubview(view)
        }
        
        lblPinned.anchor(top: lblFollowerCount.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        lblViewAll.anchor(top: lblFollowerCount.bottomAnchor, leading: nil, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 16), size: .init(width: 0, height: 24))
        
        pinnedRepoCV?.anchor(top: lblPinned.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 500))
    }
    
    func setupTopRepoUI() {
        //Title
        lblTop.text = "title_top_repositories".localized()
        lblTop.titleSub()
        
        let lblViewAll = UILabel()
        let underlineAttriString = NSAttributedString(string: "btn_view_all".localized(),
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        lblViewAll.attributedText = underlineAttriString
        lblViewAll.textBold()
        
        //CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: 200, height: 160)
        layout.scrollDirection = .horizontal
        
        topRepoCV = UICollectionView(frame: self.viewContent.frame, collectionViewLayout: layout)
        topRepoCV?.register(RepositoryCell.self, forCellWithReuseIdentifier: "TopCell")
        topRepoCV?.backgroundColor = UIColor.white
        topRepoCV?.isScrollEnabled = true
        
        topRepoCV?.dataSource = self
        
        [lblTop, lblViewAll, topRepoCV ?? UICollectionView()].forEach { (view) in
            self.scrollView.addSubview(view)
        }
        
        lblTop.anchor(top: pinnedRepoCV?.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        lblViewAll.anchor(top: pinnedRepoCV?.bottomAnchor, leading: nil, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 16), size: .init(width: 0, height: 24))
        
        topRepoCV?.anchor(top: lblTop.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 200))
    }
    
    func setupStarredRepoUI() {
        //Title
        lblStarred.text = "title_starred_repositories".localized()
        lblStarred.titleSub()
        
        let lblViewAll = UILabel()
        let underlineAttriString = NSAttributedString(string: "btn_view_all".localized(),
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        lblViewAll.attributedText = underlineAttriString
        lblViewAll.textBold()
        
        //CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: 200, height: 160)
        layout.scrollDirection = .horizontal
        
        starredRepoCV = UICollectionView(frame: self.viewContent.frame, collectionViewLayout: layout)
        starredRepoCV?.register(RepositoryCell.self, forCellWithReuseIdentifier: "StarredCell")
        starredRepoCV?.backgroundColor = UIColor.white
        starredRepoCV?.isScrollEnabled = true
        
        starredRepoCV?.dataSource = self
        
        [lblStarred, lblViewAll, starredRepoCV ?? UICollectionView()].forEach { (view) in
            self.scrollView.addSubview(view)
        }
        
        lblStarred.anchor(top: topRepoCV?.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        
        lblViewAll.anchor(top: topRepoCV?.bottomAnchor, leading: nil, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 16), size: .init(width: 0, height: 24))
        
        starredRepoCV?.anchor(top: lblStarred.bottomAnchor, leading: viewContent.leadingAnchor, bottom: nil, trailing: viewContent.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 200))
    }
}

//MARK: Collection View
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pinnedRepoCV {
            return self.pinnedRepoArray.count
        } else if collectionView == topRepoCV {
            return self.topRepoArray.count
        } else if collectionView == starredRepoCV {
            return self.starredRepoArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let profile = self.profile {
            if collectionView == pinnedRepoCV {
                let pinnedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinnedCell", for: indexPath) as! RepositoryCell
                pinnedCell.setData(repository: self.pinnedRepoArray[indexPath.row], profile: profile)
                return pinnedCell
            } else if collectionView == topRepoCV {
                let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! RepositoryCell
                topCell.setData(repository: self.topRepoArray[indexPath.row], profile: profile)
                return topCell
            } else if collectionView == starredRepoCV {
                let starredCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarredCell", for: indexPath) as! RepositoryCell
                starredCell.setData(repository: self.starredRepoArray[indexPath.row], profile: profile)
                return starredCell
            }
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
}
