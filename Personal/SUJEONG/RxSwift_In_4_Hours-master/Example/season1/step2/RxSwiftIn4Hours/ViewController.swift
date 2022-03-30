//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func exJust1() {
        // just의 인자가 그대로(통째로) subscribe의 첫번째 인자로 넘어감
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .single()
            .subscribe { event in
                switch event {
                case .next(let str):
                    print("next: \(str)")
                case .error(let err):
                    print("error: \(err.localizedDescription)")
                case .completed:
                    print("completed")
                }
            }
            .disposed(by: disposeBag)
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        // from으로 배열을 넘기면 하나씩 넘겨줌
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { s in
                print(s)
            }, onError: { err in
                print(err.localizedDescription)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        // just + map 적용
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        // from + map 적용
        Observable.from(["with", "kiki"]) // stream
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        // from + filter
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        Observable.just("800x600")
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) } //URL?
            .filter { $0 != nil }
            .map { $0! } //URL!
            .map { try Data(contentsOf: $0) }
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
