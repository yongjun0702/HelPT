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

    def process_frame(self, frame):
        """푸쉬업 카운트를 계산"""
        frame_height, frame_width = frame.shape[:2]
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.pose.process(image)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark

            # 왼쪽 팔 좌표
            left_shoulder = [
                landmarks[mp.solutions.pose.PoseLandmark.LEFT_SHOULDER.value].x * frame_width,
                landmarks[mp.solutions.pose.PoseLandmark.LEFT_SHOULDER.value].y * frame_height,
            ]
            left_elbow = [
                landmarks[mp.solutions.pose.PoseLandmark.LEFT_ELBOW.value].x * frame_width,
                landmarks[mp.solutions.pose.PoseLandmark.LEFT_ELBOW.value].y * frame_height,
            ]
            left_wrist = [
                landmarks[mp.solutions.pose.PoseLandmark.LEFT_WRIST.value].x * frame_width,
                landmarks[mp.solutions.pose.PoseLandmark.LEFT_WRIST.value].y * frame_height,
            ]

            # 각도 계산
            a = np.array(left_shoulder)
            b = np.array(left_elbow)
            c = np.array(left_wrist)
            radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
            angle = np.abs(radians * 180.0 / np.pi)
            if angle > 180.0:
                angle = 360 - angle

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
