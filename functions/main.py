import functions_framework
from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import base64
from model import PushUpCounter  # model.py 파일은 함께 업로드합니다

app = Flask(__name__)
CORS(app)  # CORS 활성화
pushup_counter = PushUpCounter()  # 모델 클래스 초기화

@app.route('/process_frame', methods=['POST'])
def process_frame():
    try:
        # JSON 형식의 Base64 이미지 데이터 읽기
        data = request.get_json()
        image_data = data.get("image")

        # Base64 이미지를 디코딩하여 OpenCV에서 처리 가능한 형식으로 변환
        np_img = np.frombuffer(base64.b64decode(image_data), np.uint8)
        frame = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

        # OpenCV로 프레임 처리 및 푸시업 카운트 계산
        count = pushup_counter.count_pushups(frame)

        return jsonify(count=count)
    except Exception as e:
        return jsonify(error=str(e)), 500

# Cloud Functions에서 이 함수를 HTTP 엔드포인트로 사용합니다.
@functions_framework.http
def process_frame(request):
    return app(request)