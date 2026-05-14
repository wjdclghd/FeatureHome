# FeatureHome Module

Clean Architecture + MVVM 환경에서 App 타겟이 SPM 모듈로 의존하는 형태를 전제로 만든 FeatureHome 모듈입니다.
이 모듈은 **홈 화면 진입점(Home Entry Point)** 역할에 집중하며, AppStore 검색 진입 UI를 외부에 직접 노출하지 않고 **공개 계약 + 화면 조립 + 내부 구현체**로 역할을 분리합니다.

모듈 내부는 화면 렌더링, 사용자 Intent 처리, 화면 이동 계약 기능을 포함하며,
상위 계층은 `HomeFactory.makeHomeView(coordinator:)`를 통해 `HomeView`를 즉시 사용할 수 있습니다.

**요약**
- 화면 조립 진입점: `HomeFactory`
- 공개 계약: `Coordinator/HomeCoordinatorProtocol`
- 화면 구성: `Scenes/View/HomeView`, `Scenes/ViewModel/HomeViewModel`
- 의존성: `DesignSystem` (Core/UI)
- 구현 기능: `AppStore 검색 진입 버튼 UI`, `검색 화면 이동 요청`

---

**모듈 구조**
```text
FeatureHome/
├─ Package.swift
├─ Sources/
│  └─ FeatureHome/
│     ├─ Coordinator/
│     │  └─ HomeCoordinatorProtocol.swift
│     ├─ Factory/
│     │  └─ HomeFactory.swift
│     └─ Scenes/
│        ├─ View/
│        │  └─ HomeView.swift
│        └─ ViewModel/
│           └─ HomeViewModel.swift
└─ Tests/
   └─ FeatureHomeTests/
      ├─ ViewModels/
      │  └─ HomeViewModelTests.swift
      └─ TestDoubles/
         └─ Spies/
            └─ SpyHomeCoordinator.swift
```

---

**빠른 시작**

`HomeFactory.makeHomeView(coordinator:)`는 `HomeView`를 즉시 반환합니다.

```swift
import FeatureHome

// Coordinator 기반 (App 레이어에서 HomeCoordinatorProtocol 구현체 전달)
let view = HomeFactory.makeHomeView(coordinator: homeNavigator)
```

App 레이어에서 `HomeCoordinatorProtocol`을 구현하고 HomeNavigator를 주입합니다.

```swift
// App Target — HomeNavigator.swift
@MainActor
final class HomeNavigator: HomeCoordinatorProtocol {
    private let navigator: Navigator<HomeRoute>

    init(navigator: Navigator<HomeRoute>) {
        self.navigator = navigator
    }

    func showSearch() {
        navigator.push(.search)
    }
}
```

RouteBuilder에서 HomeFactory를 static으로 직접 호출합니다.

```swift
// App Target — HomeRouteBuilder.swift
func makeRootView(navigator: HomeNavigator) -> AnyView {
    AnyView(HomeFactory.makeHomeView(coordinator: navigator))
}
```

---

**핵심 설계 방향**

- **외부 공개 계약과 내부 화면 구현 분리**
  상위 계층은 `HomeCoordinatorProtocol`과 `HomeFactory`에만 의존합니다.
  View 내부 레이아웃, ViewModel Intent 처리, DesignSystem 연동 세부 구현은 내부에 감춥니다.

- **조립 지점 통일**
  App 또는 상위 모듈은 `HomeFactory`를 통해 홈 화면을 초기화합니다.
  View와 ViewModel 조립이 같은 Factory 규칙 위에서 동작합니다.

- **기능 책임 분리**
  - 화면 이동 계약: `HomeCoordinatorProtocol`
  - View/ViewModel 조립: `HomeFactory`
  - UI 렌더링: `HomeView`
  - 사용자 Intent 관리: `HomeViewModel`

- **테스트 친화적인 구조**
  ViewModel은 `HomeCoordinatorProtocol` 제네릭 파라미터를 받아 실제 Coordinator 없이 테스트 가능합니다.
  `SpyHomeCoordinator`를 사용해 Coordinator 호출 여부와 횟수를 독립적으로 검증합니다.

---

**HomeCoordinatorProtocol**

`HomeCoordinatorProtocol`은 상위 계층이 구현하는 화면 이동 계약입니다.

```swift
@MainActor
public protocol HomeCoordinatorProtocol: AnyObject {
    func showSearch()
}
```

FeatureHome은 검색 화면 진입만 요청하고, 실제 화면 생성과 이동은 App 레이어가 처리합니다.

---

**HomeFactory**

`HomeFactory`는 FeatureHome 모듈의 **화면 조립 진입점(composition entry point)** 입니다.

제공 메서드:
- `makeHomeView(coordinator:)` — `HomeCoordinatorProtocol` 구현체를 받아 `HomeView` 반환

