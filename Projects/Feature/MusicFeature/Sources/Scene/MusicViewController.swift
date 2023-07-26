import BaseFeature
import CombineUtility
import DesignSystem
import MSGLayout
import MusicDomainInterface
import UIKit
import UIKitUtil

final class MusicViewController: BaseStoredViewController<MusicStore> {
    private let musicNavigationBarLabel = DotoriNavigationBarLabel(text: "기상음악 신청")
    private let calendarBarButton = UIBarButtonItem(
        image: .Dotori.calendar.tintColor(color: .dotori(.neutral(.n20)))
    )
    public let newMusicButton = UIBarButtonItem(
        image: .Dotori.plus.tintColor(color: .dotori(.neutral(.n20)))
    )
    private let musicTableView = UITableView()
        .set(\.backgroundColor, .dotori(.background(.card)))
        .set(\.separatorStyle, .none)
        .set(\.cornerRadius, 16)
        .set(\.sectionHeaderHeight, 0)
        .set(\.contentInset, .init(top: 8, left: 0, bottom: 0, right: 0))
        .set(\.showsVerticalScrollIndicator, false)
        .then {
            $0.register(cellType: MusicCell.self)
        }
    private let musicRefreshControl = UIRefreshControl()
    private lazy var musicTableAdapter = TableViewAdapter<GenericSectionModel<MusicModel>>(
        tableView: musicTableView
    ) { tableView, indexPath, item in
        let cell: MusicCell = tableView.dequeueReusableCell(for: indexPath)
        cell.adapt(model: item)
        return cell
    }

    override func addView() {
        view.addSubviews {
            musicTableView
        }
        musicTableView.refreshControl = musicRefreshControl
    }

    override func setLayout() {
        MSGLayout.buildLayout {
            musicTableView.layout
                .horizontal(.toSuperview(), .equal(20))
                .vertical(.to(view.safeAreaLayoutGuide), .equal(16))
        }
    }

    override func configureNavigation() {
        self.navigationItem.setLeftBarButton(musicNavigationBarLabel, animated: true)
        self.navigationItem.setRightBarButtonItems([newMusicButton, calendarBarButton], animated: true)
    }

    override func bindAction() {
        viewDidLoadPublisher
            .map { Store.Action.viewDidLoad }
            .sink(receiveValue: store.send(_:))
            .store(in: &subscription)

        musicRefreshControl.controlPublisher(for: .valueChanged)
            .map { _ in Store.Action.refresh }
            .sink(receiveValue: store.send(_:))
            .store(in: &subscription)
    }

    override func bindState() {
        let sharedState = store.state.share()
            .receive(on: DispatchQueue.main)

        sharedState
            .map(\.musicList)
            .map { [GenericSectionModel(items: $0)] }
            .sink(receiveValue: musicTableAdapter.updateSections(sections:))
            .store(in: &subscription)
    }
}
