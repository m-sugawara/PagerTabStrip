import UIKit

class ViewController: UIViewController {

    private let containerViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    private var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(containerViewController)
        containerViewController.view.backgroundColor = .brown
        view.addSubview(containerViewController.view)
        containerViewController.didMove(toParent: self)
        containerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: containerViewController.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: containerViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerViewController.view.trailingAnchor)
        ])
        containerViewController.dataSource = self

        controllers = [UIColor.red, UIColor.blue, UIColor.green].map { color in
            let vc = UIViewController()
            vc.view.backgroundColor = color
            return vc
        }
        containerViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
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

