import UIKit

class ViewController: UIViewController {

    private let headerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceHorizontal = true

        return scrollView
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

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
      super.init(coder: coder)
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
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

      containerView.frame = CGRectMake(0, 44, view.bounds.width, view.bounds.height - 44)
      containerView.contentSize = CGSizeMake(CGFloat(controllers.count) * view.bounds.width, view.bounds.height - 44)
      controllers.enumerated().forEach { index, vc in
          vc.view.frame = CGRectMake(CGFloat(index) * containerView.bounds.width, 0, containerView.bounds.width, containerView.bounds.height)
      }

  }

  func updateContent() {
    // ここで全てのレイアウトをする
  }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      updateContent()
        print(scrollView.contentOffset)
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

