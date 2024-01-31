//
//  PendingOrderListDelegate.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/12.
//

import UIKit

class PendingOrderListDelegate: NSObject, OrderListDelegate {

    var dataList: [OrderDetailInfo]
    private(set) var viewController: OrderListViewController?
    var scrollDelegate: ((UIScrollView) -> Void)?

    private override init() {
        self.dataList = []
        super.init()
    }

    init(with dataList: [OrderDetailInfo]) {
        self.dataList = dataList
        super.init()
    }

    func update(viewController: OrderListViewController) {
        self.viewController = viewController
        guard let tableView = viewController.orderListView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension PendingOrderListDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: OrderListTableViewCell.cellIdentifier) else {
            return UITableViewCell()
        }


        if let cell = cell as? OrderListTableViewCell,
           let dataInfo = self.dataList[safe: indexPath.row] {
            cell.updateUI(with: dataInfo)
        }
        return cell
    }
}

extension PendingOrderListDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let viewController = self.viewController,
              let dataInfo = self.dataList[safe: indexPath.row] else { return }

        viewController.performSegue(withIdentifier:
                                        OrderListViewController.SegueIdentifier.goToOrderDetail,
                                    sender: dataInfo.id)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?(scrollView)
    }
}
