# Connecting-an-MFP-printserver-
Подключение МФУ через графический интерфейс для пользователей .

Данный скрипт (Написан на Ps2) позволяет пользователям самостоятельно подключать МФУ у себя на компьютере и делать его по умолчанию. Для того чтобы скрипт заработал, нужно в нём указать на 6 строчке кода - названия print-серверов. (если их несколько, то идёт перебор по каждому.)
Также название принтеров и МФУ должно быть названо на серверах печати как (МФУ-****) где * - это цифры.
Само подключение сопровождается уведомлениями, если МФУ найден и что МФУ подключен к вашему компьютеру. Также есть небольшой обработчик ошибок если на сервере печати нет данного МФУ, указаный пользователем.


Чтобы скрипт запускался без консоли, нужно его скомпилировать через компилятор ps2exe.


