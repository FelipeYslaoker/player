import 'package:app/constants/colors.dart';
import 'package:app/constants/dimensions.dart';
import 'package:app/models/song.dart';
import 'package:app/providers/song_provider.dart';
import 'package:app/ui/screens/albums.dart';
import 'package:app/ui/screens/artists.dart';
import 'package:app/ui/screens/favorites.dart';
import 'package:app/ui/screens/playlists.dart';
import 'package:app/ui/screens/songs.dart';
import 'package:app/ui/widgets/bottom_space.dart';
import 'package:app/ui/widgets/song_row.dart';
import 'package:app/ui/widgets/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SongProvider songProvider = context.watch();
    List<Song> mostPlayedSongs = songProvider.mostPlayed(limit: 10);

    List<Widget> menuItems = ListTile.divideTiles(
      context: context,
      tiles: <Widget>[
        LibraryMenuItem(
          icon: const Icon(CupertinoIcons.heart_fill, color: AppColors.red),
          label: 'Favorites',
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute<void>(
                builder: (_) => FavoritesScreen(previousPageTitle: 'Library'),
                title: 'Favorites',
              ),
            );
          },
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_note_list,
          label: 'Playlists',
          onTap: () => gotoPlaylistsScreen(
            context,
            previousPageTitle: 'Library',
          ),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_mic,
          label: 'Artists',
          onTap: () => gotoArtistsScreen(context, previousPageTitle: 'Library'),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_albums,
          label: 'Albums',
          onTap: () => gotoAlbumsScreen(context, previousPageTitle: 'Library'),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_note,
          label: 'Songs',
          onTap: () => gotoSongsScreen(context, previousPageTitle: 'Library'),
        ),
      ],
    ).toList();

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            backgroundColor: Colors.black,
            largeTitle: const LargeTitle(text: 'Library'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(menuItems),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.horizontalPadding,
              24,
              AppDimensions.horizontalPadding,
              0,
            ),
            sliver: SliverToBoxAdapter(child: Heading5(text: 'Recently added')),
          ),
          mostPlayedSongs.length == 0
              ? const SliverToBoxAdapter(child: SizedBox.shrink())
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, int index) => SongRow(song: mostPlayedSongs[index]),
                    childCount: mostPlayedSongs.length,
                  ),
                ),
          const SliverToBoxAdapter(child: const BottomSpace()),
        ],
      ),
    );
  }
}

class LibraryMenuItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  const LibraryMenuItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  })  : assert(
          icon is IconData || icon is Widget,
          'icon must be of either IconData or Widget type.',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        leading: icon is IconData ? Icon(icon, color: Colors.white54) : icon,
        title: Text(label, style: const TextStyle(fontSize: 20)),
        trailing: const Icon(
          CupertinoIcons.chevron_right,
          size: 18,
          color: Colors.white30,
        ),
      ),
      onTap: onTap,
    );
  }
}

void gotoAlbumsScreen(BuildContext context, {String? previousPageTitle}) {
  Navigator.push(
    context,
    CupertinoPageRoute<void>(
      builder: (_) => AlbumsScreen(previousPageTitle: previousPageTitle),
      title: 'Albums',
    ),
  );
}

void gotoArtistsScreen(BuildContext context, {String? previousPageTitle}) {
  Navigator.push(
    context,
    CupertinoPageRoute<void>(
      builder: (_) => ArtistsScreen(previousPageTitle: previousPageTitle),
      title: 'Artists',
    ),
  );
}

void gotoSongsScreen(BuildContext context, {String? previousPageTitle}) {
  Navigator.push(
    context,
    CupertinoPageRoute<void>(
      builder: (_) => SongsScreen(),
      title: 'Songs',
    ),
  );
}

void gotoPlaylistsScreen(BuildContext context, {String? previousPageTitle}) {
  Navigator.push(
    context,
    CupertinoPageRoute<void>(
      builder: (_) => PlaylistsScreen(previousPageTitle: previousPageTitle),
      title: 'Playlists',
    ),
  );
}
