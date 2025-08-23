class ImageItem {
  final String id; // uuid or timestamp string
  final String path; // local file path
  final DateTime capturedAt;
  String extractedText; // full OCR text
  String extractedNumber; // the first number found / or numbers concatenated
  bool cardAbdullah;
  bool cardWalid;
  bool cardAmr;

  ImageItem({
    required this.id,
    required this.path,
    required this.capturedAt,
    this.extractedText = '',
    this.extractedNumber = '',
    this.cardAbdullah = false,
    this.cardWalid = false,
    this.cardAmr = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'path': path,
        'capturedAt': capturedAt.toIso8601String(),
        'extractedText': extractedText,
        'extractedNumber': extractedNumber,
        'cardAbdullah': cardAbdullah,
        'cardWalid': cardWalid,
        'cardAmr': cardAmr,
      };

  factory ImageItem.fromMap(Map<dynamic, dynamic> m) {
    return ImageItem(
      id: m['id'] as String,
      path: m['path'] as String,
      capturedAt: DateTime.parse(m['capturedAt'] as String),
      extractedText: m['extractedText'] ?? '',
      extractedNumber: m['extractedNumber'] ?? '',
      cardAbdullah: m['cardAbdullah'] ?? false,
      cardWalid: m['cardWalid'] ?? false,
      cardAmr: m['cardAmr'] ?? false,
    );
  }
}
