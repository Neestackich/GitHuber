//
//  UserProfileViewModelTests.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber
import CoreData

final class UserProfileViewModelTests: XCTestCase {

    private var mockCoordinator: MockUserProfileCoordinator!
    private var decoder: JSONDecoder!
    private var apiConfig: APIConfig!
    private var mockAPIClient: MockAPIClient!
    private var mockFileManager: MockFileSystemManager!
    private var mockDatabaseService: MockDatabaseService!
    private var mockConnectionListener: MockNetworkConnectionListener!
    private var sut: UserProfileViewModel!
    private var coreDataStack: TestCoreDataStack!
    private var testContext: NSManagedObjectContext!

    private var userEntity: UserEntity!

    override func setUp() {
        super.setUp()

        mockCoordinator = MockUserProfileCoordinator(navigationController: UINavigationController())
        decoder = JSONDecoder()
        apiConfig = APIConfig()
        mockAPIClient = MockAPIClient()
        mockFileManager = MockFileSystemManager()
        coreDataStack = TestCoreDataStack()
        testContext = coreDataStack.persistentContainer.newBackgroundContext()
        mockDatabaseService = MockDatabaseService(testContext: testContext)
        mockConnectionListener = MockNetworkConnectionListener()
        userEntity = UserEntity(context: testContext)
        userEntity.avatarUrl = "http/test/avatar"
        userEntity.login = "test"
        let indexPath = IndexPath(row: 0, section: 0)

        sut = UserProfileViewModel(userEntity: userEntity, indexPath: indexPath, coordinator: mockCoordinator, decoder: decoder, apiClient: mockAPIClient, apiConfig: apiConfig, databaseService: mockDatabaseService, fileManager: mockFileManager, networkConnectionListener: mockConnectionListener)
    }

    override func tearDown() {
        super.tearDown()

        mockCoordinator = nil
        decoder = nil
        apiConfig = nil
        mockAPIClient = nil
        mockFileManager = nil
        coreDataStack = nil
        mockDatabaseService = nil
        mockConnectionListener = nil
        sut = nil
        userEntity = nil
    }

}

// MARK: - Tests

extension UserProfileViewModelTests {

    func test_OnViewDidLoad_ShouldStart_NetworkConnection_Monitoring() {
        XCTAssertFalse(mockConnectionListener.startMonitoringCalled)
        sut.onViewDidLoad()
        XCTAssertTrue(mockConnectionListener.startMonitoringCalled)
    }

    func test_OnInterrupted_InternetConnection_ShouldCall_HandleOfflineMode() {
        XCTAssertFalse(mockConnectionListener.delegateHandleOfflineModeCalled)
        mockConnectionListener.networkConnectionExists = false
        sut.onViewDidLoad()
        XCTAssertTrue(mockConnectionListener.delegateHandleOfflineModeCalled)
    }

    func test_OnEstableshed_InternetConnection_ShouldCall_HandleOnlineMode() {
        XCTAssertFalse(mockConnectionListener.delegateHandleOnlineModeCalled)
        mockConnectionListener.networkConnectionExists = true
        sut.onViewDidLoad()
        XCTAssertTrue(mockConnectionListener.delegateHandleOnlineModeCalled)
    }

    func test_OnViewDidLoad_ShouldCheck_IfFileExists() {
        XCTAssertFalse(mockFileManager.fileExistsCalled)
        sut.onViewDidLoad()
        XCTAssertTrue(mockFileManager.fileExistsCalled)
    }

    func test_OnViewDidLoad_ShouldLoad_AvatarFromFileManager_IfExists() {
        mockFileManager.fileExists = true
        XCTAssertFalse(mockFileManager.getFileFromCacheCalled)
        sut.onViewDidLoad()
        XCTAssertTrue(mockFileManager.getFileFromCacheCalled)
    }

    func test_OnViewDidLoad_ShouldLoad_UserFromBackend() {
        XCTAssertFalse(mockAPIClient.sendRequestToQueueCalled)
        sut.onViewDidLoad()
        XCTAssertTrue(mockAPIClient.sendRequestToQueueCalled)
    }

    func test_OnSaveNoteTap_ShouldSaveNote_ToDatabase() {
        XCTAssertFalse(mockDatabaseService.saveNoteCalled)
        sut.saveNoteButtonClick(text: "test")
        XCTAssertTrue(mockDatabaseService.saveNoteCalled)
        XCTAssertEqual("test", mockDatabaseService.text)
    }

}
