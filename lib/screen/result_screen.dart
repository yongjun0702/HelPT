import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ExerciseResultScreen extends StatefulWidget {
  @override
  _ExerciseResultScreenState createState() => _ExerciseResultScreenState();
}

class _ExerciseResultScreenState extends State<ExerciseResultScreen> {
  String _sortOrder = '최신순'; // 초기 정렬 순서

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "운동 기록",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 정렬 옵션 드롭다운
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: _sortOrder,
                  items: ['최신순', '오래된순'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortOrder = newValue!;
                    });
                  },
                ),
              ],
            ),
            // 운동 기록 리스트
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getExerciseRecordsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('오류 발생: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('운동 기록이 없습니다.'));
                  }

                  // Firestore 데이터 정렬
                  final records = snapshot.data!.docs;
                  records.sort((a, b) {
                    final dataA = a.data() as Map<String, dynamic>;
                    final dataB = b.data() as Map<String, dynamic>;
                    final dateA = DateTime.parse(dataA['start_time']);
                    final dateB = DateTime.parse(dataB['start_time']);
                    return _sortOrder == '최신순'
                        ? dateB.compareTo(dateA)
                        : dateA.compareTo(dateB);
                  });

                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index].data() as Map<String, dynamic>;
                      final recordId = records[index].id;

                      // 기록 정보
                      final startTime = record['start_time'];
                      final endTime = record['end_time'] ?? '진행 중';
                      final isGoalAchieved = record['is_goal_achieved'] ?? false;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "시작 시간: ${_formatDateTime(startTime)}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "종료 시간: ${endTime != '진행 중' ? _formatDateTime(endTime) : endTime}",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "운동 목표: ${isGoalAchieved ? '달성 성공' : '달성 실패'}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isGoalAchieved ? Colors.green : Colors.red,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteRecord(recordId),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Firestore에서 운동 기록을 가져오는 스트림
  Stream<QuerySnapshot> _getExerciseRecordsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('exercises')
          .doc(currentUser.uid)
          .collection('sessions')
          .snapshots();
    }
    return const Stream.empty();
  }

  // Firestore에서 기록 삭제
  Future<void> _deleteRecord(String recordId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('exercises')
            .doc(currentUser.uid)
            .collection('sessions')
            .doc(recordId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록이 삭제되었습니다.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록 삭제 실패: $e')),
        );
      }
    }
  }

  // 날짜 및 시간 포맷팅
  String _formatDateTime(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return DateFormat('yyyy년 M월 d일 H시 m분').format(dateTime);
  }
}