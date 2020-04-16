import UIKit


protocol SampleProtocol {
    var mutableVar: String { get set } // zmienna
    var immutableVar: String { get }    // stała/zmienna kalkulowana

    func functionDeliveringNewData() -> String
}

extension SampleProtocol where Self: UIView {
    func functionDeliveringNewData() -> String {
        return "UIVIEW"
    }
}

extension SampleProtocol where Self: UIViewController {
    func functionDeliveringNewData() -> String {
        return "UIVIEWController"
    }
}

class ProtoImpl: UIView, SampleProtocol {
    var title: String
    var mutableVar: String

    var immutableVar: String {
        return ""
    }

    init() {
        title = ""
        mutableVar = ""

        super.init(frame: CGRect())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Weekdays: String {
    static let staticLet = "abc"

    case monday = "Monday", tuesday, wednesday

    var noOfWeekday: Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        }
    }

    func contat(with string: String) -> String {
        "\(self.noOfWeekday) " + string
    }
}

class MyBasicClass {
    static let staticLet = "abc"
    var title: String
    let category: String

    func mutatingFunc() {

    }

    init() {
        title = ""
        category = ""
    }

    init(title: String = "DEFAULT STRING", category: String) {
        self.title = title
        self.category = category
    }
}

let myClassInstance = MyBasicClass(category: "Custom category")
