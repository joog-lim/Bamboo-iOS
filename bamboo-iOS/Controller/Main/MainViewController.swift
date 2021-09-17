//
//  MainViewController.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/09/13.
//

import UIKit

class MainViewController : UIViewController{
    //MARK: - Properties
    let bounds = UIScreen.main.bounds

    lazy var tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: bounds.height/10.15)).then{
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then{
        $0.dynamicFont(fontSize: 20, currentFontName: "NanumSquareRoundB")
        $0.textColor = .rgb(red: 87, green: 204, blue: 77)
        $0.text = "하고 싶던 말,"
    }
    let subLabel = UILabel().then{
        $0.textColor = .black
        $0.dynamicFont(fontSize: 20, currentFontName: "NanumSquareRoundB")
        $0.text = "무엇인가요?"
    }
    fileprivate let mainTableView : UITableView = {
        let tv = UITableView()
        tv.register(BulletinBoardTableVIewCell.self, forCellReuseIdentifier: BulletinBoardTableVIewCell.identifier)
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorColor = .clear
        tv.allowsSelection = false
        return tv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationSetting()
        configureUI()
    }
    
    //MARK: - Helper
    func navigationSetting(){
        navigationController?.navigationCustomBar()
        navigationItem.hidesBackButton = true
        navigationItem.applyImageNavigation()
    }
    func configureUI(){
        addView()
        location()
        tableviewSetting()
        tableViewHeaderSetting()
    }
    func tableViewHeaderSetting(){
        mainTableView.tableHeaderView = tableViewHeader
        mainTableView.addSubview(titleLabel)
        mainTableView.addSubview(subLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(bounds.height/40.6)
            $0.left.equalToSuperview().offset(bounds.width/18.75)
        }
        subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel)
        }
        
    }
    func tableviewSetting(){
        mainTableView.dataSource = self
        mainTableView.delegate = self
    }
    func addView(){

        view.addSubview(mainTableView)
    }
    func location(){
        mainTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.left.right.equalToSuperview()
        }
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BulletinBoardTableVIewCell.identifier,for: indexPath) as! BulletinBoardTableVIewCell
        cell.cellTitle.text = "#192번째 알고리즘"
        cell.dateLabel.text = "2021년 3월 12일 새벽"
        cell.tagLabel.text = "#공부"
        cell.writeTitleLabel.text = "역시 개발은 새벽이지"
        return cell
    }

    

}
