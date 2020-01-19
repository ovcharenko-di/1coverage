# language: ru

Функционал: Проверка работы команды init
    Как Пользователь
    Я хочу автоматически проверять работу команды init
    Чтобы гарантировать корректность работы команды init

Контекст: Работа в каталоге проекта
    Допустим я установил каталог проекта "." как текущий
    И Я очищаю параметры команды "oscript" в контексте

Сценарий: Запуск приложения с командой init без параметров
    Когда Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os init"
    Тогда Вывод команды "oscript" содержит "КРИТИЧНАЯОШИБКА"
    И код возврата равен 1

Сценарий: Запуск приложения с командой init с параметром help
    Когда Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os init --help"
    Тогда Вывод команды "oscript" содержит
    |Команда: init, i|
    |Инициализация замера, настройка базы для сбора замеров|
    ||
    |Строка запуска: 1coverage init|
    И код возврата равен 0

Сценарий: Запуск приложения с командой init для существующей файловой базы
    Когда Я выполняю команду "runner init-dev"
    И Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os init --ib-connection /F./build/ib"
    Тогда вывод команды "oscript" содержит "Установлена http-отладка для базы"
    И код возврата равен 0
    И я устанавливаю каталог настроек ИБ "/F<РабочийКаталог>/build/ib" как новый рабочий каталог
    И файл "<РабочийКаталог>/1cv8.pfl" содержит
    """
    {"S","localhost:3000"},"remoteDebugServerHistory",
    {"S",":3000"},"remoteDebugUseSpecifiedInfobaseAlias",
    """

Сценарий: Запуск приложения с командой init для существующей серверной базы
    # TODO

Сценарий: Запуск приложения с командой init для несуществующей файловой базы
    Когда Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os init --ib-connection /FC:\ib"
    Тогда Вывод команды "oscript" содержит "Не удалось определить Ид информационной базы"
    И код возврата равен 1

Сценарий: Запуск приложения с командой init с некорректной строкой соединения
    Когда Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os init --ib-connection /D./build/ib"
    Тогда Вывод команды "oscript" содержит "Некорректно указан тип базы в строке соединения, ожидалось /F или /S"
    И код возврата равен 1

Сценарий: Запуск приложения с командой init для существующей файловой базы внутри произвольного каталога
    Когда Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог
    Когда Я выполняю команду "runner" с параметрами "init-dev --root <РабочийКаталог>"
    И Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os init --ib-connection /F<РабочийКаталог>/build/ib"
    Тогда Вывод команды "oscript" содержит "Установлена http-отладка для базы"
    И код возврата равен 0
    И я устанавливаю каталог настроек ИБ "/F<РабочийКаталог>/build/ib" как новый рабочий каталог
    И файл "<РабочийКаталог>/1cv8.pfl" содержит
    """
    {"S","localhost:3000"},"remoteDebugServerHistory",
    {"S",":3000"},"remoteDebugUseSpecifiedInfobaseAlias",
    """
