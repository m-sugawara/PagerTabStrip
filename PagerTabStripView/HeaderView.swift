import UIKit

class HeaderView: UIView {

    private let containerView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: containerView.frameLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: containerView.frameLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: containerView.frameLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.frameLayoutGuide.trailingAnchor)
        ])

        buttons = (0...10).map { number in
            let button = UIButton(type: .custom)
            button.setTitle("Button\(number)", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.backgroundColor = .brown
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

import SwiftUI

struct HeaderViewUIPresentetable: UIViewRepresentable {

    typealias UIViewType = HeaderView

    func makeUIView(context: Context) -> HeaderView {
        HeaderView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

}

struct HeaderViewUIPresentetable_Previews: PreviewProvider {
  static var previews: some View {
    HeaderViewUIPresentetable()
  }
}

