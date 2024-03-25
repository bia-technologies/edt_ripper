# Определение переменной VERSION с помощью выполнения команды oscript -version
VERSION := $(shell oscript -version)

# Переменная параметров сборки пакета модуля с учетом версии oscript
ifeq ($(VERSION), 1.0.19.105)
	BUILD_PARAMS := build -mf ./packagedef -out .
else
	BUILD_PARAMS := build -m ./packagedef -o .
endif

# Переменная параметров установки модуля из пакета *.ospx
INSTALL_PARAMS := install -f *.ospx

# Переменная для максимальной длины строки сообщения
MAX_LENGTH := 90

# Команда build
build:
	@$(call print_message, "Собираем пакет модуля edt-ripper")
	@$(call print_message, "Используемые параметры: $(BUILD_PARAMS)")
	@opm $(BUILD_PARAMS)
	@$(call print_message, "Пакет edt-ripper успешно построен!")

# Команда install
install:
	@$(call print_message, "Важно! Для корректной установки нужны права администратора")
	@$(call print_message, "Устанавливаем пакет edt-ripper")
	@opm $(INSTALL_PARAMS)

# Функция, которая выводит сообщение в рамке из символов
# Аргумент: $(1) - сообщение
define print_message
	$(eval MSG_TRUNCATED := $(shell echo "$(1)" ))
	$(eval MSG_LEN := $(shell echo '$(MSG_TRUNCATED)' | wc -m))
	$(eval MSG_SPACES := $(shell expr "$(MAX_LENGTH)" - "$(MSG_LEN)"))
	$(info ┌$(shell printf "─%.0s" $$(seq 1 $(MAX_LENGTH)))┐)
	$(info │ $(MSG_TRUNCATED)$(shell printf '%-$(MSG_SPACES)s')|)
	$(info └$(shell printf "─%.0s" $$(seq 1 $(MAX_LENGTH)))┘)
endef