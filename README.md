# PRUEBA TECNICA

## Se deberá construir una aplicación móvil de tipo pokedex que cumpla con los siguientes requerimientos:
* Lista de pokemones con nombre, imagen y tipo.
* Filtro que me permita buscar por nombre y tipo.
*Información (descripción, estatura, peso, categoría, habilidades, estadísticas, debilidades) de cada uno de los pokemones en cada una de sus evoluciones.

## NOTA
> Los servicios necesarios estarán expuestos bajo el siguiente dominio: [POKE API](https://pokeapi.co/)

## First commit: Project configured to start
* Storyboard eliminado
* rootViewController asignado a navController en SceneDelegate
* Añadida extension que convierte colores hexadecimales a rgb)
* Configuraciones iniciales del CollectionViewController (Tatodex) y del NavigationController (navController)

## Second commit 
* Creada la Develop branch
* Corregido el layout en SceneDelegate, de UICollectionViewLayout > UICollectionViewFlowLayout
* Custom Colors refactorizado, Custom Labels eliminado. Añadida una extensión para layouts. Todo fue movido a Extensions.swift
* Creado un TatodexCell para manejar las celdas de la app
* Añadida la disposición estándar de las CollectionViewCells:
    > imageView: Muestra la imagen de cada Pokemon
    > nameContainerView: Fondo de donde se muestra el nombre del Pokemon
    > nameLabel: Nombre del pokemon en la celda
* Instalados Alamofire y SwiftyJSON para el parsing
