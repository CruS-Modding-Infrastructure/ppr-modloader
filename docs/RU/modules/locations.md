# Locations
[Назад](/docs/RU/main.md)

Внимание: здесь описаны только возможные методы и классы модуля
Гайды по модулю можно найти на главной странице

Данный модуль позволяет взаимодействовать с локациями игры
# Методы

`new_location() -> location`  
Возвращает новую локацию

`add_location(recived_location : location) -> void`  
Добавляет новую локацию в игру  
recived_location: Новая локация которая будет добавлена в игру. Должен являться классом `location` для корректной работы

`add_object(location_id: String, path: String, position: Vector3, rotation: Vector3) -> void`  
Добавляет объект в список загрузки объектов локации  
При заходе на локацию с данным ID будет спавнить объект в указанной точке

`add_weapon(location_id: String, weapon_id: String, position: Vector3, rotation: Vector3) -> void`  
Добавляет оружие в список загрузки объектов локации  
При заходе на локацию с данным ID будет спавнить оружие в указанной точке
# Классы:

```python
class location:

id = "Test location" # ID Локации, должно быть уникально
level = "res://path_to/location.tscn" # Путь до сцены локации
description = "test :3" # Описания локации

icon = null # Иконка в меню (Не обязательно)
icon_color = Color.white # Цвет иконки в меню (Не обязательно)

spawn_points = [] # Точки спавна, локация не будет отображатся в меню если оставить пустым
indoors = false # Если True игрок заспавнится без меха
items_picked_up = []
persistent_dead = []
```