//
//  HomeFactory.swift
//  FeatureHome
//
//  Created by jch on 4/28/26.
//

import SwiftUI

/// Home Feature 화면 조립을 담당합니다.
@MainActor
public enum HomeFactory {

    /// Home root 화면을 생성합니다.
    ///
    /// - Parameter coordinator: 화면 이동을 처리하는 Coordinator입니다.
    /// - Returns: 조립이 완료된 `HomeView`입니다.
    public static func makeHomeView<Coordinator: HomeCoordinatorProtocol>(
        coordinator: Coordinator
    ) -> HomeView<Coordinator> {
        let viewModel = HomeViewModel(coordinator: coordinator)
        return HomeView(viewModel: viewModel)
    }
}
