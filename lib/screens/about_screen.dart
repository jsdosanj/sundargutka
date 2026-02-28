import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Column(
              children: [
                Icon(Icons.book, size: 72, color: Color(0xFFFF8C00)),
                SizedBox(height: 12),
                Text('ਸੁੰਦਰ ਗੁਟਕਾ',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Text('Sundar Gutka',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                SizedBox(height: 4),
                Text('Version 1.0.0',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _Section('Description'),
          const Text(
            'Sundar Gutka is a complete Gurbani prayer book app based on the '
            'Damdami Taksal tradition, containing Nitnem Banis and other '
            'important prayers from Sri Guru Granth Sahib Ji and Sri Dasam Granth.',
            style: TextStyle(fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 16),
          const _Section('Vishraam Credit'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Sewa of adding Vishraams and proofreading Bani was performed by '
                'Baba Darshan Singh (Mallehwal), student of Sant Giani Gurbachan '
                'Singh Ji (Bhindranwale).',
                style: TextStyle(fontSize: 14, height: 1.6, fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _Section('Data Sources'),
          _InfoTile(
            icon: Icons.source,
            title: 'ShabadOS Database',
            subtitle: 'Gurbani text and vishraam data',
            url: 'https://github.com/ShabadOS',
          ),
          _InfoTile(
            icon: Icons.data_object,
            title: 'BaniDB',
            subtitle: 'Open source Gurbani database',
            url: 'https://banidb.com',
          ),
          const SizedBox(height: 16),
          const _Section('Features'),
          const _FeatureItem('Multiple Bani categories: Taksal, Budda Dal, Hazuri Das'),
          const _FeatureItem('Vishraam (pause) markers in orange and green'),
          const _FeatureItem('Adjustable font size and family'),
          const _FeatureItem('Light, Sepia, and Dark themes'),
          const _FeatureItem('Lareevar (connected) mode'),
          const _FeatureItem('Hindi transliteration toggle'),
          const _FeatureItem('Bookmarks with verse navigation'),
          const _FeatureItem('Custom reading lists'),
          const SizedBox(height: 16),
          const _Section('License'),
          const Text(
            'This app is released under the MIT License.\n'
            'Gurbani text is the eternal Word of the Guru and belongs to the Sikh Panth.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const _Section('Waheguru Ji Ka Khalsa, Waheguru Ji Ki Fateh'),
          const Center(
            child: Text('ਵਾਹਿਗੁਰੂ ਜੀ ਕਾ ਖ਼ਾਲਸਾ, ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫ਼ਤਹਿ',
                style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;

  const _InfoTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF8C00)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new, size: 16),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
