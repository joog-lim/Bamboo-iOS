//
//  StandByViewController.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/10/18.
//

import UIKit
import Reusable

import RxSwift
import RxCocoa
import RxDataSources

final class StandByViewController : baseVC<StandByReactor>{
    //MARK: - Properties
    private var isLoaing : Bool = false
    
    private let titleLabel = UILabel().then{
        $0.font = UIFont(name: "NanumSquareRoundB", size: 20)
        $0.text = "대기"
        $0.textColor = .systemYellow
    }

    private let mainTableView = UITableView().then {
        $0.register(cellType: StandByTableViewCell.self)
        $0.sameSetting()
    }
    private lazy var tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: bounds.height/10.15))
    private lazy var tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: bounds.height/20))

    //MARK: - Helper
    override func configureUI() {
        super.configureUI()
        //navigationItem
        navigationItem.applyImageNavigation()
        
        //tableView
        tableViewHeaderSetting()
        tableFooterViewSetting()
        mainTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    override func addView() {
        super.addView()
        view.addSubview(mainTableView)
    }
    override func setLayout() {
        super.setLayout()
        mainTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeArea.edges)
        }
    }
    
    //MARK: - TableViewHeaderSetting
    private func tableViewHeaderSetting(){
        mainTableView.tableHeaderView = tableViewHeader
        mainTableView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(tableViewHeader)
            $0.left.equalToSuperview().offset(bounds.width/18.75)
        }
    }
    //MARK: - tableViewFooter
    private func tableFooterViewSetting(){
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        activityIndicatorView.tintColor = .lightGray
        mainTableView.tableFooterView = tableViewFooter
        mainTableView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(tableViewFooter)
        }
    }
    //MARK: - Bind
    override func bindAction(reactor: StandByReactor) {
        self.rx.viewDidLoad
            .map{_ in Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    override func bindState(reactor: StandByReactor) {
        let dataSource = RxTableViewSectionedReloadDataSource<StandBySection.Model>{ dataSource, tableView, indexPath, sectionItem in
            switch sectionItem{
            case .main(let algorithm):
                let cell = tableView.dequeueReusableCell(for: indexPath) as StandByTableViewCell
                cell.delegate = self
                cell.model = algorithm
                return cell
            }
        }
        self.mainTableView.rx.didEndDragging
            .withLatestFrom(self.mainTableView.rx.contentOffset)
            .map{ [weak self] in
                Reactor.Action.pagination(
                    contentHeight: self?.mainTableView.contentSize.height ?? 0,
                    contentOffsetY: $0.y,
                    scrollViewHeight: UIScreen.main.bounds.height
                )
            }
            .bind(to:  reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.mainSection)
            .distinctUntilChanged()
            .map(Array.init(with: ))
            .bind(to: self.mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

//MARK: - Click Cell inside Btn Action
extension StandByViewController : StandBytableViewCellBtnClickDelegate{
    func clickSeeMoreDetailBtn(cell: StandByTableViewCell, id: Int) {
        guard let indexPath = mainTableView.indexPath(for: cell) else {return}
        mainTableView.reloadData()
        _ = reactor?.mutate(action: Reactor.Action.standbyBtnTap(titleText: "선택", message: "게시물을 대기 하시겠습니까?", idx: id, index: indexPath.row))
    }
}
