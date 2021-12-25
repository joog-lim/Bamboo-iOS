//
//  BulletinBoardsTableViewCell.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/09/28.
//

import UIKit
import RxSwift
import RxCocoa
class BulletinBoardsTableViewCell : baseTableViewCell<BulletinBoardsTableViewCellReactor>{
    //MARK: - Delegate
    weak var delegate : ClickReportBtnActionDelegate?
    
    //MARK: - Properties
    private let  view = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
    }
    private let algorithm = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundB", size: 13)
        $0.textColor = .bamBoo_57CC4D
    }
    private let  dataLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundR", size: 11)
        $0.textColor = .lightGray
    }
    private let tagLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundR", size: 11)
        $0.textColor = .bamBoo_57CC4D
    }
    private let titleLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundB", size: 13)
        $0.textColor = .black
    }
    private let contentLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.font = UIFont(name: "NanumSquareRoundR", size: 13)
        $0.textColor = .black
    }
    private let cellSettingbtn = UIButton().then{
        $0.setTitle("신고", for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
//        $0.addTarget(self, action: #selector(reportBtnclickAction), for: .touchUpInside)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 11)
    }
    private let footerView = UIView()
    
    private let likeBtn = LikeOrDisLikeView().then{
        $0.iv.image = UIImage(named: "BAMBOO_Good_Leaf")
        $0.isSelected = false
//        $0.addTarget(self, action: #selector(likeBtnClick), for: .touchUpInside)
    }
    
    //MARK: - Selector
    @objc private func likeBtnClick(){
        likeBtn.isSelected = !likeBtn.isSelected
        delegate?.clickLikeBtnAction(cell: self, state: likeBtn.isSelected)
    }
//    @objc private func reportBtnclickAction(){
//        delegate?.clickReportBtnAction(cell: self)
//    }

    //MARK: - Configure
    override func configure() {
        super.configure()
        addSubviews()
        location()
        contentView.layer.applySketchShadow(color: .black, alpha: 0.25, x: -1, y: 1, blur: 4, spread: 0)

    }

    //MARK: - AddSubView
    private func addSubviews(){
        contentView.addSubview(view)
        [algorithm,dataLabel,tagLabel,titleLabel,contentLabel,footerView,likeBtn,cellSettingbtn].forEach { view.addSubview($0)}
    }
    
    //MARK: - Location(나중 정리 예정)
    private func location(){
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(bounds.width/18.75)
            make.bottom.equalToSuperview().inset(5)
        }
        algorithm.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().inset(bounds.width/29)
        }
        dataLabel.snp.makeConstraints {
            $0.centerY.equalTo(algorithm)
            $0.centerX.equalToSuperview()
        }
        tagLabel.snp.makeConstraints{
            $0.centerY.equalTo(algorithm)
            $0.right.equalTo(cellSettingbtn.snp.left).inset(bounds.width/29 * -1)
        }
        cellSettingbtn.snp.makeConstraints {
            $0.centerY.equalTo(algorithm)
            $0.height.equalTo(tagLabel.snp.height)
            $0.right.equalToSuperview().inset(bounds.width/29)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(algorithm)
            $0.top.equalTo(algorithm.snp.bottom).offset(bounds.width/37.5)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(bounds.width/53.57)
            $0.left.right.equalToSuperview().inset(bounds.width/29)
        }
        footerView.snp.makeConstraints{
            $0.top.equalTo(contentLabel.snp.bottom)
            $0.height.equalTo(bounds.width/7.5)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        likeBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(11)
            $0.right.equalToSuperview().inset(bounds.width/29)
            $0.height.equalTo(18)
            $0.width.equalTo(bounds.width/12.83)
        }
    }
    
    //MARK: - bind로 데이터 넘겨줌
    override func bindView(reactor: BulletinBoardsTableViewCellReactor) {
        algorithm.text = "#\(reactor.currentState.number)번 알고리즘"
        dataLabel.text = "2021년 12월 25일"
        tagLabel.text = reactor.currentState.tag
        titleLabel.text = reactor.currentState.title
        contentLabel.text = reactor.currentState.content
        likeBtn.label.text = "11"
        likeBtn.isSelected = false
    }
}
//MARK: - 신고 버튼 눌렸을때 동작
protocol ClickReportBtnActionDelegate : AnyObject{
    func clickReportBtnAction(cell : BulletinBoardsTableViewCell)
    func clickLikeBtnAction(cell: BulletinBoardsTableViewCell, state : Bool)
}
