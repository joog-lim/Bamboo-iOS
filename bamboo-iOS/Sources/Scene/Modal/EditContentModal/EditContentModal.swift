//
//  EditContentModal.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/10/24.
//

import UIKit
import PanModal
import RxKeyboard

final class EditContentModal : baseVC<EditContentModalReactor>{
    //MARK: - Properties
    private let editContentTitle = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundB", size: 14)
        $0.text = "수정하기"
        $0.textColor = .bamBoo_57CC4D
    }
    private let titleTf = AlertTextField(placeholder: "제목을 입력하세요", fontSize: 11)
    private let contentTv = AlertTextView(placeholder: "내용을 입력하세요",fontSize: 11)
    private let editBtn = UIButton().then{
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 13)
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = .bamBoo_57CC4D
        $0.layer.cornerRadius = 5
    }
    private let cancelBtn = UIButton().then{
        $0.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 13)
        $0.backgroundColor = .lightGray
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.layer.cornerRadius = 5
    }
    private lazy var btnStackView = UIStackView(arrangedSubviews: [editBtn,cancelBtn]).then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = bounds.width/75
    }
    
    //MARK: - Helper
    override func addView() {
        super.addView()
        view.addSubviews(editContentTitle,titleTf,contentTv,btnStackView)
    }
    override func setLayout() {
        super.setLayout()
        editContentTitle.snp.makeConstraints{
            $0.top.equalToSuperview().offset(bounds.height/27.0666)
            $0.left.equalToSuperview().offset(bounds.width/15.625)
        }
        titleTf.snp.makeConstraints {
            $0.top.equalTo(editContentTitle.snp.bottom).offset(bounds.height/81.2)
            $0.left.right.equalToSuperview().inset(bounds.width/15.625)
            $0.height.equalTo(bounds.height/27.0666)
        }
        contentTv.snp.makeConstraints {
            $0.top.equalTo(titleTf.snp.bottom).offset(bounds.height/81.2)
            $0.left.right.equalToSuperview().inset(bounds.width/15.625)
            $0.height.equalTo(bounds.height/8.12)
        }
        btnStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(bounds.width/15.625)
            $0.height.equalTo(bounds.height/23.2)
            $0.top.equalTo(contentTv.snp.bottom).offset(bounds.height/40.6)
        }
    }
    override func keyBoardLayout() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [panScrollable] KeyboardVisibleHeight in
                panScrollable?.contentOffset.y += KeyboardVisibleHeight
            }).disposed(by: disposeBag)
    }
    //MARK: - KeyboardDown
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    //MARK: - Bind
    override func bindView(reactor: EditContentModalReactor) {
        super.bindView(reactor: reactor)
        cancelBtn.rx.tap
            .map{ Reactor.Action.cancelBtnTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension EditContentModal : PanModalPresentable{
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    var panScrollable: UIScrollView?{return nil}
    var panModalBackgroundColor: UIColor{return .black.withAlphaComponent(0.1)}

    var cornerRadius: CGFloat{return 40}
    
    var longFormHeight: PanModalHeight{
        return .maxHeightWithTopInset(250)
    }
    var anchorModalToLongForm: Bool {return false}
    var showDragIndicator: Bool { return false}
}
