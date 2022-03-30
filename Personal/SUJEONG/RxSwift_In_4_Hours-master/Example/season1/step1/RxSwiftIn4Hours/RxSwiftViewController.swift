//
//  RxSwiftViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class RxSwiftViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction

    var disposeBag:DisposeBag = DisposeBag()
    var disposable:Disposable?
    
    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

        rxswiftLoadImage(from: LARGER_IMAGE_URL)
            .observeOn(MainScheduler.instance)
            .subscribe({ result in
                switch result {
                case let .next(image):
                    self.imageView.image = image

                case let .error(err):
                    print(err.localizedDescription)

                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag) // 이렇게 disposeBag에 바로 넣어줄수도 있음
//        disposeBag.insert(disposable!)
    }

    @IBAction func onCancel(_ sender: Any) {
        // TODO: cancel image loading
        // - disposable 한개만 dispose (중지)
        disposable?.dispose()
        
        // - disposeBag에 담겨있는 모든 disposable 중지 : DisposeBag 다시 초기화
        disposeBag = DisposeBag()
    }

    // MARK: - RxSwift

    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        // 여기서는 Observable이라는 객체를 반환. 마찬가지로 비동기를 다루기 쉬운 인터페이스를 제공하는 듯
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
}
