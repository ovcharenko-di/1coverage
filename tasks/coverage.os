#Использовать 1commands
#Использовать fs
#Использовать coverage

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

ФС.ОбеспечитьПустойКаталог("build/coverage");
ПутьКФайлуСтатистики = "build/coverage/stat.json";

Команда = Новый Команда;
Команда.УстановитьКоманду("oscript");
Если НЕ ЭтоWindows Тогда
	Команда.ДобавитьПараметр("-encoding=utf-8");
КонецЕсли;
Команда.ДобавитьПараметр(СтрШаблон("-codestat=%1", ПутьКФайлуСтатистики));
Команда.ДобавитьПараметр("tasks/test.os"); // Файла запуска тестов
Команда.ПоказыватьВыводНемедленно(Истина);

КодВозврата = Команда.Исполнить();

ФайлСтатистики = Новый Файл(ПутьКФайлуСтатистики);

ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();

ПроцессорГенерации.ОтносительныеПути()
				.РабочийКаталог("build/coverage")
				.ФайлСтатистики(ФайлСтатистики.ПолноеИмя)
				.GenericCoverage()
				.Сформировать();

ЗавершитьРаботу(КодВозврата);
