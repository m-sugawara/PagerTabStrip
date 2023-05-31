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
    let index = Int(round(offset.x / containerView.bounds.width))
    if index > controllers.count - 1 {
      return controllers.count - 1
    } else if index < 0 {
      return 0
    } else {
      return index
    }
  }

  private var previousIndex: Int?

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
            button.setTitle("Button \(i)\((0..<Int.random(in: 0..<10)).map { "\($0)"})", for: .normal)
            button.addTarget(self, action: #selector(didTapbutton), for: .touchUpInside)
            button.sizeToFit()
            headerView.addSubview(button)
            buttons.append(button)
        }
        updateContent()
    }

  override func viewDidLayoutSubviews() {
      let topMargin = view.safeAreaInsets.top
      let headerViewHeight: CGFloat = 44
      headerView.frame = CGRectMake(0, topMargin, view.bounds.width, headerViewHeight)
      var totalWidth: CGFloat = 0
      buttons.forEach { button in
          let width = button.bounds.width
          button.frame = CGRectMake(totalWidth, 0, width, headerViewHeight)
          totalWidth += width
      }
      headerView.contentSize = CGSizeMake(totalWidth, headerViewHeight)
      markerView.frame = CGRectMake(0, 39, buttons[0].bounds.width, 5)

      let containerViewMargin = topMargin + headerViewHeight + view.safeAreaInsets.bottom
      containerView.frame = CGRectMake(0, topMargin + headerViewHeight, view.bounds.width, view.bounds.height - containerViewMargin)
      containerView.contentSize = CGSizeMake(CGFloat(controllers.count) * view.bounds.width, view.bounds.height - containerViewMargin)
      controllers.enumerated().forEach { index, vc in
          vc.view.frame = CGRectMake(CGFloat(index) * containerView.bounds.width, 0, containerView.bounds.width, containerView.bounds.height)
      }
  }

  func updateContent() {
      print("selectedIndex: \(selectedIndex)")
    if selectedIndex == previousIndex { return }
    let f = buttons[selectedIndex].frame
    markerView.frame = CGRectMake(f.minX, 39, f.width, 5)
    headerView.setContentOffset(.init(x: f.minX - abs(view.bounds.width - f.width) * 0.5, y: 0), animated: true)
    previousIndex = selectedIndex
  }

    @objc private func didTapbutton(_ target: UIButton) {
        guard let index = buttons.firstIndex(of: target) else {
            return
        }
        let offset = CGPoint(x: CGFloat(index) * self.view.frame.width, y: 0)
        containerView.setContentOffset(offset, animated: true)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateContent()
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

