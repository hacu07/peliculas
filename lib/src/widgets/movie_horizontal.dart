import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class MovieHorizontal extends StatelessWidget {

  final List<Movie> movies;
  final Function siguientePagina;

  final _pageController = PageController(
          initialPage: 1,
          viewportFraction: 0.3,
        );

  MovieHorizontal({ @required this.movies, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int itemPosition){
          return _tarjeta(context,movies[itemPosition], _screenSize);
        },
        //children: _tarjetas(_screenSize),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Movie movie, Size screenSize){

    movie.uniqueId = '${movie.id}-tarjeta';

    final tarjeta =  Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            Hero(
              tag: movie.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(movie.getPosterImg()),
                  width: double.infinity,
                  height: screenSize.height * 0.16,
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          Navigator.pushNamed(context, 'detalle', arguments: movie);
        },
      );
  }

  /*******************************
   * Ya no se usa, se cambio por _tarjetas(params...)
   * debido a que es mas optimo usar el pageView.builder
   * en caso de solo usar el pageview solo usar este metodo.
   */
  List<Widget> _tarjetas(Size screenSize){
    return movies.map((movie){

      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                image: NetworkImage(movie.getPosterImg()),
                height: screenSize.height * 0.2,
                fadeInDuration: Duration(milliseconds: 200),
              ),
            ),
          ],
        ),
      );

    }).toList();
  }
}