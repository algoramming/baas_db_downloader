import 'package:baas_db_downloader/config/constant.dart';
import 'package:flutter/material.dart';

import 'components/firebase_section.dart';
import 'components/pocketbase_section.dart';
import 'components/supabase_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BaaS DB Downloader'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: DefaultTabController(
            initialIndex: 1,
            length: 3,

            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
                    borderRadius: defaultBorderRadius,
                  ),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    splashBorderRadius: defaultBorderRadius,
                    physics: const BouncingScrollPhysics(),
                    indicatorColor: Colors.white,
                    automaticIndicatorColorAdjustment: true,
                    unselectedLabelColor: Theme.of(context).textTheme.titleMedium!.color,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: defaultBorderRadius,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Firebase'),
                      Tab(text: 'Pocketbase'),
                      Tab(text: 'Supabase'),
                    ],
                  ),
                ),
                Expanded(
                  child: const TabBarView(
                    children: [FirebaseSection(), PocketbaseSection(), SupabaseSection()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
