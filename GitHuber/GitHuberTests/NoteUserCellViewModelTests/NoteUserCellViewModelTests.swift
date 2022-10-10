//
//  NoteUserCellViewModelTests.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber
import CoreData

final class NoteUserCellViewModelTests: XCTestCase {

    private var mockAPIClient: MockAPIClient!
    private var mockFileManager: MockFileSystemManager!
    private var sut: NoteUserCellViewModel!
    private var coreDataStack: TestCoreDataStack!
    private var testContext: NSManagedObjectContext!

    private var userEntity: UserEntity!

    override func setUp() {
        super.setUp()

        mockAPIClient = MockAPIClient()
        mockFileManager = MockFileSystemManager()
        coreDataStack = TestCoreDataStack()
        testContext = coreDataStack.persistentContainer.newBackgroundContext()
        userEntity = UserEntity(context: testContext)
        userEntity.avatarUrl = "http/test/avatar"

        sut = NoteUserCellViewModel(userEntity: userEntity, apiClient: mockAPIClient, fileManager: mockFileManager)
    }

    override func tearDown() {
        super.tearDown()

        mockAPIClient = nil
        mockFileManager = nil
        coreDataStack = nil
        testContext = nil
        sut = nil
    }

}

// MARK: - Tests

extension NoteUserCellViewModelTests {

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
