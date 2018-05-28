//
//  SimpleTransferTests.swift
//  WeTransferTests
//
//  Created by Pim Coumans on 22/05/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeTransfer

class AuthorizationTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		TestConfiguration.configure(environment: .live)
	}
	
	override func tearDown() {
		super.tearDown()
		TestConfiguration.resetConfiguration()
	}
	
	func testUnauthorized() {
		do {
			let _ = try WeTransfer.client.createRequest(.createTransfer())
		} catch {
			XCTAssertEqual(error.localizedDescription, APIClient.Error.notAuthorized.localizedDescription)
		}
	}
	
	func testAuthorization() {
		let authorizedExpectation = expectation(description: "Authorization should succeed")
		var receivedToken: String?
		do {
			try WeTransfer.authorize { (result) in
				switch result {
				case .success(let token):
					receivedToken = token
				case .failure(let error):
					XCTFail("Authorization failed: \(error)")
				}
				authorizedExpectation.fulfill()
			}
		} catch {
			XCTFail("Authorization failed: \(error)")
			authorizedExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 10) { (error) in
			XCTAssert(receivedToken != nil, "No token received from authorization call \(String(describing:error))")
		}        
	}
	
}