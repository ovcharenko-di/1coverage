# 1coverage

## Приложение OneScript для расчета покрытия исходного кода конфигураций 1С

### Состав приложения

- dbgs-proxy - логирующий реверс-прокси для 1С на node.js
- 1coverage - приложение, которое управляет сбором замеров производительности и конвертирует их в формат [genericCoverage](https://docs.sonarqube.org/latest/analysis/generic-test/) или lcov

### Принцип работы

![1coverage](./docs/1coverage.png)

dbgs-proxy работает между сервером отладки и тестируемым приложением, перехватывает и сохраняет данные замеров производительности в файл. Затем приложение конвертирует этот файл в формат genericCoverage или lcov.

### Требования к окружению

- ОС Windows
- платформа 1С версии не ниже 8.3
- Node.js
- репозиторий с конфигурацией, выгруженной в формате XML или EDT
- проект в SonarQube, связанный с целевой конфигурацией

### Благодарности

- [@asosnoviy](https://github.com/asosnoviy), автору [прототипа](https://github.com/asosnoviy/onecover-nodeproxy), который был взят за основу этого приложения
- сообществу [OneScript](http://oscript.io/) и [oscript-library](https://github.com/oscript-library), откуда я заимствовал наиболее удачные технические решения.
