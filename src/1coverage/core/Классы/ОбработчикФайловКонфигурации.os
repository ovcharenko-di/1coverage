#Использовать fs
#Использовать 1commands

Перем Лог;

Перем ПутьКИсходномуКоду;

Перем ВидыОбъектовМетаданныхСМодулями;

Перем КэшКонфигурации;

Процедура ПриСозданииОбъекта(пПутьКИсходномуКоду) Экспорт

	Лог = ПараметрыПриложения.Лог();

	ПутьКИсходномуКоду = пПутьКИсходномуКоду;

	ВидыОбъектовМетаданныхСМодулями = ВидыОбъектовМетаданныхСМодулями();

	КэшКонфигурации = ИнициализироватьТаблицуКэша();

КонецПроцедуры

Функция ИнициализироватьТаблицуКэша()

	ТаблицаКэша = Новый ТаблицаЗначений();

	ТаблицаКэша.Колонки.Добавить("ИдОбъекта");
	ТаблицаКэша.Колонки.Добавить("ПутьКОбъекту");
	ТаблицаКэша.Колонки.Добавить("ИмяКоманды");
	ТаблицаКэша.Колонки.Добавить("ИмяФормы");

	Возврат ТаблицаКэша;

КонецФункции

Функция НайтиФайлыКонфигурацииXML(МассивUUID) Экспорт

	ПаттернUUID = "";
	Для Каждого UUID Из МассивUUID Цикл
		ПаттернUUID = ПаттернUUID + "|" + """" + UUID + """";
	КонецЦикла;
	ПаттернUUID = "(" + Сред(ПаттернUUID, 2) + ")";

	КомандныйФайл = Новый КомандныйФайл;
	КомандныйФайл.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
	КомандныйФайл.УстановитьПриложение("""C:/Program files/Git/bin/bash.exe""");
	КомандныйФайл.Создать("", ".sh");

	Расширение = ".xml";
	ПутьКИсходномуКоду = СтрЗаменить(ПутьКИсходномуКоду, "\", "/");
	Команда = "grep -Er --with-filename 'uuid=" + ПаттернUUID + "' " + ПутьКИсходномуКоду +
	" | awk -F'\\" + Расширение + "' '{print $1""" + Расширение + """}' | uniq";

	КомандныйФайл.ДобавитьКоманду(Команда);

	КодВозврата = КомандныйФайл.Исполнить();
	Ожидаем.Что(КодВозврата).Равно(0);

	Вывод = КомандныйФайл.ПолучитьВывод();
	ФайлыКонфигурации = СтрРазделить(Вывод, Символы.ПС, Ложь);
	
	Возврат ФайлыКонфигурации;

КонецФункции

Функция НайтиФайлыКонфигурацииEDT(МассивUUID) Экспорт

	ПаттернUUID = "";
	Для Каждого UUID Из МассивUUID Цикл
		ПаттернUUID = ПаттернUUID + "|" + """" + UUID + """";
	КонецЦикла;
	ПаттернUUID = "(" + Сред(ПаттернUUID, 2) + ")";

	КомандныйФайл = Новый КомандныйФайл;
	КомандныйФайл.УстановитьКодировкуВывода(КодировкаТекста.UTF8NoBOM);
	КомандныйФайл.УстановитьПриложение("""C:/Program files/Git/bin/bash.exe""");
	КомандныйФайл.Создать("", ".sh");

	Расширение = ".mdo";
	ПутьКИсходномуКоду = СтрЗаменить(ПутьКИсходномуКоду, "\", "/");
	Команда = "grep -Er --with-filename '(mdclass|forms|commands).*uuid=" + ПаттернUUID + "' " + ПутьКИсходномуКоду +
	" | awk -F'\\" + Расширение + "' '{print $1""" + Расширение + """}' | uniq";
	КомандныйФайл.ДобавитьКоманду(Команда);

	КодВозврата = КомандныйФайл.Исполнить();
	Ожидаем.Что(КодВозврата).Равно(0);

	Вывод = КомандныйФайл.ПолучитьВывод();
	ФайлыКонфигурации = СтрРазделить(Вывод, Символы.ПС, Ложь);
	
	Возврат ФайлыКонфигурации;

КонецФункции

Функция СформироватьКэшКонфигурацииXML(ФайлыКонфигурации) Экспорт

	АбсолютныйПутьКИсходномуКоду = Новый Файл(ПутьКИсходномуКоду).ПолноеИмя;

	Для Каждого ФайлКонфигурации Из ФайлыКонфигурации Цикл

		ФайлКонфигурации = СокрЛП(ФайлКонфигурации);

		ОбъектМетаданных = ВыделитьОбъектМетаданныхXML(ФайлКонфигурации);

		Если ОбъектМетаданных = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		UUIDОбъекта = ОпределитьUUIDОбъекта(ОбъектМетаданных);

		ФайлКонфигурацииФайл = Новый Файл(ФайлКонфигурации);
		ПутьКФайлуБезРасширения = ОбъединитьПути(ФайлКонфигурацииФайл.Путь, ФайлКонфигурацииФайл.ИмяБезРасширения);
		ПутьКОбъекту = ФС.ОтносительныйПуть(АбсолютныйПутьКИсходномуКоду, ПутьКФайлуБезРасширения);
		
		ИмяФормы = "";
		ЭтоФорма = СтрНайти(ПутьКОбъекту, "Forms" + ПолучитьРазделительПути());

		Если ЭтоФорма Тогда
			ИмяФормы = ОбъектМетаданных._Элементы["Properties"]["Name"];
		КонецЕсли;

		ЗаписатьОбъектВКэшКонфигурации(UUIDОбъекта, ПутьКОбъекту, , ИмяФормы);
		ОбработатьКомандыОбъектаXML(ОбъектМетаданных, ПутьКОбъекту);

	КонецЦикла;

	Возврат КэшКонфигурации;

КонецФункции

Функция СформироватьКэшКонфигурацииEDT(ФайлыКонфигурации) Экспорт

	АбсолютныйПутьКИсходномуКоду = Новый Файл(ПутьКИсходномуКоду).ПолноеИмя;

	Для Каждого ФайлКонфигурации Из ФайлыКонфигурации Цикл

		ФайлКонфигурации = СокрЛП(ФайлКонфигурации);

		ОбъектМетаданных = ВыделитьОбъектМетаданныхEDT(ФайлКонфигурации);

		Если ОбъектМетаданных = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		UUIDОбъекта = ОпределитьUUIDОбъекта(ОбъектМетаданных);
		
		ФайлКонфигурацииФайл = Новый Файл(ФайлКонфигурации);
		ПутьКФайлуБезРасширения = ОбъединитьПути(ФайлКонфигурацииФайл.Путь, ФайлКонфигурацииФайл.ИмяБезРасширения);
		ПутьКОбъекту = ФС.ОтносительныйПуть(АбсолютныйПутьКИсходномуКоду, ФайлКонфигурацииФайл.Путь);
		
		ЗаписатьОбъектВКэшКонфигурации(UUIDОбъекта, ПутьКОбъекту);
		ОбработатьКомандыОбъектаEDT(ОбъектМетаданных, ПутьКОбъекту);

	КонецЦикла;

	Возврат КэшКонфигурации;

КонецФункции

Функция ВыделитьОбъектМетаданныхEDT(ПутьКФайлу)

	ПроцессорXML = Новый СериализацияДанныхXML;
	РезультатЧтенияXML = ПроцессорXML.ПрочитатьИзФайла(ПутьКФайлу);

	ОбъектМетаданных = ПолучитьОбъектМетаданныхEDT(РезультатЧтенияXML);

	Возврат ОбъектМетаданных;

КонецФункции

Процедура ОбработатьКомандыОбъектаXML(ОбъектМетаданных, ПутьКОбъекту)
	
	ЭлементыУзлаОбъектМетаданных = ОбъектМетаданных._Элементы;
	ТипЗнчЭлементыУзла = ТипЗнч(ЭлементыУзлаОбъектМетаданных);
	
	ДочерниеОбъекты = Неопределено;
	Если ТипЗнчЭлементыУзла = Тип("Соответствие") Тогда
		
		ДочерниеОбъекты = ЭлементыУзлаОбъектМетаданных["ChildObjects"];
		
	ИначеЕсли ТипЗнчЭлементыУзла = Тип("Массив") Тогда
		
		Для Каждого Элемент Из ЭлементыУзлаОбъектМетаданных Цикл
			ДочерниеОбъекты = Элемент["ChildObjects"];
			
			Если ДочерниеОбъекты <> Неопределено Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		Лог.Отладка("Поведение не определено");
	КонецЕсли;
	
	Если ДочерниеОбъекты = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ДочерниеОбъекты) = Тип("Соответствие") Тогда

		Команда = ДочерниеОбъекты["Command"];
		
		Если Команда = Неопределено Тогда
			Возврат;
		КонецЕсли;
			
		UUIDКоманды = Команда._Атрибуты["uuid"];
		ИмяКоманды = Команда._Элементы["Properties"]["Name"];
		ЗаписатьОбъектВКэшКонфигурации(UUIDКоманды, ПутьКОбъекту, ИмяКоманды);

	ИначеЕсли ТипЗнч(ДочерниеОбъекты) = Тип("Массив") Тогда

		Для Каждого ДочернийОбъект Из ДочерниеОбъекты Цикл

			Команда = ДочернийОбъект["Command"];

			Если Команда = Неопределено Тогда
				Продолжить;
			КонецЕсли;
				
			UUIDКоманды = Команда._Атрибуты["uuid"];
			ИмяКоманды = Команда._Элементы["Properties"]["Name"];
			ЗаписатьОбъектВКэшКонфигурации(UUIDКоманды, ПутьКОбъекту, ИмяКоманды);

		КонецЦикла;

	Иначе

		ВызватьИсключение("Not implemented exception");

	КонецЕсли;

КонецПроцедуры

Функция ВыделитьОбъектМетаданныхXML(ПутьКФайлу)

	ПроцессорXML = Новый СериализацияДанныхXML;
	РезультатЧтенияXML = ПроцессорXML.ПрочитатьИзФайла(ПутьКФайлу);

	УзелОбъявленияМетаданного = РезультатЧтенияXML["MetaDataObject"];
	Если УзелОбъявленияМетаданного = Неопределено Тогда
		Лог.Отладка("Не удалось определить узел объекта метаданных (" + ПутьКФайлу + ")");
		Возврат Неопределено;
	КонецЕсли;

	ОбъектМетаданных = ПолучитьОбъектМетаданныхXML(УзелОбъявленияМетаданного);

	Возврат ОбъектМетаданных;

КонецФункции

Функция ПолучитьОбъектМетаданныхXML(УзелОбъявленияМетаданного)

	ОбъектМетаданных = Неопределено;

	Для Каждого ВидОбъектаМетаданных Из ВидыОбъектовМетаданныхСМодулями Цикл

		ОбъектМетаданных = УзелОбъявленияМетаданного._Элементы[ВидОбъектаМетаданных];

		Если ОбъектМетаданных <> Неопределено Тогда
			Возврат ОбъектМетаданных;
		КонецЕсли;

	КонецЦикла;

	Возврат ОбъектМетаданных;

КонецФункции

Функция ПолучитьОбъектМетаданныхEDT(УзелОбъявленияМетаданного)

	ОбъектМетаданных = Неопределено;

	Для Каждого ВидОбъектаМетаданных Из ВидыОбъектовМетаданныхСМодулями Цикл

		ОбъектМетаданных = УзелОбъявленияМетаданного[ВидОбъектаМетаданных];

		Если ОбъектМетаданных <> Неопределено Тогда
			Возврат ОбъектМетаданных;
		КонецЕсли;

	КонецЦикла;

	Возврат ОбъектМетаданных;

КонецФункции

Функция ОпределитьUUIDОбъекта(ОбъектМетаданных)

	UUIDОбъекта = ОбъектМетаданных._Атрибуты["uuid"];

	Если UUIDОбъекта = Неопределено Тогда
		Лог.Ошибка("Не удалось определить uuid (" + ОбъектМетаданных + ")");
	КонецЕсли;

	Возврат UUIDОбъекта;

КонецФункции

Процедура ОбработатьКомандыОбъектаEDT(ОбъектМетаданных, ПутьКОбъекту)
	
	ЭлементыУзлаОбъектМетаданных = ОбъектМетаданных._Элементы;
	ТипЗнчЭлементыУзла = ТипЗнч(ЭлементыУзлаОбъектМетаданных);

	Если ТипЗнчЭлементыУзла = Тип("Соответствие") Тогда
		
		ОбработатьКомандуИФормуEDT(ЭлементыУзлаОбъектМетаданных, ПутьКОбъекту);
		
	ИначеЕсли ТипЗнчЭлементыУзла = Тип("Массив") Тогда
		
		Для Каждого ЭлементУзлаОбъектМетаданных Из ЭлементыУзлаОбъектМетаданных Цикл
			
			ОбработатьКомандуИФормуEDT(ЭлементУзлаОбъектМетаданных, ПутьКОбъекту);
			
		КонецЦикла;
		
	Иначе
		Лог.Отладка("Поведение не определено");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьКомандуИФормуEDT(Элемент, ПутьКОбъекту)

	Команда = Элемент["commands"];
	Если Команда <> Неопределено Тогда
		
		UUIDКоманды = Команда._Атрибуты["uuid"];
		
		Если ТипЗнч(Команда._Элементы) = Тип("Соответствие") Тогда
			
			ИмяКоманды = Команда._Элементы["name"];
			ЗаписатьОбъектВКэшКонфигурации(UUIDКоманды, ПутьКОбъекту, ИмяКоманды);
			
		ИначеЕсли ТипЗнч(Команда._Элементы) = Тип("Массив") Тогда
			
			Для Каждого ЭлементКоманды Из Команда._Элементы Цикл

				ИмяКоманды = ЭлементКоманды["name"];
				
				Если ИмяКоманды <> Неопределено Тогда
					ЗаписатьОбъектВКэшКонфигурации(UUIDКоманды, ПутьКОбъекту, ИмяКоманды);
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			ВызватьИсключение("Неизвестный формат выгрузки");
			
		КонецЕсли;

	КонецЕсли;

	Форма = Элемент["forms"];
	Если Форма <> Неопределено Тогда
		
		UUIDФормы = Форма._Атрибуты["uuid"];

		Если ТипЗнч(Форма._Элементы) = Тип("Соответствие") Тогда
			ИмяФормы = ОпределитьИмяФормы(Форма);
			ЗаписатьОбъектВКэшКонфигурации(UUIDФормы, ПутьКОбъекту, , ИмяФормы);
		ИначеЕсли ТипЗнч(Форма._Элементы) = Тип("Массив") Тогда
			Для Каждого Элемент Из Форма._Элементы Цикл
				
				ИмяФормы = Элемент["name"];
				Если ИмяФормы <> Неопределено Тогда
					ЗаписатьОбъектВКэшКонфигурации(UUIDФормы, ПутьКОбъекту, , ИмяФормы);
					Прервать;
				КонецЕсли;

			КонецЦикла;
		Иначе
			ВызватьИсключение("Неизвестный формат выгрузки");
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаписатьОбъектВКэшКонфигурации(UUID, ПутьКОбъекту, ИмяКоманды = "", ИмяФормы = "")

	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИдОбъекта", UUID);

	НайденныеСтроки = КэшКонфигурации.НайтиСтроки(СтруктураОтбора);

	Если НайденныеСтроки.Количество() = 0 Тогда
		
		СтрокаКэша = КэшКонфигурации.Добавить();
		
		СтрокаКэша.ИдОбъекта = UUID;
		СтрокаКэша.ПутьКОбъекту = ПутьКОбъекту;
		СтрокаКэша.ИмяКоманды = ИмяКоманды;
		СтрокаКэша.ИмяФормы = ИмяФормы;

	ИначеЕсли НайденныеСтроки.Количество() = 1 Тогда
		ВызватьИсключение("Обнаружен дубль в кэше конфигурации");
	Иначе
		ВызватьИсключение("Ошибка формирования кэша конфигурации");
	КонецЕсли;
		
КонецПроцедуры

Функция ОпределитьИмяФормы(Форма)

	ИмяФормы = "";

	Для Каждого Элемент Из Форма._Элементы Цикл

		ИмяФормы = Элемент["name"];
		Если ЗначениеЗаполнено(ИмяФормы) Тогда

			Возврат ИмяФормы;

		КонецЕсли;

	КонецЦикла;

	Возврат ИмяФормы;

КонецФункции


Функция ВидыОбъектовМетаданныхСМодулями()

	ВидыОбъектовМетаданных = Новый Массив();

	ВидыОбъектовМетаданных.Добавить("Configuration");
	ВидыОбъектовМетаданных.Добавить("AccumulationRegister");
	ВидыОбъектовМетаданных.Добавить("Catalog");
	ВидыОбъектовМетаданных.Добавить("Form");
	ВидыОбъектовМетаданных.Добавить("CommonCommand");
	ВидыОбъектовМетаданных.Добавить("CommonForm");
	ВидыОбъектовМетаданных.Добавить("CommonModule");
	ВидыОбъектовМетаданных.Добавить("DocumentJournal");
	ВидыОбъектовМетаданных.Добавить("Document");
	ВидыОбъектовМетаданных.Добавить("HTTPService");
	ВидыОбъектовМетаданных.Добавить("Report");
	ВидыОбъектовМетаданных.Добавить("WebService");

	Возврат ВидыОбъектовМетаданных;

КонецФункции
