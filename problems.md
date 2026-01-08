
---

### **`lib/**` 코드 재검토 및 개선 사항 점검**

이전 리뷰 이후 코드에 많은 개선이 있었습니다. 특히 `StarProvider`를 제거하고 `Todo.isStared`를 단일 진실 공급원(Single Source of Truth)으로 사용하도록 리팩토링한 점, 그리고 `TodoProvider`의 `getDoneTodosByDate` 메서드에서 `notifyListeners`를 제거하여 잠재적인 무한 루프 문제를 해결한 점은 매우 긍정적입니다.

현재 코드를 다시 점검한 결과, 아키텍처를 더욱 견고하게 만들기 위한 몇 가지 추가 개선점을 발견하여 아래와 같이 정리합니다.

**[x] 1. Provider 데이터 제공 방식 및 UI 성능 (심각도: 중간)**

*   **문제점:**
    *   `lib/screens/home_screen.dart`의 `build` 메서드에서 여전히 `todoProvider.todos.where(...)`를 사용하여 화면이 갱신될 때마다 '진행 중인 Todo' 목록을 필터링하고 있습니다.
    *   `TodoProvider`에 `getActiveTodos` getter가 추가되었지만, `HomeScreen`에서 사용되지 않고 있습니다.
    *   `TodoProvider`의 getter들(`getActiveTodos`, `getStaredTodos`, `getDoneTodosByDate`)은 호출될 때마다 매번 새로운 List나 Map을 생성하는 연산을 수행합니다.
*   **영향:** 데이터가 많아질 경우, 불필요한 연산으로 인해 UI 렌더링 성능이 저하될 수 있습니다. `HomeScreen`의 문제는 이전 리뷰에서 지적된 사항이 아직 완전히 해결되지 않은 것입니다.
*   **개선 제안:**
    *   **`HomeScreen` 수정:** `build` 메서드 내의 필터링 로직을 제거하고, `TodoProvider`의 `getActiveTodos` getter를 사용하도록 변경합니다.
      ```dart
      // lib/screens/home_screen.dart -> build()
      // 이전 코드: List<Todo> todos = todoProvider.todos.where((todo) => !todo.isDone).toList();
      List<Todo> todos = todoProvider.getActiveTodos; // 변경 후
      ```
    *   **Provider getter 네이밍 컨벤션:** Dart에서는 getter 이름에 'get' 접두사를 붙이지 않는 것이 일반적입니다. 가독성을 위해 `getActiveTodos` -> `activeTodos` 와 같이 수정하는 것을 권장합니다.
    *   **(심화) 데이터 캐싱:** `Riverpod`으로 전환하기 전 단계라면, `ChangeNotifier` 내부에서 계산된 목록을 캐싱하여 성능을 최적화할 수 있습니다. `_todos`가 변경될 때만 파생 데이터를 다시 계산하는 방식입니다.

**[x] 2. 위젯의 Provider 접근 방식 (심각도: 낮음)**

*   **문제점:** `lib/screens/todo_detail_screen.dart`에서 `TodoProvider` 인스턴스를 여전히 생성자를 통해 주입받고 있습니다. 이 문제는 이전 리뷰에서도 지적되었습니다.
*   **영향:** 위젯의 재사용성을 저해하고 Provider 패턴의 장점을 약화시킵니다.
*   **개선 제안:**
    *   `TodoDetailScreen`의 생성자에서 `todoProvider` 파라미터를 제거합니다.
    *   상태 변경이 필요한 `_saveTodo`와 같은 메서드 내에서 `context.read<TodoProvider>()`를 사용하여 Provider에 접근하도록 수정합니다.
      ```dart
      // lib/screens/todo_detail_screen.dart -> _saveTodo()
      void _saveTodo() async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
    
          // final newTodo = widget.todoProvider.makeTodo(_title, _importance);
          // await widget.todoProvider.addTodo(newTodo);
          
          // 개선안
          final todoProvider = context.read<TodoProvider>();
          final newTodo = todoProvider.makeTodo(_title, _importance);
          await todoProvider.addTodo(newTodo);
    
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
      ```
    *   `StarListItem`에서 `TodoDetailScreen`으로 이동할 때도 마찬가지로 `todoProvider`를 넘겨주는 대신, `TodoDetailScreen`이 스스로 `context`를 통해 `Provider`를 찾도록 하는 것이 좋습니다.

**[x] 3. 기타 코드 정리**

*   **문제점:** `lib/screens/stars_screen.dart`에 디버깅 목적으로 사용된 `kPrint` 호출이 남아있습니다.
*   **영향:** 프로덕션 코드에 불필요한 로그를 남길 수 있습니다.
*   **개선 제안:** 배포 전 또는 기능 개발 완료 시점에 디버깅 관련 코드를 제거하는 것이 좋습니다.

---
