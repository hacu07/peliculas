
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppBar(movie),
          //es el body
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              _posterTitulo(context, movie),
              _descripcion(movie),
              _descripcion(movie),
              _descripcion(movie),
              _descripcion(movie),
              _crearCasting(movie),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _crearAppBar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(movie.title),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _posterTitulo(BuildContext context, Movie movie) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image( 
                  image: NetworkImage(movie.getPosterImg()),
                  height: 150.0,
                ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: Theme.of(context).textTheme.headline6,overflow: TextOverflow.ellipsis,),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.subtitle1,overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(),style: Theme.of(context).textTheme.subtitle1,overflow: TextOverflow.ellipsis)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcion(Movie movie){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Movie movie){
    final moviesProvider = new MoviesProvider();

    return FutureBuilder(
      future: moviesProvider.getActors(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false, //para que el movimiento sea mas fluido de los items
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context,itemPosition){
          return _actorTarjeta(actores[itemPosition]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getProfileImg()),
              height: 150.0,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 200),
            ),
          ),
          Center(
            child: Text(
              actor.name,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}