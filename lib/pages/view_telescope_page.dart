import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:telescope_mart/pages/telescope_details_page.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewTelescopePage extends StatefulWidget {
  static const String routeName = "viewtelescope";
  const ViewTelescopePage({super.key});

  @override
  State<ViewTelescopePage> createState() => _ViewTelescopePageState();
}

class _ViewTelescopePageState extends State<ViewTelescopePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Telescopes")),
      body: Consumer<TelescopeProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemBuilder: (context, index) {
            final telescope = provider.telescopeList[index];
            final id = telescope.id;
            return InkWell(
              onTap: () {
                context.goNamed(TelescopeDetailsPage.routeName, extra: id);
              },
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: .cover,
                      imageUrl: telescope.thumbnail.downloadUrl,
                      placeholder: (context, url) =>
                          Center(child: const CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, size: 100),
                    ),

                    Expanded(
                      child: Padding(
                        padding: .all(8),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              telescope.model,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              telescope.brand.name,
                              style: const TextStyle(
                                color: Colors.grey,
                                overflow: .ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: provider.telescopeList.length,
        ),
      ),
    );
  }
}
