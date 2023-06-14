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

    private var containerViewWidth: CGFloat {
        view.bounds.width - (view.safeAreaInsets.left + view.safeAreaInsets.right)
    }

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
            button.setTitle("Button \(i)\((0..<Int.random(in: 0..<5)).map { "\($0)"})", for: .normal)
            button.addTarget(self, action: #selector(didTapbutton), for: .touchUpInside)
            button.sizeToFit()
            headerView.addSubview(button)
            buttons.append(button)
        }
        updateContent()
    }

    override func viewDidLayoutSubviews() {
        let topMargin = view.safeAreaInsets.top
        let bottomMargin = view.safeAreaInsets.bottom
        let viewWidth = containerViewWidth
        let minX = view.safeAreaInsets.left
        let headerViewHeight: CGFloat = 44
        headerView.frame = CGRectMake(minX, topMargin, viewWidth, headerViewHeight)

        var totalWidth: CGFloat = 0
        buttons.forEach { button in
            button.sizeToFit()
            let width = button.bounds.width
            button.frame = CGRectMake(totalWidth, 0, width, headerViewHeight)
            totalWidth += width
        }
        headerView.contentSize = CGSizeMake(totalWidth, headerViewHeight)

        if totalWidth <= viewWidth {
            let width = viewWidth / CGFloat(buttons.isEmpty ? 1 : buttons.count)
            buttons.enumerated().forEach { index, button in
                button.frame = CGRectMake(width * CGFloat(index), 0, width, headerViewHeight)
            }
            headerView.contentSize = CGSizeMake(viewWidth, headerViewHeight)
        }

        markerView.frame = CGRectMake(0, 39, buttons.first?.bounds.width ?? viewWidth, 5)

        print("safeArea", view.safeAreaInsets)
        let containerViewMargin = topMargin + headerViewHeight + bottomMargin
        containerView.frame = CGRectMake(minX, topMargin + headerViewHeight, viewWidth, view.bounds.height - containerViewMargin)
        containerView.contentSize = CGSizeMake(CGFloat(controllers.count) * viewWidth, view.bounds.height - containerViewMargin)
        controllers.enumerated().forEach { index, vc in
            vc.view.frame = CGRectMake(CGFloat(index) * containerView.bounds.width, 0, containerView.bounds.width, containerView.bounds.height)
        }
    }

    func updateContent() {
        if selectedIndex == previousIndex { return }
        let f = buttons[selectedIndex].frame
        markerView.frame = CGRectMake(f.minX, 39, f.width, 5)
        var centerXOffset = f.minX - abs(containerViewWidth - f.width) * 0.5
        let maxCenterXOffset = headerView.contentSize.width - containerViewWidth
        if centerXOffset < 0 {
            centerXOffset = 0
        } else if centerXOffset > maxCenterXOffset, maxCenterXOffset >= 0 {
            centerXOffset = maxCenterXOffset
        }
        headerView.setContentOffset(.init(x: centerXOffset, y: 0), animated: true)
        print(centerXOffset)
        print("contentSize.width", headerView.contentSize.width)
        previousIndex = selectedIndex
    }

    @objc private func didTapbutton(_ target: UIButton) {
        guard let index = buttons.firstIndex(of: target) else {
            return
        }
        let offset = CGPoint(x: CGFloat(index) * containerViewWidth, y: 0)
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

