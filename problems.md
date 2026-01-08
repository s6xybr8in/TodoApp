### **`lib/**` 코드 리뷰 및 Provider 사용법 검토**

Provider 패턴 도입 1단계 구현 사항에 대한 코드 리뷰를 진행했습니다. Repository와 UI를 분리하고 비즈니스 로직을 Provider로 이전하는 등 아키텍처 개선을 위한 좋은 시작점을 마련했습니다. 하지만 몇 가지 개선이 필요한 부분이 발견되어 아래와 같이 정리합니다.

 - [x] **1. Provider 내 불필요한 `notifyListeners()` 호출 (심각도: 높음)**

*   **문제점:** `lib/providers/todo_provider.dart`의 `getDoneTodosByDate()` 메서드 내에서 `notifyListeners()`가 호출되고 있습니다.
*   **영향:** `getDoneTodosByDate()`는 `DoneScreen`의 `build` 메서드 내에서 `context.watch`와 함께 사용됩니다. `build` 중에 `notifyListeners()`가 호출되면 위젯이 다시 `build`되고, 이 과정이 무한 반복되어 앱 성능 저하 및 오류를 유발합니다. (Flutter `setState() or markNeedsBuild() called during build` 예외 발생)
*   **개선 제안:**
    *   `getDoneTodosByDate()`와 같이 데이터를 조회하고 가공하는 역할만 하는 메서드에서 `notifyListeners()` 호출을 즉시 제거해야 합니다.
    *   `notifyListeners()`는 `addTodo`, `toggleDone`처럼 상태를 '변경'하는 목적의 메서드에서만 호출되어야 합니다.

- [x] **2. 비효율적인 데이터 필터링 및 가공 (심각도: 중간)**

*   **문제점:**
    *   `lib/screens/home_screen.dart`: `build` 메서드 내에서 `todoProvider.todos.where((todo) => !todo.isDone).toList()`를 사용하여 화면이 갱신될 때마다 전체 목록을 필터링하고 있습니다.
    *   `lib/providers/todo_provider.dart`: `getDoneTodosByDate()`와 `getProgressTodosByDate()`는 호출될 때마다 매번 전체 `_todos` 목록을 순회하며 새로운 맵을 생성합니다.
*   **영향:** Todo 항목이 많아질수록 UI 렌더링 성능이 저하됩니다.
*   **개선 제안:**
    *   리팩토링 계획에 명시된 대로, 필터링/정렬된 목록을 제공하는 `getter`를 `TodoProvider`에 구현합니다. UI에서는 이 getter를 사용하여 미리 계산된 데이터를 받기만 해야 합니다.
    *   `TodoProvider`에 아래와 같은 getter를 추가하고 UI에서 사용하도록 변경하는 것을 권장합니다.
      ```dart
      // lib/providers/todo_provider.dart

      // 홈 화면을 위한 getter
      List<Todo> get activeTodos => _todos.where((t) => !t.isDone).toList()..sort();
      
      // 완료 화면을 위한 getter
      Map<String, List<Todo>> get doneTodosByDate {
        Map<String, List<Todo>> map = {};
        for (var todo in _todos) {
          if (todo.isDone && todo.doneDate != null) {
            String dateKey = todo.doneDate!.toIso8601String().split('T')[0];
            (map[dateKey] ??= []).add(todo);
          }
        }
        return map;
      }
      ```

**3. 중복된 상태 관리 및 단일 책임 원칙 위반 (심각도: 중간)**

*   **문제점:** "찜하기(Star)" 기능의 상태가 두 곳에서 관리되고 있습니다: `Todo` 모델의 `isStared` 불리언 필드와, 별도의 `StarProvider`, `StarRepository`, `Star` 모델 및 'stars' Hive 박스.
*   **영향:**
    *   데이터 동기화 로직이 복잡해지고 오류 발생 가능성이 높아집니다. (예: `TodoListItem`에서 `toggleStar`와 `addStar`/`deletebyID`를 모두 호출해야 함)
    *   코드가 불필요하게 복잡해지며, 데이터의 "단일 진실 공급원(Single Source of Truth)" 원칙을 위배합니다.
*   **개선 제안:**
    *   `Todo` 모델의 `isStared` 필드를 "찜하기" 상태의 유일한 진실 공급원으로 지정합니다.
    *   `StarProvider`, `StarRepository`, `Star` 모델, `star.g.dart`, 'stars' Hive 박스 관련 코드를 모두 제거합니다.
    *   "찜한 목록"이 필요할 경우, `TodoProvider`에 `starredTodos` getter를 추가하여 `_todos.where((t) => t.isStared).toList()` 형태로 제공합니다.
    *   `StarsScreen`은 `TodoProvider`를 `watch`하여 이 `starredTodos` 목록을 표시하도록 수정합니다. 이렇게 하면 `main.dart`의 `StarProvider` 등록도 제거할 수 있습니다.

**4. 위젯의 Provider 접근 방식 (심각도: 낮음)**

*   **문제점:** `lib/screens/todo_detail_screen.dart`에서 `TodoProvider` 인스턴스를 생성자를 통해 주입받고 있습니다.
*   **영향:** 위젯의 재사용성을 저해하고, Provider 패턴의 장점인 위젯 트리로부터의 의존성 분리를 약화시킵니다.
*   **개선 제안:**
    *   `TodoDetailScreen`의 생성자에서 `todoProvider` 파라미터를 제거합니다.
    *   상태 변경이 필요한 `_saveTodo`와 같은 메서드 내에서 `context.read<TodoProvider>()`를 사용하여 Provider에 접근하도록 수정합니다. 이 방식은 위젯의 불필요한 리빌드를 방지하면서 상태를 변경하는 표준적인 방법입니다.
      ```dart
      // lib/screens/todo_detail_screen.dart _saveTodo 메서드 내부
      // final newTodo = widget.todoProvider.makeTodo(_title, _importance);
      // await widget.todoProvider.addTodo(newTodo);
      
      final todoProvider = context.read<TodoProvider>();
      final newTodo = todoProvider.makeTodo(_title, _importance);
      await todoProvider.addTodo(newTodo);
      ```

