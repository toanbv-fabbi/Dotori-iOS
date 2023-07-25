import UIKit
import UIKitUtil

open class BaseTableViewCell<Model>:
    UITableViewCell,
    AdaptableCell,
    AddViewable,
    SetLayoutable,
    ViewConfigurable {

    public typealias Model = Model
    public var model: Model?

    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setLayout()
        configureView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func addView() {}
    open func setLayout() {}
    open func configureView() {}
    open func adapt(model: Model) {
        self.model = model
    }
}
