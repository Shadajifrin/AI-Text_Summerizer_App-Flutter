import 'package:flutter/material.dart';
import 'package:text_summerizer_flutter_ai/services/api_service.dart';
class SummarizerScreen extends StatefulWidget {
  @override
  _SummarizerScreenState createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final _controller = TextEditingController();
  String? _summary;
  bool _loading = false;

  Future<void> _summarize() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _loading = true;
      _summary = null;
    });

    try {
      final result = await GeminiService.summarizeText(input);
      setState(() {
        _summary = result;
      });
    } catch (e) {
      setState(() {
        _summary = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Text Summarizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Paste or type your long text here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _summarize,
              child: Text(_loading ? 'Summarizing...' : 'Summarize'),
            ),
            const SizedBox(height: 20),
            if (_summary != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.grey[100],
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_summary!, style: TextStyle(fontSize: 16)),
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
