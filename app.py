from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import base64
from model import PushUpCounter

# Flask 애플리케이션 설정
app = Flask(__name__)

# CORS 활성화 (특정 도메인 또는 모든 도메인에서 요청 허용)
CORS(app, resources={r"/process_frame": {"origins": "*"}})

# 모델 초기화
pushup_counter = PushUpCounter()

# 프레임을 처리하고 푸시업 카운트를 반환하는 API 엔드포인트
@app.route('/process_frame', methods=['POST'])
def process_frame():
    try:
        # JSON 형식의 요청 데이터 읽기
        data = request.get_json()

        if not data or "image" not in data:
            return jsonify(error="Invalid input: 'image' field is required"), 400

        # Base64 이미지 디코딩
        image_data = data["image"]
        try:
            np_img = np.frombuffer(base64.b64decode(image_data), np.uint8)
            frame = cv2.imdecode(np_img, cv2.IMREAD_COLOR)
        except Exception as decode_error:
            return jsonify(error=f"Failed to decode image: {decode_error}"), 400

        if frame is None:
            return jsonify(error="Invalid image data"), 400

        # 푸시업 카운트 계산
        count = pushup_counter.count_pushups(frame)

        # 결과 반환
        return jsonify(count=count), 200

    except Exception as e:
        # 예외 처리 및 상세 오류 반환
        return jsonify(error=f"Server error: {str(e)}"), 500

# 서버 실행
if __name__ == '__main__':
    # 디버그 모드 활성화 시 필요에 따라 변경
    app.run(host='0.0.0.0', port=5000, debug=True)