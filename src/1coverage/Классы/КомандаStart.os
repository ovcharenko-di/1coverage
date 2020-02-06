
Перем Лог;

Перем СтрокаСоединенияСИБ;
Перем ХостСервераОтладки;
Перем ПортСервераОтладки;
Перем ПутьКЛогамПрокси;
Перем ПортПрокси;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("ibconnection", "", "строка соединения с информационной базой")
		.ТСтрока();
	Команда.Опция("dbgs-host", "", "хост сервера отладки")
		.ТСтрока();
	Команда.Опция("dbgs-port", "", "порт сервера отладки")
		.ТСтрока();
	Команда.Опция("logpath", "", "путь к логам прокси-сервера")
		.ТСтрока();
	Команда.Опция("dbgs-proxy-port", "", "порт прокси сервера")
		.ТСтрока();

КонецПроцедуры

Процедура ПередВыполнениемКоманды(Знач Команда) Экспорт

	Лог = ПараметрыПриложения.Лог();

	СтрокаСоединенияСИБ = Команда.ЗначениеОпции("ibconnection");
	ХостСервераОтладки = Команда.ЗначениеОпции("dbgs-host");
	ПортСервераОтладки = Команда.ЗначениеОпции("dbgs-port");
	ПутьКЛогамПрокси = Команда.ЗначениеОпции("logpath");
	ПортПрокси = Команда.ЗначениеОпции("dbgs-proxy-port");

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
	КонсольнаяКоманда.ДобавитьПараметр("-a ");
	КонсольнаяКоманда.ДобавитьПараметр(ХостСервераОтладки);
	КонсольнаяКоманда.ДобавитьПараметр("-p");
	КонсольнаяКоманда.ДобавитьПараметр(ПортСервераОтладки);

	КонсольнаяКоманда.ПерехватыватьПотоки(Ложь);
	КонсольнаяКоманда.ПоказыватьВыводНемедленно(Ложь);

	ПроцессСервераОтладки = КонсольнаяКоманда.ЗапуститьПроцесс();

	PIDСервераОтладки = ПроцессСервераОтладки.Идентификатор;
	
	Если ПроцессСервераОтладки.Завершен Тогда
		Если ПроцессСервераОтладки.КодВозврата <> 0 Тогда
			ВызватьИсключение("Не удалось запустить сервер отладки 1С");
		КонецЕсли;
	КонецЕсли;

	ЗаписатьPIDПроцессаВФайл(PIDСервераОтладки);
	Лог.Информация("Запущен сервер отладки 1С: " + PIDСервераОтладки);

КонецПроцедуры

Процедура ЗапуститьПрокси()

	ШаблонURL = "http://%1:%2";
	URLОтладчика = СтрШаблон(ШаблонURL, ХостСервераОтладки, ПортСервераОтладки);

	КонсольнаяКоманда = Новый Команда;
	КонсольнаяКоманда.УстановитьКоманду("npm");
	КонсольнаяКоманда.ДобавитьПараметр("--prefix");
	КонсольнаяКоманда.ДобавитьПараметр(ПараметрыПриложения.КаталогПроекта);
	КонсольнаяКоманда.ДобавитьПараметр("start");
	КонсольнаяКоманда.ДобавитьПараметр("--");
	КонсольнаяКоманда.ДобавитьПараметр("--logpath");
	КонсольнаяКоманда.ДобавитьПараметр(ПутьКЛогамПрокси);
	КонсольнаяКоманда.ДобавитьПараметр("--debuggerURL");
	КонсольнаяКоманда.ДобавитьПараметр(URLОтладчика);
	КонсольнаяКоманда.ДобавитьПараметр("--dbgsProxyPort");
	КонсольнаяКоманда.ДобавитьПараметр(ПортПрокси);

	КонсольнаяКоманда.ПерехватыватьПотоки(Истина);
	КонсольнаяКоманда.ПоказыватьВыводНемедленно(Истина);
	
	ПроцессПрокси = КонсольнаяКоманда.ЗапуститьПроцесс();

	Если ПроцессПрокси.Завершен Тогда
		Если ПроцессПрокси.КодВозврата <> 0 Тогда
			ВызватьИсключение("Не удалось запустить прокси-сервер");
		КонецЕсли;
	КонецЕсли;

	PIDПрокси = ПроцессПрокси.Идентификатор;
	ЗаписатьPIDПроцессаВФайл(PIDПрокси);
	Лог.Информация("Запущен прокси: " + PIDПрокси);

КонецПроцедуры

Процедура ОткрытьКонфигуратор()

	ИмяПользователяИБ = "";
	ПарольПользователяИБ = "";

	КонсольнаяКоманда = Новый Команда;
	КонсольнаяКоманда.УстановитьКоманду("C:\Program files\1cv8\8.3.16.1063\bin\1cv8.exe");
	КонсольнаяКоманда.ДобавитьПараметр("DESIGNER");
	КонсольнаяКоманда.ДобавитьПараметр(СтрокаСоединенияСИБ);
	КонсольнаяКоманда.ПерехватыватьПотоки(Ложь);
	КонсольнаяКоманда.ПоказыватьВыводНемедленно(Ложь);
	
	Если ЗначениеЗаполнено(ИмяПользователяИБ) Тогда
		КонсольнаяКоманда.ДобавитьПараметр("/N" + ИмяПользователяИБ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПарольПользователяИБ) Тогда
		КонсольнаяКоманда.ДобавитьПараметр("/P" + ПарольПользователяИБ);
	КонецЕсли;
	
	ПроцессКонфигуратора = КонсольнаяКоманда.ЗапуститьПроцесс();

	Если ПроцессКонфигуратора.Завершен Тогда
		Если ПроцессКонфигуратора.КодВозврата <> 0 Тогда
			ВызватьИсключение("Не удалось открыть конфигуратор");
		КонецЕсли;
	КонецЕсли;

	PIDКонфигуратора = ПроцессКонфигуратора.Идентификатор;
	ЗаписатьPIDПроцессаВФайл(PIDКонфигуратора);
	Лог.Информация("Открыт конфигуратор 1С: " + PIDКонфигуратора);

КонецПроцедуры

Процедура ЗаписатьPIDПроцессаВФайл(PID)

	ПутьКФайлуPID = ОбъединитьПути("build", "PID");
	ФайлPID = Новый ЗаписьТекста(ПутьКФайлуPID, КодировкаТекста.UTF8, , Истина);
	ФайлPID.ЗаписатьСтроку(PID);
	ФайлPID.Закрыть();
	
КонецПроцедуры
