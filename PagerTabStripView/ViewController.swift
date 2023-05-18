import UIKit

class ViewController: UIViewController {

    private let headerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceHorizontal = true

        return scrollView
    }()
    private let markerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green

        return view
    }()
    private var buttons: [UIButton] = []

    private let containerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .purple
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true

        return scrollView
    }()

  private var controllers: [UIViewController] = {
    [UIColor.red, UIColor.blue, UIColor.green].map {
      let vc = UIViewController()
      vc.view.backgroundColor = $0
      return vc
    }
  }()
    private var selectedIndex: Int {
        let offset = containerView.contentOffset
        guard containerView.bounds.width > 0 else { return 0 }
        return Int(offset.x / containerView.bounds.width)
    }
    enum Direction {
        case left
        case right
        case none
    }
    private var draggingDirection: Direction {
        guard let previousContentOffset else { return .none }
        if containerView.contentOffset.x == previousContentOffset.x {
            return .none
        } else {
            return containerView.contentOffset.x > previousContentOffset.x ? .right : .left
        }
    }
    private var previousContentOffset: CGPoint?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
      super.init(coder: coder)
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        headerView.addSubview(markerView)
        view.addSubview(containerView)
        containerView.delegate = self
        controllers.forEach { vc in
            vc.willMove(toParent: self)
            addChild(vc)
            containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        for i in 0..<controllers.count {
            let button = UIButton(type: .system)
            button.setTitle("Button \(i)", for: .normal)
            button.sizeToFit()
            headerView.addSubview(button)
            buttons.append(button)
        }
        updateContent()
    }

  override func viewDidLayoutSubviews() {
      headerView.frame = CGRectMake(0, 0, containerView.bounds.width, 44)
      var totalWidth: CGFloat = 0
      buttons.forEach { button in
          let width = button.bounds.width
          button.frame = CGRectMake(totalWidth, 0, width, 44)
          totalWidth += width
      }
      headerView.contentSize = CGSizeMake(totalWidth, 44)
      markerView.frame = CGRectMake(0, 39, buttons[0].bounds.width, 5)

      containerView.frame = CGRectMake(0, 44, view.bounds.width, view.bounds.height - 44)
      containerView.contentSize = CGSizeMake(CGFloat(controllers.count) * view.bounds.width, view.bounds.height - 44)
      controllers.enumerated().forEach { index, vc in
          vc.view.frame = CGRectMake(CGFloat(index) * containerView.bounds.width, 0, containerView.bounds.width, containerView.bounds.height)
      }

  }

  func updateContent() {
      print(selectedIndex)
      print(draggingDirection)
      // ここで全てのレイアウトをする
      markerView.frame = CGRectMake(CGFloat(100 * selectedIndex), 39, buttons[0].bounds.width, 5)
  }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateContent()
        print(scrollView.contentOffset)
        previousContentOffset = scrollView.contentOffset
    }
}

import SwiftUI

struct Abc: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> ViewController {
    ViewController()
  }
  
  func updateUIViewController(_ uiViewController: ViewController, context: Context) {
  }
  
  typealias UIViewControllerType = ViewController
}

struct Abc_Previews: PreviewProvider {
  static var previews: some View {
    Abc()
  }
}

