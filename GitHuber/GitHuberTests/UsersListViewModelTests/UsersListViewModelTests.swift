//
//  UsersListViewModelTests.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 9.10.22.
//

import XCTest
@testable import GitHuber
import CoreData

final class UsersListViewModelTests: XCTestCase {

    private var mockCoordinator: MockUsersListCoordinator!
    private var decoder: JSONDecoder!
    private var apiConfig: APIConfig!
    private var mockAPIClient: MockAPIClient!
    private var mockFileManager: MockFileSystemManager!
    private var mockDatabaseService: MockDatabaseService!
    private var mockConnectionListener: MockNetworkConnectionListener!
    private var sut: UsersListViewModel!
    private var coreDataStack: TestCoreDataStack!
    private var testContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        mockCoordinator = MockUsersListCoordinator(navigationController: UINavigationController())
        decoder = JSONDecoder()
        apiConfig = APIConfig()
        mockAPIClient = MockAPIClient()
        mockFileManager = MockFileSystemManager()
        coreDataStack = TestCoreDataStack(modelName: "GitHuber")
        testContext = coreDataStack.getReadManagedObjectContext()
        mockDatabaseService = MockDatabaseService(testContext: testContext)
        mockConnectionListener = MockNetworkConnectionListener()

        sut = UsersListViewModel(coordinator: mockCoordinator, decoder: decoder, apiClient: mockAPIClient, networkConnectionListener: mockConnectionListener, apiConfig: apiConfig, databaseService: mockDatabaseService, fileManager: mockFileManager)
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
        testContext = nil
        sut = nil
    }

}

// MARK: - Tests

extension UsersListViewModelTests {

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

    func test_OnViewDidLoad_ShouldLoad_UsersFromBackend() {
        XCTAssertFalse(mockAPIClient.sendRequestToQueueCalled)
        sut.onViewDidLoad()
        XCTAssertTrue(mockAPIClient.sendRequestToQueueCalled)
    }

    func test_OnViewDidLoad_ShouldLoad_UsersFromDatabase() {
        XCTAssertFalse(mockDatabaseService.getUsersCalled)
        sut.onViewDidLoad()
        XCTAssertTrue(mockDatabaseService.getUsersCalled)
    }

    func test_OnCellTap_ShouldCall_Coordinator() {
        sut.onViewDidLoad()
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertFalse(mockCoordinator.userCellTapCalled)
        sut.userCellTap(didSelectRowAt: indexPath)
        XCTAssertTrue(mockCoordinator.userCellTapCalled)
    }

    func test_OnCellTap_ShouldNotCall_Coordinator_IfUsersAreEmpty() {
        mockDatabaseService.usersEmpty = true
        sut.onViewDidLoad()

        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertFalse(mockCoordinator.userCellTapCalled)
        sut.userCellTap(didSelectRowAt: indexPath)
        XCTAssertFalse(mockCoordinator.userCellTapCalled)
    }

    func test_OnPagination_ShouldLoad_UsersFromBackend() {
        XCTAssertFalse(mockAPIClient.sendRequestToQueueCalled)
        sut.onViewDidLoad()
        sut.paginate()
        XCTAssertTrue(mockAPIClient.sendRequestToQueueCalled)
    }

}

