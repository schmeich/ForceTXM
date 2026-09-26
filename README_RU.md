# ForceTXM — tweak для XeniOS в LiveContainer

Назначение: до запуска XeniOS выставить переменную окружения:

    HAS_TXM=1

Это заставляет XeniOS использовать TXM/broker-capable JIT path на iOS 26 вместо
ошибочно выбранного non-TXM mprotect fallback внутри LiveContainer.

## Что делает tweak

Код минимальный:

    setenv("HAS_TXM", "1", 1);

Он выполняется в constructor dylib при загрузке TweakLoader, до входа в guest app.

## Сборка без Mac — через GitHub Actions

1. Создай пустой репозиторий GitHub.
2. Загрузи в него ВСЁ содержимое этой папки, включая `.github/workflows/build.yml`.
3. Открой вкладку Actions.
4. Выбери `Build ForceTXM dylib`.
5. Нажми `Run workflow`.
6. После завершения открой run -> Artifacts -> `ForceTXM`.
7. Скачай ZIP и достань `ForceTXM.dylib`.

## Установка в LiveContainer

1. Открой LiveContainer.
2. Settings -> Tweak Manager.
3. Импортируй `ForceTXM.dylib`.
   LiveContainer должен автоматически подписать импортированный tweak.
4. Создай отдельную app-specific папку tweaks для XeniOS
   (не клади ForceTXM в глобальную папку Tweaks, чтобы он не применялся ко всем приложениям).
5. В настройках XeniOS выбери эту папку tweaks.
6. Убедись, что:
   - `Don't Inject TweakLoader` = OFF
   - `Don't Load TweakLoader` = OFF
   Иначе dylib не загрузится.
7. `Use LiveContainer's Bundle ID` оставь ON.

## StikDebug

1. LocalDevVPN = ON.
2. Для LiveContainer/XeniOS используй `universal.js`.
3. В StikDebug включи `TXM (Override)`.
4. Запусти XeniOS через LiveContainer и выполни JIT script.
5. Запусти игру.

## Как проверить результат

В `xenia.log` должно исчезнуть:

    iOS JIT: non-TXM path on iOS 26

И появиться что-то вроде:

    iOS JIT: TXM detected on iOS 26; using broker-capable path
    iOS JIT persistent dual-mapping active

Если `non-TXM` остаётся — tweak не загрузился (обычно выбран не тот tweaks folder
или отключён TweakLoader).

Если появляется TXM path, но нет `persistent dual-mapping active`, проблема уже
между XeniOS и StikDebug/universal.js.
