import cv2
import mediapipe as mp
import numpy as np

class PushUpCounter:
    def __init__(self):
        self.count = 0
        self.direction = 0  # 0: 내려가기, 1: 올라가기
        self.down_threshold = 80
        self.up_threshold = 160
        self.pose = mp.solutions.pose.Pose(
            static_image_mode=False,
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5
        )

    def calculate_angle(self, a, b, c):
        """세 점을 이용해 각도를 계산"""
        a = np.array(a)
        b = np.array(b)
        c = np.array(c)
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
        return 360 - angle if angle > 180.0 else angle

    def extract_landmarks(self, frame, landmarks):
        """랜드마크에서 좌표 추출"""
        frame_height, frame_width = frame.shape[:2]
        return [
            [landmarks[mp.solutions.pose.PoseLandmark.LEFT_SHOULDER.value].x * frame_width,
             landmarks[mp.solutions.pose.PoseLandmark.LEFT_SHOULDER.value].y * frame_height],
            [landmarks[mp.solutions.pose.PoseLandmark.LEFT_ELBOW.value].x * frame_width,
             landmarks[mp.solutions.pose.PoseLandmark.LEFT_ELBOW.value].y * frame_height],
            [landmarks[mp.solutions.pose.PoseLandmark.LEFT_WRIST.value].x * frame_width,
             landmarks[mp.solutions.pose.PoseLandmark.LEFT_WRIST.value].y * frame_height],
        ]

    def process_frame(self, frame):
        """프레임에서 각도와 푸쉬업 상태를 계산"""
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.pose.process(image)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark
            shoulder, elbow, wrist = self.extract_landmarks(frame, landmarks)
            angle = self.calculate_angle(shoulder, elbow, wrist)

            # 푸쉬업 동작 감지
            if angle > self.up_threshold and self.direction == 1:
                self.direction = 0
                self.count += 1
            elif angle < self.down_threshold and self.direction == 0:
                self.direction = 1

            return angle

        return None

    def release(self):
        self.pose.close()

def main():
    cap = cv2.VideoCapture(0)
    pushup_counter = PushUpCounter()

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        angle = pushup_counter.process_frame(frame)
        if angle is not None:
            cv2.putText(frame, f"Angle: {int(angle)}", (10, 50), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 0), 2)

        cv2.putText(frame, f"Push-Ups: {pushup_counter.count}", (10, 100), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        cv2.imshow("Push-Up Counter", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
    pushup_counter.release()

if __name__ == "__main__":
    main()
