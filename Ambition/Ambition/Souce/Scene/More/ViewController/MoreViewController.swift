//
//  MoreViewController.swift
//  Ambition
//
//  Created by 조병진 on 2023/03/04.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MoreViewController: UIViewController {
    private let sections = ["", "공지", "도움말", "약관 및 정책", "앱 정보", "피드백", "계정 관리", "회원탈퇴"]
    private let sectionElements: [[String]] = [
        ["회원정보"],
        ["공지사항", "앰비션 이야기"],
        ["자주 묻는 질문", "앰비션으로 갓생살기"],
        ["이용약관", "개인정보 처리방침"],
        ["버전정보"],
        ["이메일 보내기"],
        ["로그아웃"],
        ["탈퇴하기"]
    ]
    
    private let topView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).then {
        $0.layer.opacity = 0
    }
    
    private let topShadowView = UIView().then {
        $0.backgroundColor = .whiteElevated3
        $0.layer.opacity = 0
    }
    
    private let listTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.contentInsetAdjustmentBehavior = .scrollableAxes
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(MoreListTableViewCell.self, forCellReuseIdentifier: "listCell")
        listTableView.sectionHeaderTopPadding = 35
        let headerView = ListHeaderView(title: "더보기")
        headerView.frame.size.height = 60
        listTableView.tableHeaderView = headerView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        addSubViews()
        makeConstraints()
    }
}

extension MoreViewController {
    private func addSubViews() {
        [
            listTableView,
            topView,
            topShadowView
        ].forEach({ view.addSubview($0) })
        
    }
    private func makeConstraints() {
        topView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(view.safeAreaInsets.top)
            $0.top.equalToSuperview()
        }
        listTableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
        topShadowView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func selectPath(selectName: String) {
        switch selectName {
        case "회원정보":
            print(selectName)
        case "공지사항":
            let noticeView = NoticeViewController()
            navigationController?.pushViewController(noticeView, animated: true)
        case "앰비션 이야기":
            print(selectName)
        case "자주 묻는 질문":
            print(selectName)
        case "앰비션으로 갓생살기":
            print(selectName)
        case "이용약관":
            print(selectName)
        case "개인정보 처리방침":
            print(selectName)
        case "이메일 보내기":
            print(selectName)
        case "로그아웃":
            print(selectName)
        case "탈퇴하기":
            let quitAlert = QuitAlertViewController(
                action: {
                    
                },
                alertStyle: .light
            )
            present(quitAlert, animated: false)
        default:
            print(selectName + " defalte")
        }
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionElements[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? MoreListTableViewCell else { return UITableViewCell() }
        
        if(indexPath.section == 4) {
            cell.arrowImage.layer.opacity = 0
            cell.leftSubLabel.text = "1.0.0"
        }
        
        cell.titleLabel.text = sectionElements[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPath(selectName: sectionElements[indexPath.section][indexPath.row])
//        switch sectionElements[indexPath.section][indexPath.row] {
//        case "탈퇴하기":
//            let quitAlert = QuitAlertViewController(
//                action: {
//                    print("탈퇴")
//                },
//                alertStyle: .light
//            )
//            present(quitAlert, animated: false)
//        default:
//            print(sectionElements[indexPath.section][indexPath.row])
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .whiteElevated3
        
        return section < 7 ? footerView : nil
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section != 4 ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        [
            topView,
            topShadowView
        ].forEach({
            $0.layer.opacity = (Float(scrollView.contentOffset.y + view.safeAreaInsets.top)) / 20
        })
    }
}
