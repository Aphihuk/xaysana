// ฟังก์ชันสำหรับเมื่อกดเลือกคำตอบ
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BirthdayQuizApp());
}

class BirthdayQuizApp extends StatelessWidget {
  const BirthdayQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Surprise',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Prompt', // ใช้ฟอนต์ที่รองรับภาษาไทย
      ),
      home: const QuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// โมเดลสำหรับคำถาม
class Question {
  final String question;
  final List<String> answers;
  final int correctIndex; // ตำแหน่งของคำตอบที่ถูกต้อง (0-3)

  Question({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // ตัวแปรเก็บหน้าปัจจุบัน (0-4 คือคำถาม, 5 คือหน้าสุดท้าย)
  int currentPage = 0;
  final TextEditingController _textController = TextEditingController();

  // รายการคำถามทั้งหมด - สามารถแก้ไขเพิ่มเติมได้ที่นี่
  final List<Question> questions = [
    Question(
      question: 'ຄິດຈັງໃດກ້ບລູກທັງ3ຄົນ?',
      answers: ['ຮັກຫລາຍ', 'ໄຊ້ເງີນເກັງ', 'ຈົມເກັງ', 'ປົກກະຕິ'],
      correctIndex: 0, 
    ),
    Question(
      question: 'ຟ້າມັກສີຫຍັງ?',
      answers: ['ສີເເດງ', 'ສີດຳ', 'ສິບົວ', 'ສີມວງ'],
      correctIndex: 3, 
    ),
    Question(
      question: 'ແມ່ມັກເຮັດຫຍັງ?',
      answers: ['ອອກກຳລັງກາຍ', 'ຫລີ້ນtaekwondo', 'ຫາຜີ', 'ເບີງຫນັງ'],
      correctIndex: 3, 
    ),
    Question(
      question: 'ສະຖານທີອະພີຮັກຢາກໄປທີສູດ?',
      answers: ['ເຮືອນ', 'ອາເມລີກາ', 'ໄທ', 'ຍີ່ປຸ່ນ'],
      correctIndex: 0, 
    ),
    // คำถามที่ 5 จะเป็นแบบ text input (ไม่อยู่ในลิสต์นี้)
  ];

  // ฟังก์ชันสำหรับเมื่อกดเลือกคำตอบ
  void onAnswerSelected(int selectedIndex) {
    // ตรวจสอบว่าคำตอบถูกหรือผิด
    bool isCorrect = selectedIndex == questions[currentPage].correctIndex;

    // แสดง snackbar แจ้งผล
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? '✅ ຖີກຕ້ອງ!' : '❌ ຜິດເເລ້ວ ຄຳຕອບທີ່ຖືກຄື: ${questions[currentPage].answers[questions[currentPage].correctIndex]}'),
        duration: const Duration(milliseconds: 800),
        backgroundColor: isCorrect ? Colors.green : const Color.fromARGB(255, 255, 1, 1),
      ),
    );

    // รอแล้วไปข้อต่อไป
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentPage < questions.length) {
          currentPage++;
        }
      });
    });
  }
  // ฟังก์ชันสำหรับส่งคำตอบแบบพิมพ์
