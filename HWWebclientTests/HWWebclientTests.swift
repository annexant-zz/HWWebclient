//
//  HWWebclientTests.swift
//  HWWebclientTests
//
//  Created by Andrey on 3/26/19.
//  Copyright © 2019 Andrey. All rights reserved.
//

import XCTest
@testable import HWWebclient

class HWWebclientTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testTest() {
		print("✅")
	}

    func testGet() {


		class TestConfig: HWWebClientConfigInfo {}
		class TestModel: Codable {
			let id, userId: Int
			let title: String
			let completed: Bool
		}

		class TestServiceProvider {
			let url = "https://jsщnplaceholder.typicode.com/todos/1"
			let wc = HWWebClient(TestConfig())

			func testService(onSuccess: @escaping ((TestModel)->Void),
							 onError: ((HWWebClientError) -> Void)?) {

				wc.get(url, success: { (response) in
					_ = self.wc.handleResponseUnwrapped(response,
														modelType: TestModel.self,
														successHandler: onSuccess,
														failureHandler: onError)
				}, failure: onError)

			}
		}



		TestServiceProvider().testService(onSuccess: { (model) in

			let isSuccess = model.id == 1
				&& model.userId == 1
				&& model.title == "delectus aut autem"
				&& model.completed == false

			print(isSuccess ? "✅" : "❌")
			XCTAssert(isSuccess, "Failed to load test model")
		}) { (error) in
			print("❌: \(error)")
			XCTAssert(false, "Failed to load test model with error: \(error)")
		}
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
