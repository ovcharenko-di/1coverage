
// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd

Перем БДД; //контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЗапущенПроцессСPIDКоторыйУказанВСтрокеФайла");
	ВсеШаги.Добавить("ЯЗавершаюПроцессСPIDКоторыйУказанВСтрокеФайла");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

//запущен процесс с PID который указан в строке "1" файла "./build/PID"
Процедура ЗапущенПроцессСPIDКоторыйУказанВСтрокеФайла(Знач НомерСтроки, Знач ПутьКФайлу) Экспорт

	ФайлPID = Новый ТекстовыйДокумент();
	ФайлPID.Прочитать(ПутьКФайлу, КодировкаТекста.UTF8);
	PID = ФайлPID.ПолучитьСтроку(НомерСтроки);

	Процесс = НайтиПроцессПоИдентификатору(PID);
	ПроцессЗапущен = Процесс <> Неопределено;

	Ожидаем.Что(ПроцессЗапущен).Равно(Истина);

КонецПроцедуры

//И я завершаю процесс с PID который указан в строке "1" файла "./build/PID"
Процедура ЯЗавершаюПроцессСPIDКоторыйУказанВСтрокеФайла(Знач НомерСтроки, Знач ПутьКФайлу) Экспорт

	ФайлPID = Новый ТекстовыйДокумент();
	ФайлPID.Прочитать(ПутьКФайлу, КодировкаТекста.UTF8);
	PID = ФайлPID.ПолучитьСтроку(НомерСтроки);

	КонсольнаяКоманда = Новый Команда;
	КонсольнаяКоманда.УстановитьКоманду("taskkill");
	КонсольнаяКоманда.ДобавитьПараметр("/F /PID " + PID + " /T");

	КодВозврата = КонсольнаяКоманда.Исполнить();

	Ожидаем.Что(КодВозврата).Равно(0);

КонецПроцедуры
