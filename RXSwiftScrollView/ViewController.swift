//
//  ViewController.swift
//  RXSwiftScrollView
//
//  Created by Norihiko Oba on 2019/01/15.
//  Copyright © 2019 Norihiko Oba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var scrollView: UIScrollView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageWidth = UIScreen.main.bounds.width
        let pageHeight = scrollView.bounds.height
        let colors: [UIColor] = [
            .red, .green, .blue
        ]
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(colors.count), height: pageHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        colors.enumerated().forEach { index, color in
            let page = UIView()
            let offset = CGFloat(index) * pageWidth
            scrollView.addSubview(page)
            page.backgroundColor = color
            page.snp.makeConstraints { make in
                make.top.equalTo(scrollView)
                make.left.equalTo(scrollView).offset(offset)
                make.height.equalTo(scrollView)
                make.width.equalTo(pageWidth)
            }
        }
        
        Observable.just(colors.count)
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: bag)
        
        scrollView.rx.didScroll
            .withLatestFrom(scrollView.rx.contentOffset)
            .map { Int(round($0.x / pageWidth)) }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: bag)
    }
}

