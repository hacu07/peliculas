import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  final moviesProvider = new MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
      // Las acciones de nuestro appbar
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = '';
          },
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icono a la izquierda del appbar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, 
          progress: transitionAnimation
        ),
        onPressed: (){
          close(context, null);
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Crea los resultados que vamos a mostrar
      return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.getMovieByQuery(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if(snapshot.hasData){
          final peliculas = snapshot.data;

           return ListView(
              children: peliculas.map((pelicula){
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage(pelicula.getPosterImg()),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(pelicula.title, overflow: TextOverflow.ellipsis,),
                  subtitle: Text(pelicula.originalTitle,overflow: TextOverflow.ellipsis,),
                  onTap: (){
                    // cuando presionen la pelicula de las opciones de busqueda,
                    // cierra y muestra el detalle
                    close(context, null);
                    pelicula.uniqueId = '${pelicula.id}-search';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList(),
           );
        }else{
          return Center(child: CircularProgressIndicator(),) ;
        }
      },
    );

  }

}