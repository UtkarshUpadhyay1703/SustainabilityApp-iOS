//
//  SustainabilityAppTests.swift
//  SustainabilityAppTests
//
//  Created by Utkarsh Upadhyay on 31/10/25.
//

import XCTest
import MapKit

@testable import SustainabilityApp

final class MapSearchServiceTests: XCTestCase {
    var service: MapSearchService!
    
    override func setUp() {
        super.setUp()
        service = MapSearchService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }

    // Test 1: Empty query should return empty result
    func testEmptyQueryReturnsEmptyResults() async throws {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
        
        let results = try await service.search(query: "   ", region: region)
        XCTAssertTrue(results.isEmpty, "Expected empty results for empty query")
    }

    // Test 2: Valid place should return results (non-empty)
    func testSearchForValidPlaceReturnsResults() async throws {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), // NYC
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        
        let results = try await service.search(query: "New York", region: region)
        XCTAssertFalse(results.isEmpty, "Expected some results for 'New York'")
        XCTAssertTrue(results.first?.address != nil || results.first?.location != nil, "Result should have an address or location")
    }
    
    // Test 3: Ensure it doesn’t crash with nil region
    func testSearchWithNilRegion() async throws {
        let results = try await service.search(query: "Paris", region: nil)
        XCTAssertFalse(results.isEmpty, "Expected results even with nil region for 'Paris'")
    }
}

// MARK: - ChatFeatureTests
@MainActor
final class ChatFeatureTests: XCTestCase {
    var chatStorage: ChatStorage!
    var mockService: MockChatService!
    var viewModel: ChatViewModel!

    override func setUp() async throws {
        chatStorage = ChatStorage()
        mockService = MockChatService()
        viewModel = ChatViewModel(service: mockService)
        viewModel.clearHistory() // start clean
    }

    override func tearDown() async throws {
        chatStorage = nil
        mockService = nil
        viewModel = nil
    }

    // Test 1: ChatStorage should save and load messages correctly
    func testChatStorageSaveAndLoad() {
        let messages = [
            Message(text: "Hello", isBot: false, timestamp: Date()),
            Message(text: "Hi there!", isBot: true, timestamp: Date())
        ]

        chatStorage.save(messages)
        let loaded = chatStorage.load()

        XCTAssertEqual(loaded.count, 2, "ChatStorage should load same number of messages saved")
        XCTAssertEqual(loaded.first?.text, "Hello")
        XCTAssertEqual(loaded.last?.isBot, true)
    }

    // Test 2: MockChatService should return proper replies for known keywords
    func testMockChatServiceReturnsExpectedReply() async {
        let reply1 = await mockService.getBotReply(for: "hello there")
        XCTAssertTrue(reply1.lowercased().contains("ora"), "Expected greeting message")

        let reply2 = await mockService.getBotReply(for: "how to start?")
        XCTAssertTrue(reply2.lowercased().contains("start"), "Expected onboarding hint")

        let reply3 = await mockService.getBotReply(for: "help with account")
        XCTAssertTrue(reply3.lowercased().contains("support@"), "Expected account help message")

        let reply4 = await mockService.getBotReply(for: "random text that makes no sense")
        XCTAssertTrue(reply4.contains("not present"), "Expected fallback reply")
    }

    // Test 3: ChatViewModel should append a message and bot reply
    func testChatViewModelSendMessageFlow() async {
        viewModel.inputText = "hello"
        viewModel.send()

        // Wait enough time for async bot reply to complete
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertGreaterThan(viewModel.messages.count, 1, "Expected at least user and bot messages")
        XCTAssertEqual(viewModel.messages.first?.isBot, false, "First appended message should be from user")
        XCTAssertTrue(viewModel.messages.last?.isBot == true, "Last message should be from bot")
    }

    // Test 4: ChatViewModel should not send empty messages
    func testEmptyMessageNotSent() {
        viewModel.inputText = "  "
        viewModel.send()
        XCTAssertTrue(viewModel.messages.isEmpty, "Empty messages should not be added")
    }
}

