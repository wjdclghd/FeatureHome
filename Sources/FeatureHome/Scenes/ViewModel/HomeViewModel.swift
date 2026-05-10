//
//  HomeViewModel.swift
//  FeatureHome
//
//  Created by jch on 4/28/26.
//

import Foundation

/// Home 화면의 상태와 사용자 Intent를 관리합니다.
@MainActor
public final class HomeViewModel<Coordinator: HomeCoordinatorProtocol>: ObservableObject {

    // MARK: - Dependencies

    private let coordinator: Coordinator

    // MARK: - Init

    /// HomeViewModel을 생성합니다.
    ///
    /// - Parameter coordinator: 화면 이동을 처리하는 Coordinator입니다.
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Intent

    /// 홈 검색바 선택을 처리합니다.
    public func searchBarTapped() {
        coordinator.showSearch()
    }
}
