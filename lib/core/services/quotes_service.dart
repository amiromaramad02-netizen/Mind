import 'dart:math';

class Quote {
  final String text;
  final String author;

  Quote(this.text, this.author);
}

class QuotesService {
  static final List<Quote> _quotes = [
    Quote("The secret of getting ahead is getting started.", "Mark Twain"),
    Quote("Focus on being productive instead of busy.", "Tim Ferriss"),
    Quote("It’s not that I’m so smart, it’s just that I stay with problems longer.", "Albert Einstein"),
    Quote("Productivity is never an accident. It is always the result of a commitment to excellence.", "S.W. Myer"),
    Quote("Your mind is for having ideas, not holding them.", "David Allen"),
    Quote("Don't watch the clock; do what it does. Keep going.", "Sam Levenson"),
    Quote("Work hard in silence, let your success be your noise.", "Frank Ocean"),
  ];

  static Quote getRandomQuote() {
    return _quotes[Random().nextInt(_quotes.length)];
  }
}
