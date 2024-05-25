import 'package:bitirme_projesi/services/cloud_database/firebase_cloud_user_crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseCloudStorage _firestore = FirebaseCloudStorage();
  int _rating = 0; // Değişken for puanlama

  bool _showCommentWarning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE2DE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB7B7B7),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, size: 35), // Geri düğmesini büyütme
          onPressed: () {
            Navigator.pop(context); // Geri düğmesine basıldığında geri dön
          },
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            'Geri Bildirim',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF504658),
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Dismiss keyboard when tapped outside
          setState(() {
            _showCommentWarning = false;
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 35),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.zero),
                  child: Image.asset(
                    'lib/assets/feedback_img.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 17),
                child: Text(
                  'Deneyimlerinizi paylaşınız..',
                  style: TextStyle(
                    color: Color(0xFF4A403A),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 60, right: 60),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          controller: _feedbackController,
                          maxLines: null,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.insert_comment_outlined),
                            iconColor: const Color(0xFF99B19C),
                            labelText: 'Yorumunuzu Buraya Yazınız..',
                            labelStyle: const TextStyle(fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFCC4646),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _showCommentWarning = true;
                                _rating = 0;
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_rating == i) {
                            _rating =
                                0; // Yıldıza tekrar tıklanınca değeri sıfırla
                          } else {
                            _rating = i;
                          }
                        });
                      },
                      icon: Icon(
                        _rating >= i ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
                child: ElevatedButton(
                  onPressed: _rating == 0 ? null : _sendFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rating == 0 ? Colors.grey : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Color(0xFF525252),
                        width: 1.5,
                      ),
                    ),
                    minimumSize: const Size(140, 45),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Gönder',
                    style: TextStyle(
                      color: Color(0xFF525252),
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendFeedback() async {
    if (_feedbackController.text.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await _firestore.updateComment(
          documentId: userId, comment: _feedbackController.text);

      await _firestore.updateScore(
        documentId: userId,
        score: _rating.toString(),
      );
      setState(() {
        _feedbackController.clear();
        _rating = 0;
      });
      // Başarı mesajını içeren bir AlertDialog oluştur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Başarılı!'),
            content: const Text('Geri bildiriminiz başarıyla gönderildi.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Başarısız'),
            content: const Text('Yorum boş olamaz!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }
}
