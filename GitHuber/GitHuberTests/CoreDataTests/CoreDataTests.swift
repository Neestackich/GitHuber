//
//  CoreDataTests.swift
//  GitHuberTests
//
//  Created by Vittcal Neestackich on 10.10.22.
//

import XCTest
@testable import GitHuber

final class CoreDataTests: XCTestCase {

    private var testCoreDataStack: TestCoreDataStack!
    private var databaseService: DatabaseServiceType!

    private var testUser1 = User(
        login: "Test1", id: 1, nodeId: "", avatarUrl: "", gravatarId: "",
        url: "", htmlUrl: "", followersUrl: "", followingUrl: "", gistsUrl: "",
        starredUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "",
        eventsUrl: "", receivedEventsUrl: "", type: .user, siteAdmin: false)
    private var testUser2 = User(
        login: "Test2", id: 2, nodeId: "", avatarUrl: "", gravatarId: "",
        url: "", htmlUrl: "", followersUrl: "", followingUrl: "", gistsUrl: "",
        starredUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "",
        eventsUrl: "", receivedEventsUrl: "", type: .user, siteAdmin: false)
    private var testUser1Profile = UserProfile(
        login: "Test1", id: 1, nodeId: "", avatarUrl: "", gravatarId: "",
        url: "", htmlUrl: "", followersUrl: "", followingUrl: "", gistsUrl: "",
        starredUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "",
        eventsUrl: "", receivedEventsUrl: "", type: .user, siteAdmin: false,
        name: "Test Name", company: "", blog: "", location: "",
        email: "", hireable: "", bio: "", twitterUsername: "",
        publicRepos: 0, publicGists: 1, followers: 1, following: 1,
        createdAt: "", updatedAt: "")
    private var tsetUsers: [User]!

    override func setUp() {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        let testContext = testCoreDataStack.persistentContainer.newBackgroundContext()
        databaseService = DatabaseService(readContext: testContext, writeContext: testContext)
        tsetUsers = [testUser1, testUser2]
    }

    override func tearDown() {
        super.tearDown()
        testCoreDataStack = nil
        databaseService = nil
        tsetUsers = nil
    }

}

// MARK: - Tests

extension CoreDataTests {

    func test_WhenSaveUser_Called_ShouldSave() {
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                XCTAssertEqual(1, fetchedUsers.count)
                XCTAssertEqual(self?.testUser1.login, fetchedUsers.first?.login)
            case .failure(_):
                break
            }
        }
    }

    func test_WhenSaveUser_Called_ShouldUpdate() {
        databaseService.saveUser(testUser1)
        testUser1 = User(
            login: "New login", id: 1, nodeId: "", avatarUrl: "", gravatarId: "",
            url: "", htmlUrl: "", followersUrl: "", followingUrl: "", gistsUrl: "",
            starredUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "",
            eventsUrl: "", receivedEventsUrl: "", type: .user, siteAdmin: false)
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                XCTAssertEqual(self?.testUser1.login, fetchedUsers.first?.login)
            case .failure(_):
                break
            }
        }
    }

    func test_WhenGetUsers_Called_ShouldGet() {
        databaseService.saveUser(testUser1)
        databaseService.saveUser(testUser2)
        databaseService.getUsers { result in
            switch result {
            case .success(let fetchedUsers):
                XCTAssertEqual(2, fetchedUsers.count)
            case .failure(_):
                break
            }
        }
    }

    func test_WhenGetUser_Called_ShouldGet() {
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                guard let fetchedUser = fetchedUsers.first else { return }
                
                self?.databaseService.getUser(fetchedUser) { result in
                    switch result {
                    case .success(let fetchedUser):
                        XCTAssertEqual(self?.testUser1.login, fetchedUser.login)
                    case .failure(_):
                        break
                    }
                }
            case .failure(_):
                break
            }
        }
    }

    func test_WhenSaveNote_Called_ShouldSave() {
        let noteText = "Note Text"
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                guard let fetchedUser = fetchedUsers.first else { return }

                self?.databaseService.saveNote(for: fetchedUser, text: noteText)
                XCTAssertEqual(fetchedUser.note?.text, noteText)
            case .failure(_):
                break
            }
        }
    }

    func test_WhenSaveNote_Called_ShouldUpdate() {
        let noteText = "Note Text"
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                guard let fetchedUser = fetchedUsers.first else { return }

                self?.databaseService.saveNote(for: fetchedUser, text: noteText)
                let newNote = "New note"
                self?.databaseService.saveNote(for: fetchedUser, text: newNote)
                XCTAssertEqual(fetchedUser.note?.text, newNote)
            case .failure(_):
                break
            }
        }
    }

    func test_WhenSave_UserProfile_Called_ShouldSave() {
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                guard let fetchedUser = fetchedUsers.first, let testUser1Profile = self?.testUser1Profile else { return }
                self?.databaseService.saveUserProfile(for: fetchedUser, profileData: testUser1Profile)
                XCTAssertEqual(fetchedUser.profile?.name, testUser1Profile.name)
            case .failure(_):
                break
            }
        }
    }

    func test_WhenSave_UserProfile_Called_ShouldUpdate() {
        databaseService.saveUser(testUser1)
        databaseService.getUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                guard let fetchedUser = fetchedUsers.first, let testUser1Profile = self?.testUser1Profile else { return }
                self?.databaseService.saveUserProfile(for: fetchedUser, profileData: testUser1Profile)
                var newTestUser1Profile = UserProfile(
                    login: "Test1", id: 1, nodeId: "", avatarUrl: "", gravatarId: "",
                    url: "", htmlUrl: "", followersUrl: "", followingUrl: "", gistsUrl: "",
                    starredUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "",
                    eventsUrl: "", receivedEventsUrl: "", type: .user, siteAdmin: false,
                    name: "Updated test name", company: "", blog: "", location: "",
                    email: "", hireable: "", bio: "", twitterUsername: "",
                    publicRepos: 0, publicGists: 1, followers: 1, following: 1,
                    createdAt: "", updatedAt: "")
                self?.databaseService.saveUserProfile(for: fetchedUser, profileData: newTestUser1Profile)
                XCTAssertEqual(fetchedUser.profile?.name, newTestUser1Profile.name)
            case .failure(_):
                break
            }
        }
    }

}
