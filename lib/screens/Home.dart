import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newa_api/Models/new_channels_headlines_model.dart';
import 'package:newa_api/View_Model/news_view_model.dart';
import 'package:newa_api/screens/categories_screen.dart';
import 'package:newa_api/screens/news_detail_screen.dart';

import '../Models/categori_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, cnn, reuters, alJazeera }


class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu ;
 
  final format = DateFormat('MMMM dd, yyyy');
  String channel = 'bbc-news';

  @override
  Widget build(BuildContext context) {

 final width = MediaQuery.sizeOf(context).width *1 ;
 final height= MediaQuery.sizeOf(context).height *1 ;

    return Scaffold(

     appBar: AppBar(
       leading: IconButton(
         onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
         },
         icon: Image.asset('images/category_icon.png', height: 30,width: 30,),
       ),
       title: Center(child: Text('NEWS', style: GoogleFonts.poppins(fontSize: 24, fontWeight:FontWeight.w700),)),
       actions: [
         PopupMenuButton<FilterList>(
             initialValue: selectedMenu,
             icon: Icon(Icons.more_vert,color: Colors.black,),
             onSelected: (FilterList item){
               if(FilterList.bbcNews.name == item.name){
                 channel = 'bbc-news';
               }
               if(FilterList.aryNews.name == item.name){
                 channel = 'ary-news';
               }
               if(FilterList.cnn.name == item.name){
                 channel = 'cnn';
               }
               if(FilterList.independent.name == item.name){
                 channel =  "independent";
               }
               if(FilterList.reuters.name == item.name){
                 channel=  "reuters";
               }

             setState(() {
               selectedMenu = item;
             });
             },
             itemBuilder: (BuildContextcontext) => <PopupMenuEntry<FilterList>>[
          PopupMenuItem<FilterList>(
              value: FilterList.bbcNews,
              child: Text('BBC News'),
          ) ,
               PopupMenuItem<FilterList>(
                 value: FilterList.aryNews,
                 child: Text('Ary News'),
               ),
               PopupMenuItem<FilterList>(
                 value: FilterList.independent,
                 child: Text('Independent'),
               ),
               PopupMenuItem<FilterList>(
                 value: FilterList.reuters,
                 child: Text('reuters'),
               ),
               PopupMenuItem<FilterList>(
                 value: FilterList.cnn,
                 child: Text('CNN'),
               )
             ]
         )
       ],
     ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlineAPI(
channel
              ),
              builder: (BuildContext context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: SpinKitCircle(
                    size: 50,
                    color: Colors.blue,
                  ),
                );

              }
              else{
               return ListView.builder(
                 itemCount: snapshot.data!.articles!.length,
                   scrollDirection: Axis.horizontal,
                   itemBuilder: (context , index){

                   DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                     return InkWell(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(
                             newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                             newsTitle:snapshot.data!.articles![index].title.toString(),
                             newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                             author: snapshot.data!.articles![index].author.toString(),
                             description: snapshot.data!.articles![index].description.toString(),
                             content:snapshot.data!.articles![index].content.toString(),
                             surce: snapshot.data!.articles![index].source!.name.toString(),
                         )));
                       },
                       child: SizedBox(
                         child: Stack(
                           alignment: Alignment.center,
                           children: [
                            Container(
                              height: height * 0.6,
                               width: width * .9,
                               child: Padding(
                                 padding:  EdgeInsets.symmetric(
                                   horizontal: height * .02
                                 ),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(15),
                                   child: CachedNetworkImage(
                                     imageUrl:  snapshot.data!.articles![index].urlToImage.toString(),
                                     fit: BoxFit.cover,
                                     placeholder: (context , url) => Container(child: spinkit2,),
                                     errorWidget: (context ,url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                   ),
                                 ),
                               ),
                             ),
                             Positioned(
                            bottom: 20,

                               child: Card(
                                 elevation: 5,
                                 color: Colors.white,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 child: Container(
                                   alignment: Alignment.center,
                                   padding: EdgeInsets.all(12),
                                   height: height * .22,
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Container(
                                         width: width * 0.7,
                                         child: Text(snapshot.data!.articles![index].title.toString(),
                                           maxLines: 3,
                                           overflow: TextOverflow.ellipsis,
                                           style:GoogleFonts.poppins(fontSize: 17,  fontWeight: FontWeight.w700),),
                                       ),
                                       Spacer(),
                                       Container(
                                         width: width * 0.7,
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text(snapshot.data!.articles![index].source!.name.toString(),
                                               maxLines: 3,

                                               overflow: TextOverflow.ellipsis,
                                               style:GoogleFonts.poppins(fontSize: 13,color: Colors.blue,  fontWeight: FontWeight.w600),),
                                             Text(format.format(dateTime),
                                               maxLines: 3,
                                               overflow: TextOverflow.ellipsis,
                                               style:GoogleFonts.poppins(fontSize: 12,  fontWeight: FontWeight.w500),),

                                         ],
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     );
                   }
               );
              }
            },

            )


          ),

          Padding(
            padding:  EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNews("General"
              ),
              builder: (BuildContext context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );

                }
                else{
                  return ListView.builder(

                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context , index){

                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return Padding(
                          padding:  EdgeInsets.only(bottom: 15),
                          child:Row(

                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl:  snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context , url) => Container(child: spinkit2,),
                                  errorWidget: (context ,url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54,fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(snapshot.data!.articles![index].source!.name.toString(),

                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.blue,fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Text( format.format(dateTime),

                                            style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
              },

            ),
          ),


        ],
      ),
    );
  }
}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);

