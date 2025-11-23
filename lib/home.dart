import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagePrefix =
      "https://fcofoalbiqgvisvhrczs.supabase.co/storage/v1/object/public/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: StreamBuilder(
        stream: Supabase.instance.client
            .from('post')
            .stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data;

          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              final post = data[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(post['tittle'], style: TextStyle(fontSize: 16)),
                      if (post['image'] != null)
                        Center(
                          child: Image.network(
                            imagePrefix + post['image'],
                            height: 200,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddPostPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController controller = TextEditingController();
  Uint8List? imageFile;
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FilledButton(
            onPressed: () async {
              try {
                final userId = Supabase.instance.client.auth.currentUser!.id;
                String? imageUrl;
                if (imageFile != null) {
                  String name = DateTime.now().toIso8601String() + imagePath!;
                  imageUrl = await Supabase.instance.client.storage
                      .from('image')
                      .uploadBinary(name, imageFile!);
                }
                await Supabase.instance.client.from('post').insert({
                  'tittle': controller.text,
                  'image': imageUrl,
                  'userid': userId,
                });
                showSnackBar(context, "Post successful");
                Navigator.of(context).pop();
              } catch (e) {
                showSnackBar(context, e.toString());
              }
            },
            child: Text("Publish"),
          ),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          TextField(
            controller: controller,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              // border: InputBorder.none,
              border: OutlineInputBorder(),
            ),
          ),

          IconButton(
            onPressed: () async {
              try {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                imagePath = image!.path.split("/").last;
                imageFile = await image.readAsBytes();

                setState(() {});
              } catch (e) {
                showSnackBar(context, e.toString());
              }
            },
            icon: Icon(Icons.image),
          ),

          ///For mobile or desktops
          // if (imageFile != null) Image.file(File(imageFile!.path)),

          //browser , should be imageFile as xFile
          // if (imageFile != null) Image.network(imageFile!.path),
          if (imageFile != null) Image.memory(imageFile!),
        ],
      ),
    );
  }
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg.toString())));
}
