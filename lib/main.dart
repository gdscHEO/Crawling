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
  var name = '토마토';
  List<picture> recipe = [];

  //가능 => 김치, 토마토
  //불가능 => 오이, 피망

  bool isLoading = false;

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('https://www.10000recipe.com/recipe/list.html?q=' +
        name); // 주소 입력시 그 주소 html 파싱

    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);

    var response = document
        .getElementsByClassName("common_sp_list_ul ea4")[1]
        .getElementsByClassName("common_sp_list_li")
        .forEach((element) {
      setState(() {
        recipe.add(picture(
          image: element.children[0].children[0].children[0].attributes['src']
              .toString(),
          title: element.children[1].children[0].text.toString(),
          url: element.children[0].children[0].attributes['href'].toString(),
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
        title: const Text("레시피 추천"),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // if(Image.network(recipe[index].image !=null &&))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: getImage(recipe[index].image),
                              //받아온 레시피 이미지 값 넘겨주기
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "${recipe[index].title}",
                              style: _style,
                            ),
                            Text("${recipe[index].url}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  //이미지의 결과가 없다면 null이미지 출력
  getImage(String path) {
    if (path == 'null') {
      return Image.asset('assets/null.png');
    }
    return Image.network(path);
  }

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 18);
}

class picture {
  String image;
  String title;
  String url;

  picture({required this.image, required this.title, required this.url});
}
