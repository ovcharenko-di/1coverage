# language: ru

Функционал: Проверка запуска приложения и команд
    Как Пользователь
    Я хочу автоматически проверять запуск приложения без команды и команды без параметров
    Чтобы гарантировать корректность его работы

Сценарий: Запуск приложения без команды
    Когда Я выполняю команду "oscript ./src/1coverage.os"
    Тогда я вижу в консоли вывод "1coverage v."
    И код возврата равен 0