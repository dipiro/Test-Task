# Test Tasks #


### Test One ###

Реализовать консольное приложение на языке swift, которое будет решать квадратные уравнения. Приложение должно давать возможность ввести коэффициенты a, b, c, после чего выдавать значения дискриминанта и корней. После того, как приложение решило текущее квадратное уравнение, должна быть возможность ввести новые значения для коэффициентов a, b и с. Так же должна быть реализована возможность выхода из приложения по желанию пользователя после выдачи посчитанных значений. Коэффициенты уравнения должны иметь значения по умолчанию. Если пользователь не ввел никакого значения для коэффициента, то при решении должно использоваться дефолтное значение. Так же приложение должно обрабатывать некорректные данные (ввод букв вместо цифр и т.д.) и предлагать ввести значение для коэффициента заново, пока пользователь не введёт корректное значение.

### Test Two ###

Разработать приложение, которое реализует функционал загрузки музыкальных файлов 
 и позволяет их проигрывать. Приложение состоит из двух экранов,

На первом и главном экране представлен список музыкальных композиций.

Для каждой композиции на этом экране будут доступны действия: "начать загрузку", "остановить загрузку". При остановке загрузки, позиция запоминается. По нажатию на кнопку начала загрузки, продолжать с той позиции, на которой остановились.Так же для каждой композиции должен отображаться индикатор загрузки - прогресс-бар.При нажатии на конкретную композицию из списка приложение переходит на второй экран.

Для реализации должна использоваться таблица, в header-е которой будет представлен проигрыватель, позволяющий проигрывать выбранную композицию, если она полностью загружена. Кнопка запуска проигрывание должна быть недоступна, если файл не загружен.

На втором экране должна выводиться метаинформация о файле, если она в наличии. Кроме того на втором экране есть возможность удалить загруженный медиа файл (или его загруженную часть) - кнопка «Удалить». В случае, если файл (или его часть) удален, начало загрузки должно происходить заново и соответственно прогресс-бар должен будет всегда отображать актуальный статус.

Дизай приложения (названия кнопок, цветовая гамма и т.п.) на ваше усмотрение, и допускаются максимально стандартными.

Требования:
Использовать только стандартные фреймворки из Cocoa SDK: Foundation, CoreData, AVFoundation, AVKit и так далее.
