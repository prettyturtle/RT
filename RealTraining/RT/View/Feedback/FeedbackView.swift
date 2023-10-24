//
//  FeedbackView.swift
//  RealTraining
//
//  Created by yc on 2023/09/30.
//

import UIKit
import SnapKit
import Then

protocol FeedbackViewDelegate: AnyObject {
    func feedbackView(_ fv: FeedbackView, didTapNextButton: UIButton)
}

final class FeedbackView: UIView {
    let studyInfos: [RtQuiz]
    let feedback: RTFeedbackModel
    
    weak var delegate: FeedbackViewDelegate?
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "학습한 문장을 확인해 보세요."
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .left
    }
    
    private lazy var resultTableView = UITableView().then {
        $0.dataSource = self
        $0.register(
            FeedbackResultTableViewCell.self,
            forCellReuseIdentifier: FeedbackResultTableViewCell.identifier
        )
    }
    
    private lazy var retryButton = UIButton().then {
        var titleConfig = AttributeContainer()
        
        titleConfig.font = .systemFont(ofSize: 16, weight: .medium)
        
        var buttonConfig = UIButton.Configuration.plain()
        
        buttonConfig.attributedTitle = AttributedString(
            "다시하기",
            attributes: titleConfig
        )
        buttonConfig.image = UIImage(systemName: "arrow.clockwise")
        buttonConfig.imagePlacement = .leading
        buttonConfig.imagePadding = 8
        buttonConfig.background.backgroundColor = .white
        buttonConfig.baseForegroundColor = .black
        
        $0.configuration = buttonConfig
        $0.layer.borderWidth = 0.4
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.cornerRadius = 6
    }
    
    private lazy var nextButton = UIButton().then {
        var titleConfig = AttributeContainer()
        
        titleConfig.font = .systemFont(ofSize: 16, weight: .medium)
        
        var buttonConfig = UIButton.Configuration.plain()
        
        buttonConfig.attributedTitle = AttributedString(
            "계속하기",
            attributes: titleConfig
        )
        buttonConfig.image = UIImage(systemName: "chevron.right")
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 8
        buttonConfig.background.backgroundColor = .init(
            red: 239 / 255,
            green: 64 / 255,
            blue: 64 / 255,
            alpha: 1
        )
        buttonConfig.baseForegroundColor = .white
        
        $0.configuration = buttonConfig
        $0.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
    }
    
    init(studyInfos: [RtQuiz], feedback: RTFeedbackModel, frame: CGRect) {
        self.studyInfos = studyInfos
        self.feedback = feedback
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapNextButton(_ sender: UIButton) {
        delegate?.feedbackView(self, didTapNextButton: sender)
    }
    
    private func setupLayout() {
        [
            titleLabel,
            resultTableView,
            retryButton,
            nextButton
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(32)
        }
        
        resultTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
        
        retryButton.snp.makeConstraints {
            $0.top.equalTo(resultTableView.snp.bottom).offset(16)
            $0.leading.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        retryButton.snp.contentHuggingHorizontalPriority = 251
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(resultTableView.snp.bottom).offset(16)
            $0.leading.equalTo(retryButton.snp.trailing).offset(8)
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}

extension FeedbackView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedbackResultTableViewCell.identifier,
            for: indexPath
        ) as? FeedbackResultTableViewCell else {
            return UITableViewCell()
        }
        
        cell.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        cell.selectionStyle = .none
        cell.studyInfo = studyInfos[indexPath.row]
        cell.feedback = feedback
        cell.setupView()
        
        return cell
    }
}
