//
//  DeleteTableViewCell.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/10/18.
//

import UIKit

import RxSwift
import RxRelay

protocol cellSeeMoreDetailActionDelegate : AnyObject{
    func clickSeeMoreDetailBtnAction(cell : DeleteTableViewCell, id : Int,algorithmNumber: Int)
}

final class DeleteTableViewCell : BaseTableViewCell<Algorithm.Datas.Results>{
    //MARK: - Delegate
    weak var delegate : cellSeeMoreDetailActionDelegate?
    
    //MARK: - Properties
    private let view = UIView().then{
        $0.backgroundColor = .white
        $0.layer.applySketchShadow(color: .black, alpha: 0.25, x: -1, y: 1, blur: 4, spread: 0)
        $0.layer.cornerRadius = 5
    }
    
    private let algorithm = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundB", size: 13)
        $0.textColor = .systemRed
    }
    private let dataLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundR", size: 12)
        $0.textColor = .lightGray
    }
    private let tagLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundR", size: 11)
        $0.textColor = .bamBoo_57CC4D
    }
    private let cellSeeMoreDetail = UIButton().then{
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 11)
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
    private let deleteReasonTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundB", size: 15)
        $0.text = "삭제요청사유"
        $0.textColor = .black
    }
    private let deleteReasonContent = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundR", size: 13)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    //MARK: - Configure
    override func configure() {
        super.configure()
        addSubviews()
        location()
    }
    private func addSubviews(){
        contentView.addSubview(view)
        view.addSubviews(algorithm,dataLabel,tagLabel,cellSeeMoreDetail,titleLabel,contentLabel,deleteReasonTitle,deleteReasonContent)
    }
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
            $0.right.equalTo(cellSeeMoreDetail.snp.left).inset(bounds.width/29 * -1)
        }
        cellSeeMoreDetail.snp.makeConstraints {
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
        deleteReasonTitle.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(bounds.width/29)
        }
        deleteReasonContent.snp.makeConstraints {
            $0.top.equalTo(deleteReasonTitle.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(bounds.width/29)
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    override func bind(_ model: Algorithm.Datas.Results) {
        algorithm.text = "#\(model.algorithmNumber)번째 삭제요청"
        dataLabel.text = Date().usingDate(time: model.createdAt)
        tagLabel.text = model.tag
        titleLabel.text = model.title
        contentLabel.text = model.content
        deleteReasonContent.text = model.reason
    }
    override func bindAction(_ model: Algorithm.Datas.Results) {
        cellSeeMoreDetail.rx.tap
            .subscribe({ [weak self] _ in
                self?.delegate?.clickSeeMoreDetailBtnAction(cell: self!, id: model.idx, algorithmNumber: model.algorithmNumber)
            }).disposed(by: disposeBag)
    }
}
