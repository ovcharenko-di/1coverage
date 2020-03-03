#Использовать "../src/1coverage"

Перем юТест;
Перем Лог;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	ИменаТестов = Новый Массив;
	
	ИменаТестов.Добавить("ТестДолжен_ПроверитьДанныеПокрытияXML");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьДанныеПокрытияEDT");
	
	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьДанныеПокрытияXML() Экспорт
	
	ПутьКЛогамПрокси = ОбъединитьПути("tests", "fixtures", "dbgs-log");
	
	ОбработчикЛоговПрокси = Новый ОбработчикЛоговПрокси(ПутьКЛогамПрокси);
	ДанныеЗамеров = ОбработчикЛоговПрокси.ОбработатьЛоги();

	ОбработчикДанныхЗамеров = Новый ОбработчикДанныхЗамеров(ДанныеЗамеров);
	ДанныеПокрытия = ОбработчикДанныхЗамеров.ЗаполнитьДанныеПокрытия();

	ПутьКИсходномуКоду = ОбъединитьПути("tests", "fixtures", "cf-xml");
	ПутьКИсходномуКоду = СтрЗаменить(ПутьКИсходномуКоду, "\", "/");
	
	ОбработчикДанныхПокрытия = Новый ОбработчикДанныхПокрытия(ПутьКИсходномуКоду);
	ОбработчикДанныхПокрытия.ЗаполнитьДанныеПокрытия(ДанныеПокрытия);

	Результат = СериализоватьДанныеПокрытияВСтроку(ДанныеПокрытия);

	Эталон = ПолучитьЭталонXML();
	
	Ожидаем.Что(Результат, "").Равно(Эталон);

	ПроверитьНаличиеФайлов(ДанныеПокрытия);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьДанныеПокрытияEDT() Экспорт
	
	ПутьКЛогамПрокси = ОбъединитьПути("tests", "fixtures", "dbgs-log");
	
	ОбработчикЛоговПрокси = Новый ОбработчикЛоговПрокси(ПутьКЛогамПрокси);
	ДанныеЗамеров = ОбработчикЛоговПрокси.ОбработатьЛоги();

	ОбработчикДанныхЗамеров = Новый ОбработчикДанныхЗамеров(ДанныеЗамеров);
	ДанныеПокрытия = ОбработчикДанныхЗамеров.ЗаполнитьДанныеПокрытия();

	ПутьКИсходномуКоду = ОбъединитьПути("tests", "fixtures", "cf-edt");
	ПутьКИсходномуКоду = СтрЗаменить(ПутьКИсходномуКоду, "\", "/");
	
	ОбработчикДанныхПокрытия = Новый ОбработчикДанныхПокрытия(ПутьКИсходномуКоду);
	ОбработчикДанныхПокрытия.ЗаполнитьДанныеПокрытия(ДанныеПокрытия);

	Результат = СериализоватьДанныеПокрытияВСтроку(ДанныеПокрытия);

	Эталон = ПолучитьЭталонEDT();
	
	Ожидаем.Что(Результат, "").Равно(Эталон);

	ПроверитьНаличиеФайлов(ДанныеПокрытия);

КонецПроцедуры

Функция СериализоватьДанныеПокрытияВСтроку(ДанныеПокрытия)

	Результат = "";
	Для Каждого Стр Из ДанныеПокрытия Цикл

		Результат = Результат +
		Стр.ИдОбъекта + "|" +
		Стр.ПутьКМодулю + "|" +
		Символы.ПС;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ПолучитьЭталонXML()

	Возврат "f304fb62-52f8-44bc-acdb-d0bfd45a4028|./tests/fixtures/cf-xml/AccumulationRegisters/РегистрНакопления1/Ext/ManagerModule.bsl|
	|04132787-f61a-41c5-b2fc-949ba4f6c45a|./tests/fixtures/cf-xml/Documents/Документ1/Forms/ФормаДокумента/Ext/Form/Module.bsl|
	|07872757-43e2-4b3f-8a6a-2bf4b4e05462|./tests/fixtures/cf-xml/CommonCommands/ОбщаяКоманда1/Ext/CommandModule.bsl|
	|50c2fc3a-75fe-4bf9-a867-6f37bfda3c5c|./tests/fixtures/cf-xml/Reports/Отчет1/Forms/ФормаОтчета/Ext/Form/Module.bsl|
	|b7308561-8675-4a9c-bd27-30b65260e8db|./tests/fixtures/cf-xml/Reports/Отчет1/Ext/ManagerModule.bsl|
	|b7308561-8675-4a9c-bd27-30b65260e8db|./tests/fixtures/cf-xml/Reports/Отчет1/Ext/ObjectModule.bsl|
	|4fcb6ccc-1fc4-44b0-89de-e91fd6840511|./tests/fixtures/cf-xml/Catalogs/Справочник1/Forms/ФормаЭлемента/Ext/Form/Module.bsl|
	|8579e6d0-6ef5-4b64-8b17-7f666004b239|./tests/fixtures/cf-xml/Catalogs/Справочник1/Ext/ObjectModule.bsl|
	|1e2790f1-29a8-4f99-ae2d-625a683ec086|./tests/fixtures/cf-xml/CommonModules/ОбщийМодуль1/Ext/Module.bsl|
	|0ced8f12-2926-42b4-a600-dfe927251f51|./tests/fixtures/cf-xml/Documents/Документ1/Commands/Команда1/Ext/CommandModule.bsl|
	|58183e39-a47c-4a13-a9f7-f6c960773072|./tests/fixtures/cf-xml/Ext/ManagedApplicationModule.bsl|
	|7b8f569a-ce13-4061-b8cd-09502fd9c795|./tests/fixtures/cf-xml/Catalogs/Справочник1/Commands/Команда1/Ext/CommandModule.bsl|
	|864db1f0-53b5-4ecf-b266-6f4b4d966911|./tests/fixtures/cf-xml/Documents/Документ1/Commands/Команда2/Ext/CommandModule.bsl|
	|fb84ce0e-e9ed-4113-9ba7-c000e6372cf0|./tests/fixtures/cf-xml/Documents/Документ1/Ext/ObjectModule.bsl|
	|58183e39-a47c-4a13-a9f7-f6c960773072|./tests/fixtures/cf-xml/Ext/SessionModule.bsl|
	|f304fb62-52f8-44bc-acdb-d0bfd45a4028|./tests/fixtures/cf-xml/AccumulationRegisters/РегистрНакопления1/Ext/RecordSetModule.bsl|
	|de16499a-16ac-43e9-a018-97f2cc0c76e2|./tests/fixtures/cf-xml/DocumentJournals/ЖурналДокументов1/Ext/ManagerModule.bsl|
	|97933dac-5eb4-4418-b16e-194de8522421|./tests/fixtures/cf-xml/CommonForms/Форма/Ext/Form/Module.bsl|
	|";

КонецФункции

Функция ПолучитьЭталонEDT()

	Возврат "f304fb62-52f8-44bc-acdb-d0bfd45a4028|./tests/fixtures/cf-edt/src/AccumulationRegisters/РегистрНакопления1/ManagerModule.bsl|
	|04132787-f61a-41c5-b2fc-949ba4f6c45a|./tests/fixtures/cf-edt/src/Documents/Документ1/Forms/ФормаДокумента/Module.bsl|
	|07872757-43e2-4b3f-8a6a-2bf4b4e05462|./tests/fixtures/cf-edt/src/CommonCommands/ОбщаяКоманда1/CommandModule.bsl|
	|50c2fc3a-75fe-4bf9-a867-6f37bfda3c5c|./tests/fixtures/cf-edt/src/Reports/Отчет1/Forms/ФормаОтчета/Module.bsl|
	|b7308561-8675-4a9c-bd27-30b65260e8db|./tests/fixtures/cf-edt/src/Reports/Отчет1/ManagerModule.bsl|
	|b7308561-8675-4a9c-bd27-30b65260e8db|./tests/fixtures/cf-edt/src/Reports/Отчет1/ObjectModule.bsl|
	|4fcb6ccc-1fc4-44b0-89de-e91fd6840511|./tests/fixtures/cf-edt/src/Catalogs/Справочник1/Forms/ФормаЭлемента/Module.bsl|
	|8579e6d0-6ef5-4b64-8b17-7f666004b239|./tests/fixtures/cf-edt/src/Catalogs/Справочник1/ObjectModule.bsl|
	|1e2790f1-29a8-4f99-ae2d-625a683ec086|./tests/fixtures/cf-edt/src/CommonModules/ОбщийМодуль1/Module.bsl|
	|0ced8f12-2926-42b4-a600-dfe927251f51|./tests/fixtures/cf-edt/src/Documents/Документ1/Commands/Команда1/CommandModule.bsl|
	|58183e39-a47c-4a13-a9f7-f6c960773072|./tests/fixtures/cf-edt/src/Configuration/ManagedApplicationModule.bsl|
	|7b8f569a-ce13-4061-b8cd-09502fd9c795|./tests/fixtures/cf-edt/src/Catalogs/Справочник1/Commands/Команда1/CommandModule.bsl|
	|864db1f0-53b5-4ecf-b266-6f4b4d966911|./tests/fixtures/cf-edt/src/Documents/Документ1/Commands/Команда2/CommandModule.bsl|
	|fb84ce0e-e9ed-4113-9ba7-c000e6372cf0|./tests/fixtures/cf-edt/src/Documents/Документ1/ObjectModule.bsl|
	|58183e39-a47c-4a13-a9f7-f6c960773072|./tests/fixtures/cf-edt/src/Configuration/SessionModule.bsl|
	|f304fb62-52f8-44bc-acdb-d0bfd45a4028|./tests/fixtures/cf-edt/src/AccumulationRegisters/РегистрНакопления1/RecordSetModule.bsl|
	|de16499a-16ac-43e9-a018-97f2cc0c76e2|./tests/fixtures/cf-edt/src/DocumentJournals/ЖурналДокументов1/ManagerModule.bsl|
	|97933dac-5eb4-4418-b16e-194de8522421|./tests/fixtures/cf-edt/src/CommonForms/Форма/Module.bsl|
	|";

КонецФункции

Процедура ПроверитьНаличиеФайлов(ДанныеПокрытия)

	Для Каждого Модуль Из ДанныеПокрытия Цикл
		
		Файл = Новый Файл(Модуль.ПутьКМодулю);
		ФайлСуществует = Файл.Существует();
		Ожидаем.Что(ФайлСуществует, "Путь к модулю построен некорректно (" + Модуль.ПутьКМодулю + ")").Равно(Истина);

	КонецЦикла;

КонецПроцедуры

Лог = ПараметрыПриложения.Лог();