```swift
let view = HomeFactory.makeHomeView(coordinator: navigator)
```

Factory가 내부적으로 `HomeViewModel`과 `HomeView`를 조립합니다.
`makeHomeView(coordinator:)`는 `HomeViewModel<Coordinator>`와 `HomeView<Coordinator>`를 같은 제네릭 Coordinator 위에 조립해 반환합니다.

---

**HomeViewModel**

`HomeViewModel`은 Home 화면의 사용자 Intent를 관리합니다.

```swift
@MainActor
public final class HomeViewModel<Coordinator: HomeCoordinatorProtocol>: ObservableObject {
    private let coordinator: Coordinator
}
```

제공 Intent:
- `searchBarTapped()` — 검색 진입 버튼 선택 시 `coordinator.showSearch()` 호출

ViewModel은 클로저를 직접 저장하지 않습니다. `HomeCoordinatorProtocol`만 알고 있습니다.

---

**HomeView**

`HomeView`는 AppStore 검색 진입 버튼을 제공하는 Home root 화면입니다.

```swift
public struct HomeView<Coordinator: HomeCoordinatorProtocol>: View
```

화면 구성:
- 검색 진입 버튼: 검색 아이콘 + 플레이스홀더 텍스트, 탭 시 `viewModel.searchBarTapped()` 호출

DesignSystem 토큰 사용:
- 색상: `DSColor.background`, `DSColor.surface`, `DSColor.textSecondary`, `DSColor.outline`
- 타이포그래피: `DSTypography.body1`
- 간격: `DSSpacing.sm`, `DSSpacing.md`, `DSSpacing.lg`
- 아이콘: `DSIcon.magnifyingglass`, `DSIconSize.lg`
- 모서리: `DSCornerRadius.sm`

---

**공개 타입 요약**

| 타입 | 설명 |
|---|---|
| `HomeCoordinatorProtocol` | 화면 이동 계약. App 레이어가 구현합니다. |
| `HomeFactory` | View/ViewModel 조립 진입점. static 메서드 제공. |
| `HomeView<Coordinator>` | AppStore 검색 진입 SwiftUI View. |
| `HomeViewModel<Coordinator>` | 사용자 Intent 관리 ViewModel. |

---

**모듈 의존성**

```text
App Target
    └─ FeatureHome
           └─ DesignSystem (Core/UI)
```

FeatureHome은 AppDomain, AppData, Networking, Persistence를 직접 의존하지 않습니다.
비즈니스 로직과 데이터 접근은 App 레이어가 UseCase를 통해 다른 Feature로 연결합니다.

금지:
```swift
// FeatureHome에서 AppDomain 직접 import 금지
import AppDomain

// FeatureHome에서 AppData 직접 import 금지
import AppData

// FeatureHome에서 다른 Feature 직접 import 금지
import FeatureSearch
import FeatureSearchAppStore
```

---

**테스트**

모듈은 in-memory 기반 2개 테스트를 포함합니다.

포함된 테스트 범위:
- ViewModel Intent: `HomeViewModelTests`

테스트 전략:
- `HomeViewModel`은 `HomeCoordinatorProtocol` 기반으로 Coordinator를 주입받으므로 실제 Navigator 없이 검증 가능합니다.
- `SpyHomeCoordinator`를 사용해 `showSearch()` 호출 횟수와 시점을 독립적으로 검증합니다.
- `@MainActor makeSUT()` 패턴으로 ViewModel을 생성합니다.
- 각 테스트는 given / when / then 구조를 따릅니다.

테스트 더블:

| 타입 | 종류 | 설명 |
|---|---|---|
| `SpyHomeCoordinator` | Spy | `showSearch()` 호출 횟수를 기록합니다. |

---

**권장 사용 전략**
- 상위 계층은 `HomeFactory`와 `HomeCoordinatorProtocol`을 기준으로 의존성을 설계합니다.
- App Target의 `HomeNavigator`가 `HomeCoordinatorProtocol`을 구현하고, `HomeRouteBuilder`가 `HomeFactory`를 호출합니다.
- FeatureHome 내부의 `HomeView`, `HomeViewModel`은 직접 참조하지 않습니다.
- 테스트 환경에서는 `SpyHomeCoordinator`를 사용합니다.

---

**권장 확장 방식**
1. `Coordinator/HomeCoordinatorProtocol`에 새 화면 이동 메서드 추가
2. `Factory/HomeFactory`에 새 화면 조립 메서드 추가
3. `Scenes/` 하위에 새 화면 폴더 추가 (`{SceneName}/View/`, `{SceneName}/ViewModel/`)
4. `HomeViewModel`에 새 Intent 메서드 추가
5. App Target의 `HomeRoute`, `HomeRouteBuilder`, `HomeNavigator`에 새 Route 연결
6. 기능 전용 테스트 추가

---

Created by: jch  
Updated: May 2026
