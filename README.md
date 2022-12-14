# edt-ripper

Консольная утилита для работы с замечаниями ЕДТ и файлами правил для SQ. выполняет разбор EDT отчета анализа проекта. Формирует результат в формате bsl-ls.
Мапит обнаруженные замечания с правилами (внутренний файл правил, внешний файл правил)

## Возможности

 1. Команда `parse` - Преобразует файл с результатом анализа проекта из ЕДТ в отчет формата BSL LS. Если замечание будет новое, для которого еще нет правила, оно будет добавлено в хранилище правил.

 2. Команда `publish` - удалит всю служебную информацию из хранилища правил. Итоговый файл готов к загрузке в SQ.

## Ограничения

+ Версия EDT > 2021.2

## Предварительные настройки и порядок использования

Действия выполняются через UI SQ или через sonar.properties

+ Активировать в SQ свойство `sonar.bsl.edt.enabled`
+ Активировать в SQ свойство `sonar.bsl.edt.createExternalIssues` - опционально, но количество внешних замечаний позволит замечать необходимость обновить правила.
+ Заполнить в SQ свойство `sonar.bsl.edt.rulesPaths` и положить ваш файл с правилами (или экспортированный командой `publish`) по этому пути в SQ.
+ Перезагрузить SQ чтобы правила отобразились в связанных с EDT профилях качества.
+ Проверить что правила появились. Ввиду особенности работы SQ может потребоваться удалить и установить плагин sonar-bsl чтобыправила обновились в профиле качества.
+ Путь к файлу с результатом работы программы указывается в свойстве `sonar.bsl.languageserver.reportPaths` сканера SQ

## Пример использования

+ Разобрать замечания ЕДТ для проекта *configuration* в репозитории *my_awersome_rep*  с внешним файлом правил и создать отчет *out.json*.

```
 edt-ripper -f /mnt/share/custom-rules.json parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json
```

+ Разобрать замечания ЕДТ для проекта *configuration* в репозитории *my_awersome_rep* с внутренним файлом правил и создать отчет *out.json*

```
 edt-ripper  parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json
```

+ Разобрать замечания для проектов  *configuration* и *exts* в репозитории *my_awersome_rep* с внутренним файлом правил и создать отчет *out.json*

```
 edt-ripper  parse ./edt-validate-results ./my_awersome_rep/ configuration exts ./out.json
```

## todo

+ Поддержка файла исключений
+ Хранение и обновление файла custom-rules на Nexus
+ Команда для мержа n разных файлов правил
