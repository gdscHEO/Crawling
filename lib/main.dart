import 'package:crawling/first.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() => runApp(MyApp());

//잠깐 딜레이?가 생길 떄 오류 화면이 한 번 보이는 문제 발생 -> 로딩중인 애니메이션?을 사용할 것! -> 해결

class MyApp extends StatelessWidget {
  // const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<picture> recipe = [];
  var url = Uri.parse("https://www.10000recipe.com/recipe/list.html?q=토마토");
  //가능 => 김치, 토마토
  //불가능 => 오이, 피망

  bool isLoading = false;

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);

/*
      print(element.children[0].children[0].children[0].attributes['src']
          .toString()); //사진이 쭈르륵 나옴

      // print(element.children[1].text.toString()); //글씨가 다 나옴 평점까지
      print(element.children[1].children[0].text.toString()); //제목만 수집!

*/

    var response = document
        .getElementsByClassName("common_sp_list_ul ea4")[1]
        .getElementsByClassName("common_sp_list_li")
        .forEach((element) {
      setState(() {
        recipe.add(picture(
          image: element.children[0].children[0].children[0].attributes['src']
              .toString(),
          title: element.children[1].children[0].text.toString(),
        ));
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Scrapping"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                // itemCount: recipe.length,
                itemCount: 4,
                //                 GestureDetector(
                //   onTap: () => ......,
                //   child: Card(...),
                // );
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 6,
                  color: Colors.green[300],
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => first()),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // if(Image.network(recipe[index].image !=null &&))

                          Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(recipe[index].image)
                                  //영상이나 사진이 없을 경우 오류가 남.. 그리고 레시피 추천만 있어서 html에 맞춰서 못가져오는 문제가 발생함..
                                  //일단 영상이거나 사진이 없을 경우는 assets/null.png로 사진을 대체하고자 하는 데 그것도 잘 안되는 상황 흠..
                                  // recipe[index].image != null &&
                                  // recipe[index].image.isNotEmpty
                                  // ? Image.network(recipe[index].image)
                                  // : null,
                                  ),
                              //위에 숫자 세줌.
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Text(
                              //     index.toString(),
                              //     style: const TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 22,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${recipe[index].title}",
                            style: _style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 18);
}

class picture {
  String image;
  String title;

  picture({required this.image, required this.title});
}
