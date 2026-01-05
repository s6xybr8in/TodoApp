
### 3. 상태 관리 및 성능 비효율성
- **문제점:**
    - `DoneScreen`: `ValueListenableBuilder`가 중첩되어 있어 불필요한 위젯 재빌드를 유발할 수 있습니다.
    - `HomeScreen`: `builder` 내부에서 매번 목록을 필터링(`where`)하고 정렬(`sort`)하는 작업은 데이터 양이 많아질 경우 성능 저하의 원인이 될 수 있습니다.
- **개선 제안:**
    - **효율적인 상태 관리:** `ValueListenableBuilder` 중첩 구조를 재검토하고, 하나의 `ChangeNotifier`나 `Stream`을 사용하여 여러 데이터 소스의 변경을 한 번에 처리하는 것을 고려해볼 수 있습니다.
    - **데이터 처리 최적화:** 필터링 및 정렬 로직은 `builder` 외부에서 수행하거나, `ChangeNotifier` 또는 BLoC 등에서 미리 계산된 목록을 UI에 제공하는 방식으로 변경하여 재빌드 시의 연산 비용을 줄여야 합니다.

---

## 새로운 아키텍처 도입 로드맵

`ValueListenableBuilder`의 현재 구조로는 문제 해결이 복잡하다고 판단하여, 다음과 같이 애플리케이션의 구조를 변경하는 로드맵을 제안합니다.

1.  **Repository 역할 재정의:**
    *   Repository는 데이터 영속성(Persistence) 계층의 역할만 담당하도록 책임을 축소합니다. 즉, 데이터베이스와의 순수한 저장, 조회, 수정, 삭제(CRUD) 작업만 수행합니다.

2.  **Provider 계층 도입:**
    *   `lib/provider` 폴더를 신설합니다.
    *   이 계층에서는 데이터 모델(예: `Todo`)에 대한 비즈니스 로직을 처리합니다. (예: 생성, 수정, 삭제, 복제 등)
    *   UI에서 필요한 데이터의 상태를 관리하고, Repository를 통해 데이터를 업데이트합니다.

3.  **상태 관리 솔루션 전환:**
    *   Provider 패턴 구현이 안정화된 후, 보다 선언적이고 효율적인 상태 관리를 위해 `Riverpod`와 같은 전문 상태 관리 라이브러리 도입을 검토하고 전환을 진행합니다.

---

### **구현 계획: Provider 패턴 도입 및 Riverpod 전환**

아래는 현재 아키텍처를 개선하기 위한 구체적인 단계별 구현 계획입니다.

---

#### **Phase 1: Provider 계층 도입 (ChangeNotifier 활용)**

**목표:** Repository와 UI를 분리하고, 비즈니스 로직을 Provider로 옮겨 상태 관리를 중앙집중화합니다. `provider` 패키지를 도입하여 `ChangeNotifier`를 쉽게 사용합니다.

**1. `provider` 패키지 추가:**
   - `pubspec.yaml` 파일에 `provider` 패키지를 추가하고 `flutter pub get`을 실행합니다.
     ```yaml
     dependencies:
       flutter:
         sdk: flutter
       provider: ^6.1.1 # 작성 시점 최신 버전, pub.dev에서 확인 권장
       # ... 기존 의존성
     ```

**2. `ChangeNotifier` Provider 클래스 생성 (`lib/provider/`):**

   - **`TodoProvider.dart` 생성:**
     - `TodoRepository`를 주입받는 `TodoProvider with ChangeNotifier` 클래스를 생성합니다.
     - 내부 상태로 `List<Todo> _todos`를 관리합니다.
     - `loadTodos()` 메소드를 만들어 Repository로부터 모든 Todo를 가져와 `_todos`를 초기화합니다.
     - UI를 위한 getter들을 만듭니다. 이 과정에서 기존 `build` 메소드에 있던 필터링/정렬 로직을 옮깁니다.
       ```dart
       // 예시: lib/provider/todo_provider.dart
       List<Todo> get activeTodos => _todos.where((t) => !t.isDone).toList()..sort();
       List<Todo> get starredTodos => _todos.where((t) => t.isStared).toList()..sort();
       ```
     - CRUD 메소드 (`addTodo`, `updateTodo`, `deleteTodo`, `toggleDone`, `toggleStar`)를 구현합니다. 각 메소드는 `TodoRepository`의 해당 기능을 호출한 후, 내부 `_todos` 상태를 업데이트하고 `notifyListeners()`를 호출하여 UI에 변경을 알립니다.

   - **`DoneProvider.dart` 생성:**
     - `DailyRepository`를 주입받는 `DoneProvider with ChangeNotifier` 클래스를 생성합니다.
     - `Map<DateTime, List<Todo>> _events`와 `List<Daily> _dailies`를 상태로 관리합니다.
     - `loadDailies()` 메소드에서 모든 `Daily` 데이터를 로드하고 `_events` 맵을 계산합니다.
     - `getEventsForDay(DateTime day)` 같은 메소드를 제공하여 UI에서 특정 날짜의 완료된 Todo 목록을 쉽게 가져올 수 있도록 합니다.

