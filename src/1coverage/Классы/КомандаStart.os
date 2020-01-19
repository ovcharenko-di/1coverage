
Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("ib-connection", "", "строка соединения с информационной базой")
		.ТСтрока();

КонецПроцедуры

Процедура ПередВыполнениемКоманды(Знач Команда) Экспорт

	Лог = ПараметрыПриложения.Лог();

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ПодготовитьКаталогиИФайлы();
	
	ЗапуститьСерверОтладки();
	ЗапуститьПрокси();
	ОткрытьКонфигуратор();
	
КонецПроцедуры

Процедура ПодготовитьКаталогиИФайлы()

	Если ФС.ФайлСуществует("./build/PID") Тогда
		УдалитьФайлы("./build/PID");
	КонецЕсли;

КонецПроцедуры

Процедура ЗапуститьСерверОтладки()

	КонсольнаяКоманда = Новый Команда;
	КонсольнаяКоманда.УстановитьКоманду("C:\Program files\1cv8\8.3.16.1063\bin\dbgs.exe");
	КонсольнаяКоманда.ДобавитьПараметр("-a localhost");
	КонсольнаяКоманда.ДобавитьПараметр("-p 1550");
	КонсольнаяКоманда.ПерехватыватьПотоки(Ложь);
	КонсольнаяКоманда.ПоказыватьВыводНемедленно(Ложь);

	ПроцессСервераОтладки = КонсольнаяКоманда.ЗапуститьПроцесс();

	PIDСервераОтладки = ПроцессСервераОтладки.Идентификатор;
	Если ПроцессСервераОтладки.Завершен Тогда
		Если ПроцессСервераОтладки.КодВозврата = 1 Тогда
			ВызватьИсключение("Не удалось запустить сервер отладки 1С");
		КонецЕсли;
	КонецЕсли;

	ЗаписатьPIDПроцессаВФайл(PIDСервераОтладки);
	Лог.Информация("Запущен сервер отладки 1С: " + PIDСервераОтладки);

КонецПроцедуры

Процедура ЗапуститьПрокси()

	ШаблонURL = "http://%1:%2";
	URLОтладчика = СтрШаблон(ШаблонURL, "localhost", "3000");

	ПеременныеСреды = Новый Соответствие();
	ПеременныеСреды.Вставить("DEBUGGER_URL", URLОтладчика);
	ПеременныеСреды.Вставить("PROXY_PORT", "3000");
	ИмяФайлаЛога = "./build";
	ПеременныеСреды.Вставить("PROXY_RESULT_DIR", ИмяФайлаЛога);
	
	КонсольнаяКоманда = Новый Команда;
	КонсольнаяКоманда.УстановитьПеременныеСреды(ПеременныеСреды);
	КонсольнаяКоманда.УстановитьКоманду("npm");
	КонсольнаяКоманда.ДобавитьПараметр("start");
	
	ПроцессПрокси = КонсольнаяКоманда.ЗапуститьПроцесс();

	Если ПроцессПрокси.Завершен Тогда
		Если ПроцессПрокси.КодВозврата = 1 Тогда
			ВызватьИсключение("Не удалось запустить прокси-сервер");
		КонецЕсли;
	КонецЕсли;
	
	PIDПрокси = ПроцессПрокси.Идентификатор;
	ЗаписатьPIDПроцессаВФайл(PIDПрокси);
	Лог.Информация("Запущен прокси: " + PIDПрокси);

КонецПроцедуры

Процедура ОткрытьКонфигуратор()

	ЗаписатьPIDПроцессаВФайл("333");

	Лог.Информация("Открыт конфигуратор");

КонецПроцедуры

Процедура ЗаписатьPIDПроцессаВФайл(PID)

	ПутьКФайлуPID = ОбъединитьПути("build", "PID");
	ФайлPID = Новый ЗаписьТекста(ПутьКФайлуPID, КодировкаТекста.UTF8, , Истина);
	ФайлPID.ЗаписатьСтроку(PID);
	ФайлPID.Закрыть();
	
КонецПроцедуры
