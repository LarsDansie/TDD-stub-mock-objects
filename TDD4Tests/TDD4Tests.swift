//
//  TDD4Tests.swift
//  TDD4Tests
//
//  Created by Lars Dansie on 1/31/24.
//

import XCTest
@testable import TDD4

final class TDD4Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

}

//Fake Object
protocol ArcadeGameManager {
    func fetchAllGames(completion: (Data?) -> Void)
}

class FakeGameLibrary: ArcadeGameManager {
    func fetchAllGames(completion: (Data?) -> Void) {
        completion(nil)
    }
}

class StubGameLibrary: ArcadeGameManager {
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func fetchAllGames(completion: (Data?) -> Void) {
        let data = Data()
        completion(data)
    }
}

class MockGameLibrary: ArcadeGameManager {
    var fetchAllGamesCalled = false
    
    func fetchAllGames(completion: (Data?) -> Void) {
        fetchAllGamesCalled = true
    }
    
    
}

class ArcadeGames {
    private let arcadeGameManager: ArcadeGameManager
    
    init(arcadeGameManager: ArcadeGameManager) {
        self.arcadeGameManager = arcadeGameManager
    }
    
    func fetchGames(completion: @escaping (Data?) -> Void) {
        arcadeGameManager.fetchAllGames { data in
            completion(data)
        }
    }
}


class testFakeGameLibrary: XCTestCase {
    
    func testFakeGameLibrary() {
        let fakeGameLibrary = FakeGameLibrary()
        let arcadeGames = ArcadeGames(arcadeGameManager: fakeGameLibrary)
        var completionData: Data?
        
        arcadeGames.fetchGames { data in
            completionData = data
        }
        
        XCTAssertNil(completionData)
    }
    
    func testStubGameLibrary() {
        let data = Data()
        let stubGameLibrary = StubGameLibrary(data: data)
        let arcadeGames = ArcadeGames(arcadeGameManager: stubGameLibrary)
        var completionData: Data?
        
        arcadeGames.fetchGames { data in
            completionData = data
        }
        
        XCTAssertEqual(completionData, data)
    }
    
    func testMockGameLibrary() {
        let mockGameLibrary = MockGameLibrary()
        let arcadeGames = ArcadeGames(arcadeGameManager: mockGameLibrary)
        
        arcadeGames.fetchGames { _ in }
        
        XCTAssertTrue(mockGameLibrary.fetchAllGamesCalled)
    }
    
}
