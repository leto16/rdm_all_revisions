#All revisions

##Установка

Копируем папку с плагином в {redmine_install_dir}/plugins

``` sh
cd {redmine_install_dir}
```
затем

``` sh
ruby bin/rake redmine:plugins:migrate RAILS_ENV=”production”
```

Перезапускаем Redmine.
