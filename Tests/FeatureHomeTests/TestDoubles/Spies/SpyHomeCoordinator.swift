//
//  SpyHomeCoordinator.swift
//  FeatureHomeTests
//
//  Created by jch on 4/28/26.
//

import Foundation
@testable import FeatureHome

/// 테스트에서 Coordinator 호출 횟수를 기록하는 Spy입니다.
final class SpyHomeCoordinator: HomeCoordinatorProtocol {

    private(set) var showSearchCallCount: Int = 0

    func showSearch() {
        showSearchCallCount += 1
    }
}
