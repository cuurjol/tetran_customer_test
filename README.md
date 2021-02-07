# Тестовое задание для компании [Tetran](http://tetran.pro/)

#### Создаем RoR приложение (RoR версии 5):
- На главной странице отображаем список клиентов (модель Customer).
- В списке клиентов должна быть возможность их редактировать и добавить любого в "черный список".
- При добавлении клиента в черный список - запись о нем пропадает с главной страницы и появляется на отдельной странице "Черный список".
- В приложении должна быть возможность перейти на страницу "Черный список" - где можно посмотреть клиентов, которых мы добавили в черный список. 

#### Что еще должно быть на странице "черный список":
- должна быть форма, которая позволит по телефону добавить клиента в этот список
- в списке должны быть кнопки, которые позволяют исключить любого из "черного списка"
 
#### Параметры модели Customer:
- имя
- телефон
- описание
- присутствует или нет в черном списке
 
 # Запуск приложения
 
 Для того, чтобы запустить приложение, выполните следующие команды у себя в окне терминала:
 
 * Склонируйте репозиторий с GitHub и перейдите в папку приложения:
 ```
 git clone https://github.com/cuurjol/tetran_customer_test.git
 cd tetran_customer_test
 ```
 
 * Установите необходимые гемы приложения, указанные в файле `Gemfile`:
 ```
 bundle install
 ```
 
 * Создайте базу данных, запустите миграции для базы данных и файл `seeds.rb` для создания записей в базу данных:
 ```
 bundle exec rake db:create
 bundle exec rake db:migrate
 bundle exec rake db:seed
 ```
 Приложение использует СУБД `Postgresql`. При необходимости создайте нового пользователя в СУБД для этого приложения 
 или измените СУБД на другую, изменив настройки файла `config/database.yml`.
 
 * Запустите приложение:
 ```
 bundle exec rails server
 ```