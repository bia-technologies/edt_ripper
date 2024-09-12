# edt-ripper

Консольная утилита для работы с замечаниями ЕДТ и файлами правил для SQ. выполняет разбор EDT отчета анализа проекта. Формирует результат в формате bsl-ls.
Мапит обнаруженные замечания с правилами (внутренний файл правил, внешний файл правил)

## Возможности (команды)

 1. Команда `parse` - преобразует файл с результатом анализа проекта из ЕДТ в отчет формата BSL LS. Если замечание будет новое, для которого еще нет правила, оно будет добавлено в хранилище правил.

 2. Команда `publish` - удалит всю служебную информацию из хранилища правил. Итоговый файл готов к загрузке в SQ.

## Ограничения

+ Версия EDT > 2021.2

## Предварительные настройки проекта SonarQube

Действия выполняются через UI SQ или через sonar.properties

+ Активировать в SQ свойство `sonar.bsl.edt.enabled`
+ Активировать в SQ свойство `sonar.bsl.edt.createExternalIssues` - опционально, но количество внешних замечаний позволит замечать необходимость обновить правила.
+ Заполнить в SQ свойство `sonar.bsl.edt.rulesPaths` и положить ваш файл с правилами (или экспортированный командой `publish`) по этому пути в SQ.
+ Перезагрузить SQ чтобы правила отобразились в связанных с EDT профилях качества.
+ Проверить что правила появились. Ввиду особенности работы SQ может потребоваться удалить и установить плагин sonar-bsl чтобыправила обновились в профиле качества.
+ Путь к файлу с результатом работы программы указывается в свойстве `sonar.bsl.languageserver.reportPaths` сканера SQ

## Использование

### Ключи

Ключ `--help` покажет справку по глобальным параметрам

Ключ `--version` используется для вывода на экран текущей версии программы.<br>При использовании этого ключа программа выведет на экран информацию о текущей версии и затем завершит свою работу.

Ключ `-v / --verbose` используется для включения режима подробного вывода.
<br>При использовании этого ключа программа будет выводить дополнительную информацию в процессе своей работы, чтоб может быть полезно при отладке.

Ключ `-f / --file` позволяет указать внешний путь к файлу с правилами. По-умолчанию (если не указано) будет использоваться внутренний путь до файла с правилами, расположенный в каталоге с программой.

Ключ `--export-rule-errors` указывает, следует ли сохранять ошибки, обнаруженные в процессе анализа (парсинга) замечаний в отдельный файл `custom-rules-errors.json`.

Ключ `--nexus-rules-url` указывает URL-адрес до внешнего файла правил в репозитории Nexus. Если используется этот ключ, то ключ `-f / --file` - игнорируется.

Ключ `--nexus-auth-username` указывает имя пользователя, используемое для аутентификации в Nexus. Имя пользователя обычно используется в паре с ключом `--nexus-auth-password`.

Ключ `--nexus-auth-password` указывает пароль пользователя, используемый для аутентификации в Nexus. Аналогично ключу выше, также используется в паре с ключом `--nexus-auth-username`.

Ключ `-c / --config` позволяет указать внешний путь к файлу настроек проверки.

### Переменные окружения

Переменные окружения служат в качестве альтернативы для большинства ключей.
|Переменная окружения|Тип|Ключ|
|-|-|-|
|`EDT_RIPPER_VERBOSE`|Булево|`verbose`|
|`EDT_RIPPER_RULES_FILE`|Строка|`file`|
|`EDT_RIPPER_EXPORT_RULES_ERRORS`|Булево|`export-rule-errors`|
|`EDT_RIPPER_NEXUS_RULES_URL`|Строка|`nexus-rules-url`|
|`EDT_RIPPER_NEXUS_AUTH_USERNAME`|Строка|`nexus-auth-username`|
|`EDT_RIPPER_NEXUS_AUTH_PASSWORD`|Строка|`nexus-auth-password`|
|`EDT_RIPPER_CONFIG`|Строка|`config`|

## Файл настроек проверки

Файл настроек проверки представляет собой json файл.

На текущий момент содержит настройки для отключения ошибок. При совместном использовании с настройками ".bsl-language-server.json" позволяет полностью использовать "профиль качества" из настроек репозитория.

### Раздел: diagnostics:filter_id

Используется для отключения ошибок по внутреннему коду правил EDT.

### Раздел: diagnostics:filter_code

Используется для отключения ошибок по коду правил EDT из файла правил.

Пример:
```json
 {
    "diagnostics":{
        "filter_id":[
            "com.e1c.v8codestyle.bsl:doc-comment-field-in-description-suggestion",
            "com.e1c.v8codestyle.bsl:method-optional-parameter-before-required",
            "com.e1c.v8codestyle.bsl:doc-comment-return-section-type"
        ],
        "filter_code":[
            "EDT-137",
            "EDT-216"
        ]
    }
}
```

## Примеры использования

### 1. Анализ замечаний (команда "parse")

Эта команда используется в качестве "первичной" и готовит выходной файл для публикации.

</br><b>Использование ключей</b>

+ Разобрать замечания ЕДТ для проекта *configuration* в репозитории *my_awersome_rep* с <u>внешним файлом правил</u> и создать отчет *out.json*.

```shell
edt-ripper -f /mnt/share/custom-rules.json parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json
```

+ Разобрать замечания ЕДТ для проекта *configuration* в репозитории *my_awersome_rep* с <u>внутренним файлом правил</u> и создать отчет *out.json*

```shell
 edt-ripper parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json
```

</br><b>Использование переменных окружения</b>

```shell
export EDT_RIPPER_RULES_FILE=/mnt/share/custom-rules.json

edt-ripper parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json
```

</br><b>Использование записи ошибок</b>

```shell
export EDT_RIPPER_EXPORT_RULES_ERRORS="Истина"
export EDT_RIPPER_RULES_FILE=/mnt/share/custom-rules.json

edt-ripper parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json

```

</br><b>Использование "ЗагрузчикаПравил" (взаимодействие с [Sonatype Nexus Repository](https://www.sonatype.com/products/sonatype-nexus-repository))</b>

```shell
export EDT_RIPPER_EXPORT_RULES_ERRORS="Истина"
export EDT_RIPPER_NEXUS_RULES_URL="http://localhost:8080/repository/test/edt-ripper/custom-rules.json",
export EDT_RIPPER_NEXUS_AUTH_USERNAME="adm1n",
export EDT_RIPPER_NEXUS_AUTH_PASSWORD="P@SSw0rd256",

edt-ripper parse ./edt-validate-results ./my_awersome_rep/ configuration ./out.json

```

### 2. Публикация подготовленного файла замечаний для SQ (команда "publish")

Эта команда используется в качестве "завершающей". Готовит локально публикацию файла замечаний для SQ.

</br><b>Использование переменных окружения</b>

```shell
export EDT_RIPPER_NEXUS_RULES_URL="http://localhost:8080/repository/test/edt-ripper/custom-rules.json",
export EDT_RIPPER_NEXUS_AUTH_USERNAME="adm1n",
export EDT_RIPPER_NEXUS_AUTH_PASSWORD="P@SSw0rd256",

edt-ripper "publish" "./.report/out.json"
```

---

## todo

+ Поддержка файла исключений
+ Хранение и обновление файла custom-rules на Nexus
+ Команда для мержа n разных файлов правил
