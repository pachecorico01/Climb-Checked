import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video {
  final String title;
  final String videoId; // El ID del video de YouTube
  final String category;

  Video({required this.title, required this.videoId, required this.category});
}

class VideosPage extends StatelessWidget {
  final List<Video> videos = [
    Video(title: "Cuidados del material de escalada", videoId: "yUzScIq3q7I", category: "Cuidado del material"),
    Video(title: "Como marcar correctamente tu material de escalada", videoId: "YgMBEbjZWG8", category: "Cuidado del material"),
    Video(title: "¿Qué equipo necesitas para escalada deportiva?", videoId: "_Bykrv0l2HE", category: "Buen uso"),
    Video(title: "Cómo asegurar en ESCALADA", videoId: "uNJybj7gIag", category: "Buen uso"),
    Video(title: "Almacén de material", videoId: "l9FDDrUvcNU", category: "Almacenamiento"),
    Video(title: "Cómo recoger y guardar la cuerda después de escalar", videoId: "6oDlibRTl-8", category: "Almacenamiento"),
    // Agrega más videos según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _getCategories().length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Videos del Cuidado'),
          backgroundColor: Color(0xFFFAEDE4), // Cambio de color de fondo del appbar
          bottom: TabBar(
            tabs: _getCategories().map<Widget>((category) => Tab(text: category)).toList(),
            labelColor: Color(0xFF4B7342), // Cambio de color del texto de las pestañas seleccionadas
            unselectedLabelColor: Color(0xFF4B7342), // Cambio de color del texto de las pestañas no seleccionadas
            indicatorColor: Color(0xFF4B7342), // Cambio de color de la línea indicadora de la pestaña seleccionada
          ),
        ),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color de fondo del scaffold
        body: TabBarView(
          children: _getCategories().map<Widget>((category) {
            final categoryVideos = _getVideosByCategory(category);
            return ListView.builder(
              itemCount: categoryVideos.length,
              itemBuilder: (context, index) {
                final video = categoryVideos[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => _showVideo(context, video.videoId),
                      child: _buildVideoThumbnail(video),
                    ),
                    SizedBox(height: 8),
                    Text(
                      video.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4B7342)), // Cambio de color del texto
                    ),
                    SizedBox(height: 8),
                  ],
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  List<String> _getCategories() {
    return videos.map((video) => video.category).toSet().toList();
  }

  List<Video> _getVideosByCategory(String category) {
    return videos.where((video) => video.category == category).toList();
  }

  Widget _buildVideoThumbnail(Video video) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        'https://img.youtube.com/vi/${video.videoId}/0.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  void _showVideo(BuildContext context, String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Reproducción de Video'),
            backgroundColor: Color(0xFF4B7342), // Cambio de color de fondo del appbar
          ),
          backgroundColor: Color(0xFFFAEDE4), // Cambio de color de fondo del scaffold
          body: Center(
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
