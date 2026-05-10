//
//  HomeCoordinatorProtocol.swift
//  FeatureHome
//
//  Created by jch on 4/28/26.
//

import Foundation

/// Home 화면에서 App 레이어로 전달하는 화면 이동 계약입니다.
///
/// FeatureHome은 검색 화면 진입만 요청하고, 실제 검색 화면 생성과 결과 화면 이동은 App 레이어가 처리합니다.
@MainActor
public protocol HomeCoordinatorProtocol: AnyObject {
    /// AppStore 검색 진입 화면 이동을 요청합니다.
    func showSearch()
}