void onTextAnswerSubmit() {
  String answer = _textController.text.trim();

  // ถ้ายังไม่ได้พิมพ์อะไร
  if (answer.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❗ ກະລູນາພີມຄຳຕອບກ່ອນ'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  // แสดงข้อความขอบคุณ
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(' ຂອບໃຈພໍ່'),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.pink,
    ),
  );

  // รอแล้วไปหน้าสุขสันต์วันเกิด
  Future.delayed(const Duration(seconds: 2), () {
    setState(() {
      currentPage = questions.length + 1; // jump ไป BirthdayPage
    });
  });
}


  @override
  Widget build(BuildContext context) {
    // ถ้าเป็นหน้าสุดท้าย (หน้าที่ 6) แสดงหน้าสุขสันต์วันเกิด
    if (currentPage > questions.length) {
      return const BirthdayPage();
    }

    // ถ้าเป็นหน้าคำถามพิเศษ (หน้าที่ 5)
    if (currentPage == questions.length) {
      return Scaffold(
        backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          title: Text('ຄຳຖາມສູດທ້າຍ'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // แสดงความคืบหน้า
              LinearProgressIndicator(
                value: 1.0, // เต็ม 100%
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                minHeight: 8,
              ),
              const SizedBox(height: 40),

              // แสดงคำถามพิเศษ
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade100,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'ພໍ່ມີຫຍັງຢາກຝາກບອກລູກບໍ?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // กล่องพิมพ์คำตอบ
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ຄຳຕອບ:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'ພີມຄຳຕອບໄຊ້ບອນນີ້...',
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ปุ่มส่งคำตอบ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTextAnswerSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'ສົງຄຳຕອບ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Spacer(),

              // ข้อความเล็กๆ
              Text(
                'ພີມສີງທີ່ຢາກບອກພໍ່ໄດ້ເລີຍ !!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // แสดงหน้าคำถาม
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text('ຄຳຖາມທີ ${currentPage + 1}/${questions.length}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // แสดงความคืบหน้า
            LinearProgressIndicator(
              value: (currentPage + 1) / questions.length,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              minHeight: 8,
            ),
            const SizedBox(height: 40),

            // แสดงคำถาม
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade100,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                questions[currentPage].question,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // แสดงตัวเลือกคำตอบแบบ 2x2 Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 คอลัมน์
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5, // อัตราส่วนของปุ่ม
                ),
                itemCount: 4, // 4 ตัวเลือก
                itemBuilder: (context, index) {
                  return AnswerButton(
                    answer: questions[currentPage].answers[index],
                    onPressed: () => onAnswerSelected(index),
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget สำหรับปุ่มคำตอบ
class AnswerButton extends StatelessWidget {
  final String answer;
  final VoidCallback onPressed;
  final int index;

  const AnswerButton({
    Key? key,
    required this.answer,
    required this.onPressed,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // สีต่างๆ สำหรับแต่ละปุ่ม
    final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange];

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors[index].shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: colors[index].shade200,
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        answer,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// หน้าสุขสันต์วันเกิด (หน้าที่ 5)
class BirthdayPage extends StatefulWidget {
  const BirthdayPage({Key? key}) : super(key: key);

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  // สร้าง AudioPlayer instance
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // เล่นเพลงอัตโนมัติเมื่อเปิดหน้านี้
    _playBirthdaySong();
  }

  // ฟังก์ชันเล่นเพลง (วิธีที่ 1: ใช้ไฟล์ mp3 ที่เก็บใน assets)
  Future<void> _playBirthdaySong() async {
    try {
      // เล่นเพลงจากไฟล์ในโฟลเดอร์ assets
      await _audioPlayer.play(AssetSource('audio/birthday_song.mp3'));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // ฟังก์ชันหยุดเพลง
  Future<void> _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    // ปิด audio player เมื่อออกจากหน้า
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade300,
              Colors.pink.shade300,
              Colors.orange.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // รูปภาพ (แก้ไข path ของรูปที่ต้องการ)
                    // วิธีที่ 1: ใช้รูปจาก assets
                    Image.asset(
                      'assets/images/birthday_photo.jpg', // เปลี่ยนชื่อไฟล์ตามต้องการ
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // ถ้าไม่มีรูป จะแสดง icon แทน
                        return const Icon(
                          Icons.cake,
                          size: 120,
                          color: Colors.white,
                        );
                      },
                    ),

                    // วิธีที่ 2: ใช้รูปจาก network (URL)
                    // Image.network(
                    //   'https://example.com/your-image.jpg',
                    //   width: 200,
                    //   height: 200,
                    //   fit: BoxFit.cover,
                    // ),
                    const SizedBox(height: 30),

                    // ข้อความสุขสันต์วันเกิด
                    const Text(
                      '🎉 ສູກສັນວັນເກີດພໍ່ໄຊຊະນະ 🎉',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // ข้อความอวยพร
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ພໍ່ທີຮັກ ❤️\n\n'
                        'ຂອບໄຫ້ມີຄວາມສຸກຫລາຍຯ\n'
                        'ສູກະພາບເເຊງເເຮງ\n'
                        'ຂໍໄຫ້ສູກກາຍສະບາຍໃຈ\n\n'
                        'ຮັກຄຸນພໍ່ໄຊຊະນະເດີ 💖',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.6,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ปุ่มควบคุมเพลง
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ปุ่มหยุด/เล่นเพลง
                        ElevatedButton.icon(
                          onPressed: isPlaying ? _stopSong : _playBirthdaySong,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 28,
                          ),
                          label: Text(
                            isPlaying ? 'stop music' : 'play music',
                            style: const TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ข้อความเล็กๆ
                    Text(
                      '🎈 ຂໍໄຫ້ທຸກຄວາມປາປາດທະຫນາເປັນຈີງ(ຖືກເລກ16) 🎈',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}