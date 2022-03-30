//
//  PromiseViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import PromiseKit
import UIKit

class PromiseViewController: UIViewController {
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

    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

        promiseLoadImage(from: LARGER_IMAGE_URL)
            .done { image in
                self.imageView.image = image
            }.catch { error in
                print(error.localizedDescription)
            }
    }

    // MARK: - PromiseKit

    func promiseLoadImage(from imageUrl: String) -> Promise<UIImage?> {
        // 이미지 다운로드가 완료되면 Promise 객체를 반환 -> Promise 객체가 이미지 다운로드 관련 처리에 대한 쉬운 인터페이스를 제공
        return Promise<UIImage?>() { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.fulfill(image) // 이미지가 다운로드 되면, seal에 fulfill 메서드를 통해 이미지를 전달한다.
            }
        }
    }
}
