//
//  InvertedUserCellViewModelTests.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber
import CoreData

final class InvertedUserCellViewModelTests: XCTestCase {

    private var mockAPIClient: MockAPIClient!
    private var mockFileManager: MockFileSystemManager!
    private var imageInverter: MockImageInversion!
    private var sut: InvertedUserCellViewModel!
    private var coreDataStack: TestCoreDataStack!
    private var testContext: NSManagedObjectContext!

    private var userEntity: UserEntity!

    override func setUp() {
        super.setUp()

        mockAPIClient = MockAPIClient()
        mockFileManager = MockFileSystemManager()
        imageInverter = MockImageInversion()
        coreDataStack = TestCoreDataStack()
        testContext = coreDataStack.getManagedObjectContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserEntity", in: testContext)
        userEntity = UserEntity(entity: entityDescription!, insertInto: testContext)
        userEntity.avatarUrl = "http/test/avatar"

        sut = InvertedUserCellViewModel(userEntity: userEntity, apiClient: mockAPIClient, fileManager: mockFileManager, imageInverter: imageInverter)
    }

    override func tearDown() {
        super.tearDown()

        mockAPIClient = nil
        mockFileManager = nil
        imageInverter = nil
        coreDataStack = nil
        testContext = nil
        sut = nil
    }

}

// MARK: - Tests

extension InvertedUserCellViewModelTests {

    func test_OnAwakeFromNib_ShouldCheck_IfFileExists() {
        XCTAssertFalse(mockFileManager.fileExistsCalled)
        sut.onAwakeFromNib()
        XCTAssertTrue(mockFileManager.fileExistsCalled)
    }

    func test_OnAwakeFromNib_ShouldLoad_AvatarFromFileManager_IfExists() {
        mockFileManager.fileExists = true
        XCTAssertFalse(mockFileManager.getFileFromCacheCalled)
        sut.onAwakeFromNib()
        XCTAssertTrue(mockFileManager.getFileFromCacheCalled)
    }

    func test_OnAwakeFromNib_ShouldLoad_AvatarFromBackend() {
        XCTAssertFalse(mockAPIClient.sendRequestToQueueCalled)
        sut.onAwakeFromNib()
        XCTAssertTrue(mockAPIClient.sendRequestToQueueCalled)
        XCTAssertEqual(userEntity.avatarUrl, mockAPIClient.endpoint?.path)
    }

}
