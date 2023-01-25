# Практическая работа №1
## Тема: Создание учетной записи GitHub
### Цель работы: познакомиться с GitHub, создать учетную запись и загрузить на удаленный репозиторий.

### Ход работы:

Git – это распределенная система контроля версий, которая позволяет нескольким разработчикам одновременно работать над одним продуктом.

1.	Заходим на сайт github.com и нажимаем кнопку Sign Up
 
![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git1.png "SignUp")
 
2.	Вводим почту в окне

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git2.png "Email")

3.	Вводим пароль в окне

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git3.png "Password")

4.	Вводим никнейм в окне

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git4.png "Username")

5.	После создания аккаунта заходим в «Your repositories»

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git5.png "YourRepositories")

6.	В открытом окне нажимаем кнопку «New»

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git6.png "New")

7.	Вводим название репозитория и делаем его публичным.

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git7.png "NameAndPublic")

8.	Создаем папку на рабочем столе и создаем файл README.md

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git8.png "Readme")

9.	После создания файла, нажимаем ПКМ по области папки и открываем Git Bash Here в данном пути

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git9.png "GitBashHere")

10.	После необходимо зайти под свой аккаунт следующими командами:
Git config --global user.name «ФИО на английском»
Git config --global user.email «Ваша почта»

11.	Далее необходимо проинициализировать папку командой git init

12.	После инициализации нужно добавить необходимые в файлы в отслеживаемый процесс, для этого используется команда git add «файлы»

13.	После добавления файлов нужно создать коммит на отслеживаемые файлы, командой git commit -m «название коммита»

14.	Далее можно создать новую ветку с названием «pr1», для добавления различных практических работ в один репозиторий под разными ветками, для этого используется команда git checkout -b pr1 «ключ коммита»

15.	Для просмотра конкретного ключа коммита нужно прописать команду git log

16.	После прописывается команда на подключение к удаленному репозиторию, для этого используется команда git remote add origin «ссылка удаленного репозитория»

17.	И последняя команда является выгрузкой файлов на удаленный репозиторий, для этого используется команда git push origin pr1

![](https://github.com/ShubinAleksey/docker_practices/blob/pr1/Images/git10.png "Created")
 
Ссылка на репозиторий: https://github.com/ShubinAleksey/docker_practices

### Вывод: в ходе практической работы познакомился с GitHub, создал учетную запись и загрузил работу на удаленный репозиторий.
