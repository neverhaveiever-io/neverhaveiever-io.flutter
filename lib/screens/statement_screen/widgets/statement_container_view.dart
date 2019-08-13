import 'package:flutter/material.dart';

import 'package:never_have_i_ever/blocs/statement_bloc.dart';
import 'package:never_have_i_ever/models/category.dart';
import 'package:never_have_i_ever/models/category_icon.dart';
import 'package:never_have_i_ever/models/statement.dart';
import 'package:never_have_i_ever/screens/statement_screen/widgets/categories_view.dart';
import 'package:never_have_i_ever/screens/statement_screen/widgets/statement_view.dart';

class StatementContainerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatementContainerViewState();
}

class _StatementContainerViewState extends State<StatementContainerView> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<CategoryIcon> categories = [
    CategoryIcon(
        name: Category.harmless,
        selectedImageUri: 'images/mojito.png',
        unselectedImageUri: 'images/mojito_gray.png',
        selected: true),
    CategoryIcon(
        name: Category.delicate,
        selectedImageUri: 'images/beer.png',
        unselectedImageUri: 'images/beer_gray.png',
        selected: false),
    CategoryIcon(
        name: Category.offensive,
        selectedImageUri: 'images/cocktail.png',
        unselectedImageUri: 'images/cocktail_gray.png',
        selected: false),
  ];

  Widget buildStatementView(BuildContext context) {
    return StreamBuilder(
      stream: bloc.statement,
      builder: (BuildContext context, AsyncSnapshot<Statement> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return StatementView(
            statement: snapshot.data,
          );
        }
        bloc.goForward(categories);
        return CircularProgressIndicator();
      },
    );
  }

  List<Widget> buildGestureDetector(double width) {
    return [
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        child: GestureDetector(
            onTap: () => bloc.goBackward(),
            child: Container(
              width: width,
              color: Colors.transparent,
            )),
      ),
      Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        child: GestureDetector(
            onTap: () => bloc.goForward(categories),
            child: Container(
              width: width,
              color: Colors.transparent,
            )),
      ),
    ];
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool swipes = false;

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0 && !swipes) {
          bloc.goBackward();
        }

        if (details.delta.dx < 0 && !swipes) {
          bloc.goForward(categories);
        }
        swipes = true;
      },
      onPanEnd: (details) {
        swipes = false;
      },
      child: Stack(children: <Widget>[
        ...buildGestureDetector(MediaQuery.of(context).size.width / 2),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CategoriesView(categories: categories),
                      Container(
                        width: double.infinity,
                        child: Stack(children: [
                          Center(child: buildStatementView(context)),
                          ...buildGestureDetector(
                              MediaQuery.of(context).size.width / 2),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
