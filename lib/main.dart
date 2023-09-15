import 'dart:convert';
import 'package:haberler/news_content.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


void main()=>runApp(NewsApp());

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsScaffold(),
    );
  }
}

class NewsScaffold extends StatefulWidget {

  const NewsScaffold({super.key});

  @override
  State<NewsScaffold> createState() => _NewsScaffoldState();
}

class _NewsScaffoldState extends State<NewsScaffold> {
  TextEditingController _controller = TextEditingController(text: "");
  String query = "";
  bool _isShow = true;

  Future<String> getNewsData(String query) async{
    final response = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=$query&from=2023-08-12&sortBy=publishedAt&language=tr&apiKey='Your News API Key'"));
    if(response.statusCode == 200){
      return response.body;
    }
    return "";
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text("Haberler",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async{
            setState(() {

            });
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: _isShow ? TextField(
                  controller: _controller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed:(){
                        setState(() {
                          query = _controller.text;
                          getNewsData(query);
                          _controller.text = "";
                        });
                      }, icon: Icon(Icons.search,
                        color: Colors.black,
                      )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: Colors.black12,
                          )
                      )
                  ),
                ):SizedBox(),
              ),
              query.isNotEmpty ? FutureBuilder(future: getNewsData(query), builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text("Hata Oluştu"),
                      ],
                    ),
                  );
                }else{
                  String data = snapshot.data.toString();
                  Map<String,dynamic> new_data_map = jsonDecode(data);
                  List<dynamic> articles = new_data_map['articles'];

                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("'$query' hakkında haberler sıralandı."),
                              ),
                              IconButton(onPressed:(){
                                setState(() {
                                  _isShow = !_isShow;
                                });
                              }, icon:_isShow ? Icon(Icons.visibility_off):Icon(Icons.visibility)),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: articles.length,
                              itemBuilder:(BuildContext context, index){   //articles[index]["source"]["name"]
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                        return NewsContent(title:articles[index]["title"] , imageUrl:articles[index]["urlToImage"], content: articles[index]["description"], source: articles[index]["source"]["name"],articlesUrl: articles[index]["url"].toString(),);
                                      }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(articles[index]["title"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),  //Title
                                          Center(child: Image.network(articles[index]["urlToImage"])) , //Haber İçeriği
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(articles[index]["source"]["name"]) //Haberin Kaynağı
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
              },):SizedBox(),
            ],
          ),
        )
    );
  }
}
