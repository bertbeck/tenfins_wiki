// ignore_for_file: avoid_print, sized_box_for_whitespace, prefer_const_constructors, non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:tenfins_wiki/features/wiki/view/addarticle/add_article.dart';
import 'package:tenfins_wiki/features/wiki/view/viewarticle/view_article_page.dart';
import 'package:tenfins_wiki/services/article_db.dart';
import 'package:tenfins_wiki/utils/color.dart';
import 'package:tenfins_wiki/utils/imageurl.dart';
import 'package:tenfins_wiki/utils/string.dart';
import 'package:tenfins_wiki/widgets/widget.dart';

import '../../bloc/ArticleBloc/article.dart';

class HomePageTablet extends StatefulWidget {
  const HomePageTablet({super.key});

  @override
  State<HomePageTablet> createState() => _HomePageTabletState();
}

class _HomePageTabletState extends State<HomePageTablet> {
  Article articleController = Get.put(Article());
  String searchtxt = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appText(title: AppSatring.wikilist, color: AppColor.whiteColor),
        backgroundColor: AppColor.primary,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: InkWell(
              onTap: () {
                Get.to(AddArticlePage(
                  type: false,
                ));
              },
              child: const ImageIcon(
                AssetImage(AppImage.createnewicon),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            child: SizedBox(
              height: 7.h,
              child: CupertinoSearchTextField(
                borderRadius: BorderRadius.circular(3.w),
                backgroundColor: Colors.grey.withOpacity(0.3),
                controller: articleController.searchArticle,
                onChanged: (String value) {
                  setState(() {
                    searchtxt = articleController.searchArticle.text;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: ArticleDataStore.box.listenable(),
              builder: (context, Box box, widget) {
                var results = searchtxt.isEmpty
                    ? box.values.toList() // whole list
                    : box.values
                        .where((c) => c.title.toLowerCase().contains(searchtxt))
                        .toList();
                print("results : $results");
                return results.isEmpty
                    ? Center(
                        child:
                            appText(title: "No Article", color: AppColor.grey),
                      )
                    : SingleChildScrollView(
                        child: GetBuilder<Article>(
                          builder: (controller) {
                            return ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: results.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var articleData = searchtxt.isEmpty
                                      ? box.getAt(index) // whole list
                                      : results[index];
                                  print("articleData : $articleData");
                                  //  print("articleData : ${articleData.categor}");
                                  //  print("articleData : ${articleData.toJson()}");
                                  //  print("articleData : ${inspect(articleData.toString())}");
                                  //   print("articleData : ${jsonEncode(articleData)}");
                                  // print("articleData : ${articleData.title}");
                                  // print("articleData : ${articleData.description}");
                                  return InkWell(
                                    onTap: () {
                                      Get.to(ViewArticlePage(
                                          articleData: articleData));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.5.w, vertical: 2.h),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColor.whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.grey
                                                  .withOpacity(0.6),
                                              blurRadius: 15,
                                              offset: const Offset(1, 2))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(3.w),
                                      gradient: LinearGradient(
                                          colors: [
                                            AppColor.primary,
                                            AppColor.black,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          appText(
                                              title: articleData.title,
                                              fontSize: 2.5.h,
                                              color: AppColor.whiteColor,
                                              fontWeight: FontWeight.w500),
                                          SizedBox(height: 1.5.h),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 0.2.w),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: appText(
                                                    title: articleData
                                                        .shortdescription,
                                                    fontSize: 1.7.h,
                                                    color: AppColor.whiteColor
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 1.5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(AddArticlePage(
                                                    type: true,
                                                    index: index,
                                                    articleData: articleData,
                                                  ));
                                                },
                                                child: ImageIcon(
                                                  const AssetImage(
                                                      AppImage.editicon),
                                                  size: 2.7.h,
                                                  color: AppColor.whiteColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  articleController
                                                      .deleteArticle(index);
                                                },
                                                child: ImageIcon(
                                                  const AssetImage(
                                                      AppImage.deleticon),
                                                  size: 2.7.h,
                                                  color: AppColor.whiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
