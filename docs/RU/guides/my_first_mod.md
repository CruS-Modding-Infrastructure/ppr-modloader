# Мой первый мод
[Назад](/docs/RU/main.md)

И так вы решили создать свой собственный мод для игры Psycho Patrol R
Этот небольшой гайд должен помочь в ваших начинаниях

Psycho Patrol R создана на игровом движке **Godot v3.6**
# Важно: не перепутайте версии движков
**Тот же Godot v3.6 очень сильно отличается от Godot v4.0**

Очень советую перед тем как начать создавать свои моды для игры ознакомится с документацией Godot 3.6 (Так же будет неплохо посмотреть гайды если вы прям совсем новичок)

Весь код в Godot пишется на языке программирования GDScript
Если не вдавятся в подробности данный язык очень похож на Python
# Это всё хорошо, но с чего мне начать?

Требования:
- [Godot v3.6](https://godotengine.org/download/archive/3.6-stable/)
- [Godot RE Tools](https://github.com/GDRETools/gdsdecomp/releases)
- [Psycho Patrol R Mod Loader](https://github.com/CruS-Modding-Infrastructure/ppr-modloader/releases)
- [TrenchBroom v2023.1](https://github.com/TrenchBroom/TrenchBroom/releases/tag/v2023.1) (if you're planning on making custom levels)

Инструкция:
1. Декомпилируйте файл игры `psychopatrolr.pck` с помощью Godot RE Tools ([Инструкция как это сделать здесь](https://wiki.godotmodding.com/guides/modding/tools/decompile_games/))
2. Теперь у вас есть декомпилированный Psycho Patrol R, его папку стоит переместить туда, где потом его будет легко найти
3. Скопируйте папки `addons` и `PPR_Utilities` из загрузчика модов Psycho Patrol R в декомпилированный проект
4. Откройте файл `project.godot` с помощью любого текстового редактора
5. Найдите строку `[autoload]` и вставьте эти строки прямо под ней:
```ini
PPRUtilities="*res://PPR_Utilities/init.tscn"
ModLoaderStore="*res://addons/mod_loader/mod_loader_store.gd"
ModLoader="*res://addons/mod_loader/mod_loader.gd"
```
6. Сохраните и закройте файл `project.godot`
7. Запустите Godot v3.6
8. Нажмите кнопку «Импорт» и найдите папку с декомпилированным проектом
9. «Psycho Patrol R» теперь должен быть добавлен в список проектов, и вы сможете открыть проект в Godot

Чтобы обновить ваш проект, когда PPR получит новый патч, вам нужно повторить эти инструкции. Но обязательно заранее сделайте резервную копию папки `mods-unpacked`, а потом переместите её в обновлённый проект.