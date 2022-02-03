import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

// class first extends StatefulWidget {
//   const first({Key? key}) : super(key: key);

//   @override
//   _firstState createState() => _firstState();
// }

// class _firstState extends State<first> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("다음 창"),
//       ),
//       body: Center(
//         child: Text("하이"),
//       ),
//     );
//   }
// }

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  _firstState createState() => _firstState();
}

class _firstState extends State<first> {
  List<t> tt = [];
  List<mtrl> mm = [];
  List<st> ss = [];

  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    var food;
    var url = Uri.parse("https://www.10000recipe.com" + food);

    var res = await http.get(url);
    final body = res.body;
    var document = parser.parse(res.body);

    var ab = document.getElementsByTagName('h3');
    var ac = ab[0].text.toString();

    var a1 = document
        .getElementById('main_thumbs')!
        .attributes; // 요리 이미지 관련 태그의 속성 찾기
    var txt = a1['src'].toString(); // 속성중 src 속성의 값을 문자열로 저장

    tt.add(t(image: txt, title: ac));

    // 재료
    var check =
        (document.getElementsByClassName('ingre_unit').length).toInt() !=
            0; // 재료의 개수가 적혀있는 레시피인지 확인

    var a3 = document.getElementsByClassName('cont_ingre2'); // 재료 부분 태그 찾기
    var b = a3[0].getElementsByTagName('ul'); // 재료 찾기

    for (var count = 0; count < b.length; count++) {
      // 재료와 양념을 찾음
      var one = b[count].getElementsByTagName('li');
      var lst = []; // 재료가 저장될 리스트

      for (var i = 0; i < one.length; i++) {
        var d = one[i].text.split(' ');
        for (var i = 0; i < d.length; i++) {
          if (d[i] != '' && d[i] != '\n') {
            lst.add(d[i].trim());
          }
        }
      }
      lst.remove(''); // 쓸데 없이 저장된 데이터 제거'

      var res;

      if (check) {
        // 재료의 개수가 적혀있는 경우와 아닐 경우를 구분해서 따로 출력
        for (var i = 1; i < lst.length + 1; i++) {
          // print('${lst[i - 1]} : ${lst[i]}');
          res = '${lst[i - 1]} : ${lst[i]}'.toString();
          mm.add(mtrl(material: res.toString()));

          i++;
        }
      } else {
        for (var i = 0; i < lst.length; i++) {
          // print('${lst[i]}');
          res = '${lst[i]}'.toString();
          mm.add(mtrl(material: res.toString()));
        }
      }
    }

    // 요리 과정
    var a = document.getElementsByClassName('view_step_cont'); // 요리 과정 관련 태그 찾기
    // var aaa = a[0].getElementsByClassName('media-body');
    for (var i = 1; i < a.length + 1; i++) {
      var process =
          '$i: ${a[i - 1].text.trim().replaceAll('\n', ' ')}'.toString();

      // 이미지 태그의 주소값 찾기
      var b = a[i - 1].getElementsByTagName('img');
      var c = b[0].attributes;
      var txt = c['src'].toString();

      // 반복문으로 하나씩 출력
      // print(
      // '$i: ${a[i - 1].text.trim().replaceAll('\n', ' ')}'); // trim()은 문자열 양 옆의 공백 제거 해줌
      ss.add(st(step: process.toString(), picture: txt));
    }

    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  getBox(st i) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: Image.network(i.picture),
            // width: 380,
            // height: 300,
          ),
          Text(
            i.step,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic mater = '';

    dynamic reci = '';

    for (var i = 0; i < mm.length; i++) {
      mater = mater + "${mm[i].material}\n".toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Expanded(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: ListView.builder(
                          itemCount: ss.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                // padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Column(children: [
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      Text(
                                        "${tt[0].title}",
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Image.network(
                                        tt[0].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ]),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          "재료 및 양념",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          mater,
                                          style: TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          "조리 순서",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ), //재료 및 양념
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return getBox(ss[index - 1]);
                            }
                          })))),
    );
  }
}

class t {
  String image;
  String title;
  t({required this.image, required this.title});
}

class mtrl {
  String material;
  mtrl({required this.material});
}

class st {
  String step;
  String picture;
  st({required this.picture, required this.step});
}
