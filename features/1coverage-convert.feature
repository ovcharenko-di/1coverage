# language: ru

Функционал: Проверка работы команды convert
    Как Пользователь
    Я хочу автоматически проверять работу команды convert
    Чтобы гарантировать корректность работы приложения

Контекст: Работа в каталоге проекта
    Допустим я установил каталог проекта "." как текущий
    И Я очищаю параметры команды "oscript" в контексте

Сценарий: Запуск приложения с командой convert без параметров
    Когда Я выполняю команду "oscript" с параметрами "./src/1coverage/1coverage.os convert"
    И Я сообщаю вывод команды "oscript"
    И код возврата равен 1

Сценарий: Запуск приложения с командой convert, исходники XML, формат результата GenericCoverage
    Когда Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог
    И Я копирую каталог "dbgs-log" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И Я копирую каталог "cf-xml" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую файл "sonar-project.properties" из каталога "tests/fixtures/xml" проекта в рабочий каталог
    И Я установил рабочий каталог как текущий каталог
    И Я добавляю параметр "<КаталогПроекта>/src/1coverage/1coverage.os convert" для команды "oscript"
    И Я добавляю параметр "--log-path ./build/dbgs-log" для команды "oscript"
    И Я добавляю параметр "--src-path ./cf-xml" для команды "oscript"
    И Я добавляю параметр "--out ./build/GenericCoverage.xml" для команды "oscript"
    И Я добавляю параметр "--format GenericCoverage" для команды "oscript"
    И Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И Вывод команды "oscript" не содержит "КРИТИЧНАЯОШИБКА"
    И код возврата равен 0
    И файл "./build/GenericCoverage.xml" существует
    И файл "./build/GenericCoverage.xml" содержит xml
    """
    <coverage version="1">
    <file path="./cf-xml/AccumulationRegisters/РегистрНакопления1/Ext/ManagerModule.bsl">
        <lineToCover lineNumber="3" covered="true"/>
        <lineToCover lineNumber="5" covered="true"/>
    </file>
    <file path="./cf-xml/Documents/Документ1/Forms/ФормаДокумента/Ext/Form/Module.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
        <lineToCover lineNumber="9" covered="true"/>
    </file>
    <file path="./cf-xml/CommonCommands/ОбщаяКоманда1/Ext/CommandModule.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
    </file>
    <file path="./cf-xml/Reports/Отчет1/Forms/ФормаОтчета/Ext/Form/Module.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
    </file>
    <file path="./cf-xml/Reports/Отчет1/Ext/ManagerModule.bsl">
        <lineToCover lineNumber="4" covered="true"/>
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
    </file>
    <file path="./cf-xml/Reports/Отчет1/Ext/ObjectModule.bsl">
        <lineToCover lineNumber="1031" covered="true"/>
        <lineToCover lineNumber="1033" covered="true"/>
    </file>
    <file path="./cf-xml/Catalogs/Справочник1/Forms/ФормаЭлемента/Ext/Form/Module.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
        <lineToCover lineNumber="9" covered="true"/>
    </file>
    <file path="./cf-xml/Catalogs/Справочник1/Ext/ObjectModule.bsl">
        <lineToCover lineNumber="4" covered="true"/>
        <lineToCover lineNumber="6" covered="true"/>
    </file>
    <file path="./cf-xml/CommonModules/ОбщийМодуль1/Ext/Module.bsl">
        <lineToCover lineNumber="3" covered="true"/>
        <lineToCover lineNumber="5" covered="true"/>
    </file>
    </coverage>
        """

Сценарий: Запуск приложения с командой convert, исходники EDT, формат результата GenericCoverage
    Когда Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог
    И Я копирую каталог "dbgs-log" из каталога "tests/fixtures" проекта в подкаталог "build" рабочего каталога
    И Я копирую каталог "cf-edt" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую файл "sonar-project.properties" из каталога "tests/fixtures/edt" проекта в рабочий каталог
    И Я установил рабочий каталог как текущий каталог
    И Я добавляю параметр "<КаталогПроекта>/src/1coverage/1coverage.os convert" для команды "oscript"
    И Я добавляю параметр "--log-path ./build/dbgs-log" для команды "oscript"
    И Я добавляю параметр "--src-path ./cf-edt" для команды "oscript"
    И Я добавляю параметр "--out ./build/GenericCoverage.xml" для команды "oscript"
    И Я добавляю параметр "--format GenericCoverage" для команды "oscript"
    И Я выполняю команду "oscript"
    И Я сообщаю вывод команды "oscript"
    И Вывод команды "oscript" не содержит "КРИТИЧНАЯОШИБКА"
    И код возврата равен 0
    И файл "./build/GenericCoverage.xml" существует
    И файл "./build/GenericCoverage.xml" содержит xml
    """
    <coverage version="1">
    <file path="./cf-edt/src/AccumulationRegisters/РегистрНакопления1/ManagerModule.bsl">
        <lineToCover lineNumber="3" covered="true"/>
        <lineToCover lineNumber="5" covered="true"/>
    </file>
    <file path="./cf-edt/src/Documents/Документ1/Forms/ФормаДокумента/Module.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
        <lineToCover lineNumber="9" covered="true"/>
    </file>
    <file path="./cf-edt/src/CommonCommands/ОбщаяКоманда1/CommandModule.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
    </file>
    <file path="./cf-edt/src/Reports/Отчет1/Forms/ФормаОтчета/Module.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
    </file>
    <file path="./cf-edt/src/Reports/Отчет1/ManagerModule.bsl">
        <lineToCover lineNumber="4" covered="true"/>
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
    </file>
    <file path="./cf-edt/src/Reports/Отчет1/ObjectModule.bsl">
        <lineToCover lineNumber="1031" covered="true"/>
        <lineToCover lineNumber="1033" covered="true"/>
    </file>
    <file path="./cf-edt/src/Catalogs/Справочник1/Forms/ФормаЭлемента/Module.bsl">
        <lineToCover lineNumber="5" covered="true"/>
        <lineToCover lineNumber="7" covered="true"/>
        <lineToCover lineNumber="9" covered="true"/>
    </file>
    <file path="./cf-edt/src/Catalogs/Справочник1/ObjectModule.bsl">
        <lineToCover lineNumber="4" covered="true"/>
        <lineToCover lineNumber="6" covered="true"/>
    </file>
    <file path="./cf-edt/src/CommonModules/ОбщийМодуль1/Module.bsl">
        <lineToCover lineNumber="3" covered="true"/>
        <lineToCover lineNumber="5" covered="true"/>
    </file>
    </coverage>
    """

Сценарий: Запуск приложения с командой convert, исходники EDT, формат результата lcov

Сценарий: Запуск приложения с командой convert, исходники XML, формат результата lcov
