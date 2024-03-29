#Использовать fs
#Область ОписаниеПеременных

Перем ПутьПроекта; // Путь до проекта

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает путь к исходным файлам в зависимости от типа проекта
//
//  Возвращаемое значение:
//   Строка - Путь к каталогу с исходниками
//
Функция ПутьИсходников() Экспорт

	Если ЭтоЕДТ() Тогда
		Возврат ОбъединитьПути(ПутьПроекта, "src");
	ИначеЕсли ЭтоКонфигуратор() Тогда
		Возврат ПутьПроекта;
	Иначе
		ВызватьИсключение "Невозможно найти путь исходников, не определена структура выгрузки";
	КонецЕсли;

КонецФункции

// Возвращает путь к проекту
//
//  Возвращаемое значение:
//   Строка - Путь к каталогу с проектом
//
Функция ПутьПроекта() Экспорт

	Возврат ПутьПроекта;

КонецФункции

// Возвращает имя проекта найденное в пути.
//
//  Возвращаемое значение:
//   Строка - имя проекта 
//
Функция Имя() Экспорт

	Возврат ФайловыеОперации.ИмяФайлаИлиДиректории(ПутьПроекта());

КонецФункции

// Определяет какого формата выгрузка и возвращает Истину если это ЕДТ
//
//  Возвращаемое значение:
//   Булево
//
Функция ЭтоЕДТ() Экспорт
	
	СодержитФайлОписания = НайтиФайлы(ПутьПроекта(), ".project").Количество();

	СодержитКаталогПроекта = НайтиФайлы(ПутьПроекта(), "DT-INF").Количество();
	
	СодержитКаталогИсходников = НайтиФайлы(ПутьПроекта(), "src").Количество();

	Возврат СодержитФайлОписания И СодержитКаталогПроекта И СодержитКаталогИсходников;

КонецФункции

// Определяет какого формата выгрузка и возвращает Истину если это Конфигуратор
//
//  Возвращаемое значение:
//   Строка
//
Функция ЭтоКонфигуратор() Экспорт

	Возврат ЭтоКонфигураторКонфигурацияИлиРасширение() ИЛИ ЭтоКонфигураторОбработка();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоКонфигураторКонфигурацияИлиРасширение()

	СодержитФайлОписания = НайтиФайлы(ПутьПроекта(), "Configuration.xml").Количество();

	Возврат СодержитФайлОписания;

КонецФункции

Функция ЭтоКонфигураторОбработка()

	ИмяОбъекта = СтрШаблон("%1.xml",  Имя());
	СодержитФайлОписания = НайтиФайлы(ПутьПроекта(), ИмяОбъекта).Количество();
	
	Возврат СодержитФайлОписания;

КонецФункции

Процедура ПриСозданииОбъекта(Путь)

	ПутьПроекта = Путь;

КонецПроцедуры

#КонецОбласти