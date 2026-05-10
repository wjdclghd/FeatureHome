//
//  HomeView.swift
//  FeatureHome
//
//  Created by jch on 4/28/26.
//

import SwiftUI
import DesignSystem

/// AppStore 검색 진입을 제공하는 Home root 화면입니다.
public struct HomeView<Coordinator: HomeCoordinatorProtocol>: View {

    @StateObject private var viewModel: HomeViewModel<Coordinator>

    // MARK: - Init

    /// HomeView를 생성합니다.
    ///
    /// - Parameter viewModel: Home 화면 Intent를 관리하는 ViewModel입니다.
    public init(viewModel: HomeViewModel<Coordinator>) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
//                header
                searchEntry
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.lg)
        }
        .background(DSColor.background)
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("home.screen")
    }
}

// MARK: - Private

private extension HomeView {
//    var header: some View {
//        VStack(alignment: .leading, spacing: DSSpacing.xs) {
//            Text("AppStore")
//                .font(DSTypography.title1)
//                .foregroundStyle(DSColor.textPrimary)
//
//            Text("필요한 앱을 빠르게 찾아보세요")
//                .font(DSTypography.body2)
//                .foregroundStyle(DSColor.textSecondary)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }

    var searchEntry: some View {
        Button {
            viewModel.searchBarTapped()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                DSIcon.magnifyingglass
                    .resizable()
                    .scaledToFit()
                    .frame(width: DSIconSize.lg, height: DSIconSize.lg)
                    .foregroundStyle(DSColor.textSecondary)

                Text("앱 이름, 기능, 카테고리 검색")
                    .font(DSTypography.body1)
                    .foregroundStyle(DSColor.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                Spacer(minLength: DSSpacing.sm)
            }
            .padding(.horizontal, DSSpacing.md)
            .frame(height: 52)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSCornerRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: DSCornerRadius.sm)
                    .stroke(DSColor.outline.opacity(0.35), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("AppStore 검색")
        .accessibilityIdentifier("home.search.entry")
    }
}
