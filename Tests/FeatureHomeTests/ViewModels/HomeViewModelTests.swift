//
//  HomeViewModelTests.swift
//  FeatureHomeTests
//
//  Created by jch on 4/28/26.
//

import XCTest
@testable import FeatureHome

/// `HomeViewModel`의 Intent와 Coordinator 호출 흐름을 검증합니다.
final class HomeViewModelTests: XCTestCase {

    // MARK: - Tests

    @MainActor
    func test_searchBarTapped_callsCoordinatorShowSearch() {
        // given
        let (sut, coordinator) = makeSUT()

        // when
        sut.searchBarTapped()

        // then
        XCTAssertEqual(coordinator.showSearchCallCount, 1)
    }

    @MainActor
    func test_searchBarTapped_calledMultipleTimes_callsCoordinatorExactTimes() {
        // given
        let (sut, coordinator) = makeSUT()

        // when
        sut.searchBarTapped()
        sut.searchBarTapped()
        sut.searchBarTapped()

        // then
        XCTAssertEqual(coordinator.showSearchCallCount, 3)
    }

    // MARK: - Helpers

    @MainActor
    private func makeSUT() -> (
        sut: HomeViewModel<SpyHomeCoordinator>,
        coordinator: SpyHomeCoordinator
    ) {
        let coordinator = SpyHomeCoordinator()
        let sut = HomeViewModel(coordinator: coordinator)
        return (sut, coordinator)
    }
}