**3. `main.dart` 및 `locator.dart` 수정:**

   - **`locator.dart`:**
     - 새로 만든 `TodoProvider`와 `DoneProvider`를 `get_it`에 등록합니다.
       ```dart
       locator.registerLazySingleton(() => TodoProvider(locator<TodoRepository>()));
       locator.registerLazySingleton(() => DoneProvider(locator<DailyRepository>()));
       ```
   - **`main.dart`:**
     - `runApp` 부분을 `MultiProvider`로 감싸서 앱 전역에 Provider를 제공합니다.
       ```dart
       runApp(
         MultiProvider(
           providers: [
             ChangeNotifierProvider(create: (_) => locator<TodoProvider>()..loadTodos()),
             ChangeNotifierProvider(create: (_) => locator<DoneProvider>()..loadDailies()),
           ],
           child: const MyApp(),
         ),
       );
       ```

**4. UI(Screens/Widgets) 리팩토링:**

   - **`HomeScreen.dart`:**
     - `ValueListenableBuilder`를 `Consumer<TodoProvider>`로 교체합니다.
     - `builder` 내부의 필터링/정렬 로직(`box.values.where(...)`)을 제거하고, `Provider`의 getter(`todoProvider.activeTodos`)를 직접 사용합니다.
     - `_todoRepository`를 직접 호출하는 대신, `context.read<TodoProvider>()`를 사용하여 `Provider`의 메소드를 호출합니다.

   - **`DoneScreen.dart`:**
     - 중첩된 `ValueListenableBuilder`를 제거하고 `Consumer<DoneProvider>`를 사용합니다.
     - 캘린더의 `events`와 리스트의 `dailyForSelectedDay`를 `DoneProvider`로부터 받아옵니다.

   - **`StarsScreen.dart`:**
     - `ValueListenableBuilder`를 `Consumer<TodoProvider>`로 교체하고 `todoProvider.starredTodos`를 사용합니다.

   - **`TodoListItem.dart` 등:**
     - `locator<...>()`를 통해 Repository를 직접 가져오는 대신, 이벤트 핸들러에서 `context.read<TodoProvider>()`를 통해 상태 변경 함수를 호출하도록 변경합니다.

---

#### **Phase 2: Riverpod으로 상태 관리 전환**

**목표:** `get_it`과 `provider`를 `flutter_riverpod`로 대체하여 더 선언적이고 유연하며 테스트하기 쉬운 아키텍처를 구축합니다.

**1. `flutter_riverpod` 패키지 추가:**
   - `pubspec.yaml`에 `flutter_riverpod`를 추가하고 `get_it`, `provider`는 제거합니다.

**2. Provider 정의 (`lib/providers/` 디렉토리 추천):**

   - 모든 Provider를 전역 변수로 정의합니다.
   - **Repository Providers:**
     ```dart
     final dailyRepositoryProvider = Provider((ref) => DailyRepository());
     final todoRepositoryProvider = Provider((ref) => TodoRepository(ref.watch(dailyRepositoryProvider)));
     final starRepositoryProvider = Provider((ref) => StarRepository());
     ```
   - **Notifier Providers:**
     - `ChangeNotifierProvider` 대신 `StateNotifierProvider` (또는 최신 `NotifierProvider`)를 사용합니다. 예를 들어 `TodoProvider`를 `TodoNotifier`로 리팩토링합니다.
     - 상태를 관리할 `TodoState` 클래스 (불변 객체 권장)를 정의할 수 있습니다.
       ```dart
       // Notifier class
       class TodoNotifier extends StateNotifier<List<Todo>> {
         final TodoRepository _repo;
         TodoNotifier(this._repo) : super([]);

         Future<void> loadTodos() async {
           state = await _repo.getAllTodos(); // Repository에 getAllTodos() 추가 필요
         }
         // ... CRUD 메소드 (state = newState 형식으로 상태 업데이트)
       }

       // Provider definition
       final todosProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
         return TodoNotifier(ref.watch(todoRepositoryProvider))..loadTodos();
       });
       ```
     - 파생(Derived) 상태를 위한 Provider를 만듭니다.
       ```dart
       final activeTodosProvider = Provider<List<Todo>>((ref) {
         final todos = ref.watch(todosProvider);
         return todos.where((t) => !t.isDone).toList()..sort();
       });
       ```
**3. `main.dart` 및 `locator.dart` 수정:**
   - `setupLocator()` 호출과 `get_it` 관련 코드를 모두 제거합니다. `locator.dart` 파일 자체를 삭제할 수 있습니다.
   - `MultiProvider` 대신 `ProviderScope`로 `MyApp`을 감싸줍니다.
     ```dart
     void main() async {
       // ... Hive 초기화
       runApp(const ProviderScope(child: MyApp()));
     }
     ```

**4. UI 리팩토링 (Riverpod Hook 사용):**
   - `StatelessWidget` -> `ConsumerWidget`, `StatefulWidget` -> `ConsumerStatefulWidget`으로 변경합니다.
   - `build` 메소드는 `WidgetRef ref` 파라미터를 추가로 받게 됩니다.
   - `Consumer` 위젯이나 `context.watch` 대신 `ref.watch()`를 사용해서 Provider의 상태를 구독합니다.
     ```dart
     // In HomeScreen's build method
     final List<Todo> activeTodos = ref.watch(activeTodosProvider);
     return ListView.builder(...);
     ```
   - 상태를 변경하는 메소드를 호출할 때는 `ref.read()`를 사용합니다.
     ```dart
     // In TodoListItem's onPressed
     onPressed: () => ref.read(todosProvider.notifier).toggleDone(todo),
     ```
이러한 단계를 통해 앱의 상태 관리는 더욱 예측 가능하고 효율적으로 변하며, 각 컴포넌트의 책임이 명확하게 분리되어 유지보수성이 크게 향상될 것입니다.

