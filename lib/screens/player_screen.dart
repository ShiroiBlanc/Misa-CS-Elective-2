import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _isPlaying = false;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB78A50), Color(0xFF6A4524), Color(0xFF261A12)],
            stops: [0, .48, 1],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth > 430 ? 32.0 : 16.0;
              final artworkSize = (constraints.maxWidth - horizontalPadding * 2)
                  .clamp(0.0, 410.0);

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  4,
                  horizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _StatusBar(),
                    const SizedBox(height: 24),
                    _Artwork(size: artworkSize),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Akasaka Sad',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  height: 1.05,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Rina Sawayama',
                                style: TextStyle(
                                  color: Color(0xFFDCCDBB),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Add to playlist',
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.add_circle_outline_rounded),
                        ),
                        IconButton(
                          tooltip: _isLiked ? 'Unlike' : 'Like',
                          onPressed: () => setState(() => _isLiked = !_isLiked),
                          color: Colors.white,
                          icon: Icon(
                            _isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _ProgressBar(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          tooltip: 'Shuffle',
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.shuffle_rounded),
                        ),
                        IconButton(
                          tooltip: 'Previous track',
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.skip_previous_rounded, size: 34),
                        ),
                        _PlayButton(
                          isPlaying: _isPlaying,
                          onPressed: () => setState(() => _isPlaying = !_isPlaying),
                        ),
                        IconButton(
                          tooltip: 'Next track',
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.skip_next_rounded, size: 34),
                        ),
                        IconButton(
                          tooltip: 'Queue',
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.queue_music_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    const _ConnectionRow(),
                    const SizedBox(height: 9),
                    const _DeviceRow(),
                    const SizedBox(height: 18),
                    const _LyricsPanel(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '9:41',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            const Icon(Icons.signal_cellular_alt_rounded, color: Colors.white, size: 15),
            const SizedBox(width: 4),
            const Icon(Icons.wifi_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Container(
              width: 24,
              height: 12,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: .78,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.asset(
          'assets/covers/genius_archers_streaming.webp',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Color(0x66FFFFFF),
            thumbColor: Colors.white,
          ),
          child: const Slider(value: .42, onChanged: null),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1:19',
              style: TextStyle(
                color: Color(0xFFDCCDBB),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '-1:39',
              style: TextStyle(
                color: Color(0xFFDCCDBB),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isPlaying, required this.onPressed});

  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isPlaying ? 'Pause' : 'Play',
      onPressed: onPressed,
      iconSize: 35,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 66, height: 66),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4B301C),
      ),
      icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
    );
  }
}

class _ConnectionRow extends StatelessWidget {
  const _ConnectionRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.bluetooth_rounded, color: Color(0xFF24D06B), size: 18),
        SizedBox(width: 8),
        Text('Airpods Max', style: TextStyle(color: Color(0xFF24D06B), fontSize: 12)),
      ],
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.dehaze_rounded, color: Colors.white, size: 18),
        SizedBox(width: 8),
        Text('SAWAYAMA', style: TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}

class _LyricsPanel extends StatelessWidget {
  const _LyricsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 12, 12, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFC19A69),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Text(
              'Lyrics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Expand lyrics',
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            color: const Color(0xFF795B38),
            icon: const Icon(Icons.open_in_full_rounded, size: 17),
          ),
        ],
      ),
    );
  }
}
