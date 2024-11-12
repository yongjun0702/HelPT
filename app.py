from flask import Flask, request, jsonify
from flask_cors import CORS  # CORS 임포트
import cv2
import numpy as np
import base64
from model import PushUpCounter  # 모델 파일 임포트

# Flask 애플리케이션 설정
app = Flask(__name__)

# CORS 활성화 (모든 도메인에서 요청을 허용)
CORS(app)

pushup_counter = PushUpCounter()  # 모델 클래스 초기화

# 프레임을 처리하고 푸시업 카운트를 반환하는 API 엔드포인트
@app.route('/process_frame', methods=['POST'])
def process_frame():
    try:
        # JSON 형식의 Base64 이미지 데이터 읽기
        data = request.get_json()
        image_data = data.get("image")

        # Base64 이미지를 디코딩하여 OpenCV에서 처리 가능한 형식으로 변환
        np_img = np.frombuffer(base64.b64decode(image_data), np.uint8)
        frame = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

        # 푸시업 카운트 계산
        count = pushup_counter.count_pushups(frame)

        # 푸시업 카운트 반환
        return jsonify(count=count)
    except Exception as e:
        return jsonify(error=str(e)), 500

# 서버 실행
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)