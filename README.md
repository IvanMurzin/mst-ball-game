https://github.com/user-attachments/assets/64d06516-d1c5-49d9-b797-48108ddb53e2

## Ball Game

Небольшая аркада на Flutter про шарик: игра, скины, статистика и настройки. Проект сделан в слоистой архитектуре с feature-based структурой.

## Быстрый старт

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Полезные команды:

```bash
flutter analyze
dart format .
```

## Стек

- **UI**: Flutter + дизайн-система в `lib/core_ui`
- **State**: `flutter_bloc` (Cubit)
- **DI**: `get_it` + `injectable`
- **Routing**: `go_router`
- **Codegen**: `freezed`, `json_serializable` (JSON только для DTO в data-слое)

## Архитектура

Слои живут в `lib/`:

- **`core/`**: инфраструктура (DI, routing, logger, storage, utils)
- **`core_ui/`**: дизайн-система (токены/темы/DS-компоненты/preview)
- **`domain/`**: чистая доменная логика (entities/usecases/contracts)
- **`data/`**: DTO/mappers/реализации репозиториев (адаптеры к источникам данных)
- **`presentation/`**: страницы/виджеты/состояния (Cubit), без импортов из `data`

Feature-based структура повторяется в слоях, например:

- `lib/domain/<feature>/{entity,repository,usecase}`
- `lib/data/<feature>/{dto,mapper,repository}`
- `lib/presentation/<feature>/{page,widget,bloc}`
