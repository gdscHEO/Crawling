import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<info> ifm = [];

  var data;

  var url = Uri.parse("https://www.10000recipe.com/recipe/6930302");

  Widget show = Center(child: CircularProgressIndicator());

  void initState() {
    super.initState();
    getData();
  }

  //음식 사진
  // print(element.children[0].children[2].children[0].attributes['src']
  //     .toString());

  //음식 제목
  //  print(element.children[1].children[0].text.toString());

  //음식 재료 전체
  // print(element.children[5].children[1].children[0].text.toString());

  //음식 양념 전체
  // print(element.children[5].children[1].children[1].text.toString());

  //재료 이름이랑 수량이 같이 나옴
  //얘는 앞에 빈칸이 있이 나옴
  // print(element.children[5].children[1].children[0].children[1].text
  //얘는 빈칸 없이 나옴 (근데 둘 다 두번 출력이 됨)
  // print(element
  //   .children[5].children[1].children[0].children[1].children[0].text
  //   .toString());

  //재료 수량만
  // print(element.children[5].children[1].children[0].children[1].children[0]
  //   .children[1].text
  //   .toString());

  //조리 순서 첫번째에만 해당하는 값들..
  // print(element.children[10].children[1].children[0].text.toString());
  // print(element
  //     .children[10].children[1].children[1].children[0].attributes['src']
  //     .toString());

  //전체 조리 순서 값들 (맨 마지막에 사진이 넣는 칸이 있어서 출력할 때 length-1로 할것!!)
  // print(element.children[10].text.toString());

  Future<void> getData() async {
    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);

    document.getElementsByClassName("col-xs-9").forEach((element) {
      ifm.add(info(
            image: element.children[0].children[2].children[0].attributes['src']
                .toString(),
            title: element.children[1].children[0].text.toString(),
            material:
                element.children[5].children[1].children[0].text.toString(),
            seasoning:
                element.children[5].children[1].children[1].text.toString(),
            step: element.children[10].text.toString()));
      setState(() {
        show = showResult();
      });
    });

    // setState(() {
    //   data = response;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: SafeArea(
        // child: ListView.builder(
        //     padding: EdgeInsets.all(10),
        //     itemBuilder: (context, index) {
        //       Text("${ifm[index].material}");
        //     }),
        child: show,
        ),
      );
  }

  Widget showResult(){
    
    //material값을 replaceAll을 통해 가공처리해준다
    //결과부분은 0번 인덱스에 [재료] 라는 값이 들어가고, 짝수번째 인덱스마다 재료와 값이 나오므로 짝수번 인덱스들 출력하면될듯
    var matResult =ifm[0].material.replaceAll(' ','').replaceAll('\n', ' ').replaceAll('  ', '\t').split('\t');

    //step부분도 이런식으로 접근해야되지않을까..싶음
    var stepResult = ifm[0].step.split('\n');
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(ifm[0].image),
                SizedBox(
                  height: 10,
                ),
                Text("${ifm[0].title}"),
                Text("${matResult}"),
                Text('${stepResult}')
        ],
      ),
    );
  }
}

class info {
  String image;
  String title;
  String material;
  String seasoning;
  String step;

  info(
      {required this.image,
      required this.title,
      required this.material,
      required this.seasoning,
      required this.step});
}
