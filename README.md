# Monitoring Service for Process "test"

Этот сервис предназначен для мониторинга процесса `test` и проверки доступности удалённого сервера. Если процесс недавно перезапущен или сервер недоступен, информация пишется в лог `/var/log/monitoring.log`.

---

## Установка

### 1. Сценарий мониторинга

1. Скопируйте скрипт в `/usr/local/bin/`:

`sudo cp monitoring.sh /usr/local/bin/monitoring.sh`

2. Сделайте его исполняемым:

`sudo chmod +x /usr/local/bin/monitoring.sh`

3. Убедитесь, что файл лога существует, или создайте его:

`sudo touch /var/log/monitoring.log`  
`sudo chown $(whoami) /var/log/monitoring.log`  
`sudo chmod 644 /var/log/monitoring.log`

---

### 2. Systemd сервис

1. Скопируйте юнит в `/etc/systemd/system/`:

`sudo cp monitoring.service /etc/systemd/system/monitoring.service`

2. Перезагрузите конфигурацию systemd:

`sudo systemctl daemon-reload`

3. Включите сервис, чтобы он запускался автоматически при старте системы:

`sudo systemctl enable monitoring.service`

4. Запустите сервис вручную:

`sudo systemctl start monitoring.service`

5. Проверка статуса сервиса:

`systemctl status monitoring.service`

6. Просмотр логов сервиса:

`journalctl -u monitoring.service -f`

---

## Настройка интервала проверки и URL

В файле `monitoring.sh` можно изменить следующие переменные:

- `MONITOR_URL="https://test.com/monitoring/test/api"` — URL для проверки доступности сервера  
- `RESTART_THRESHOLD=60` — интервал проверки и порог для недавнего перезапуска процесса (в секундах)  
- `PROCESS_NAME="top"` — имя процесса, который нужно мониторить  
- `LOG_FILE="/var/log/monitoring.log"` — путь к лог-файлу

После изменения настроек перезапустите сервис:

`sudo systemctl restart monitoring.service`

---

## Примечания

- Скрипт работает в фоне и проверяет процесс и доступность сервера с заданной периодичностью.  
- Если скрипт завершится, systemd автоматически его перезапустит (`Restart=always`).  
- Лог `/var/log/monitoring.log` должен быть доступен для записи пользователю, под которым запускается скрипт.
