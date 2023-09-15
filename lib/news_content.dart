import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class NewsContent extends StatefulWidget {
  String title = "";
  String imageUrl = "";
  String content = "";
  String source = "";
  String articlesUrl = "";

  NewsContent({required this.title,required this.imageUrl,required this.content,required this.source,required this.articlesUrl});

  @override
  State<NewsContent> createState() => _NewsContentState();
}

class _NewsContentState extends State<NewsContent> {

  String paragraphLength(String paragraph){
    int paragraphLength = paragraph.length;
    if(paragraphLength >= 50){
      return paragraph.substring(0, 50)+"...";
    }else{
      return paragraph;
    }
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
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200]
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Image.network(widget.imageUrl),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(widget.content,
                  style: TextStyle(
                    fontSize: 18,

                  ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(widget.source),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                   Navigator.push(context,MaterialPageRoute(builder: (BuildContext context){
                     return Web_View(url: widget.articlesUrl);
                   }));
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kaynak:",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        ),
                        SizedBox(height: 5,),
                        Text(paragraphLength(widget.articlesUrl),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}


class Web_View extends StatefulWidget {
  String url = "";
  Web_View({required this.url});
  @override
  State<Web_View> createState() => _Web_ViewState();
}

class _Web_ViewState extends State<Web_View> {
  WebViewController  controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    controller
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
    NavigationDelegate(
    onProgress: (int progress) {
    // Update loading bar.
    },
    onPageStarted: (String url) {},
    onPageFinished: (String url) {},
    onWebResourceError: (WebResourceError error) {},
    onNavigationRequest: (NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/')) {
    return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
    },
    ),
    )
    ..loadRequest(Uri.parse(widget.url));
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.orangeAccent,
      ),
      body:WebViewWidget(controller:controller)
    );
  }
}


