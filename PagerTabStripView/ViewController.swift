import UIKit

class ViewController: UIViewController {

    private let containerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .brown
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.frameLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: containerView.frameLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.frameLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.frameLayoutGuide.trailingAnchor)
        ])

        controllers = [UIColor.red, UIColor.blue, UIColor.green].map { color in
            let vc = UIViewController()
            vc.view.backgroundColor = color
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vc.view.widthAnchor.constraint(equalToConstant: view.frame.width),
                vc.view.heightAnchor.constraint(equalToConstant: view.frame.height),
            ])
            return vc
        }

        let stackView = UIStackView(arrangedSubviews: controllers.map { $0.view })
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            containerView.contentLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
            containerView.contentLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            containerView.contentLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            containerView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}

extension ViewController: UIPageViewControllerDataSource {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        controllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController),
           index > 0 {
            return controllers[index - 1]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController),
           index < controllers.count - 1 {
            return controllers[index + 1]
        } else {
            return nil
        }
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

