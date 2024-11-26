import 'package:helpt/config/color.dart';
import 'package:helpt/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyBottomSheet extends StatelessWidget {
  const PrivacyPolicyBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Container(
        color: HelPT.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "개인정보처리방침",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HelPT.lightgrey3
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    """
제 1조 (목적)  
HelPT(이하 '회사'라고 함)는 회사가 제공하고자 하는 서비스(이하 '회사 서비스')를 이용하는 개인(이하 '이용자' 또는 '개인')의 정보(이하 '개인정보')를 보호하기 위해, 개인정보 보호법, 정보통신망 이용 촉진 및 정보보호 법률(이하 '정보통신망법') 등 관련 법령을 준수하고, 서비스 이용자의 개인정보 보호와 관련된 사항을 신속하고 원활하게 처리할 수 있도록 하기 위해 다음과 같이 개인정보와 관련된 정책을 규정합니다.

제 2조 (개인정보 처리의 원칙)  
회사는 이용자의 개인정보를 수집할 수 있으며, 수집된 개인정보는 개인의 동의가 있는 경우에 한해 제3자에게 제공될 수 있습니다. 단, 법령의 규정 등에 의해 적법하게 강제되는 경우 회사는 수집한 이용자의 개인정보를 사전에 개인의 동의 없이 제3자에게 제공할 수 있습니다.

제 3조 (본 방침의 공개)  
1. 회사는 이용자가 언제든지 쉽게 본 방침을 확인할 수 있도록 회사 홈페이지 첫 화면 또는 첫 화면과 연결된 화면을 통해 본 방침을 공개하고 있습니다.  
2. 회사는 제1항에 따라 본 방침을 공개하는 경우 글자 크기, 색상 등을 활용하여 이용자가 본 방침을 쉽게 확인할 수 있도록 합니다.

제 4조 (본 방침의 변경)  
1. 본 방침은 개인정보 관련 법령, 지침, 고시 또는 정부나 회사 서비스의 정책이나 내용의 변경에 따라 개정될 수 있습니다.  
2. 회사는 제1항에 따라 본 방침을 개정하는 경우 다음 각 호 하나 이상의 방법으로 공지합니다.  
   가. 회사가 운영하는 인터넷 홈페이지의 첫 화면의 공지사항란 또는 별도의 창을 통해 공지하는 방법  
   나. 서면, 모사전송, 전자우편 또는 이와 유사한 방법으로 이용자에게 공지하는 방법  
3. 회사는 제2항의 공지는 본 방침 개정의 시행일로부터 최소 7일 전에 공지합니다. 다만, 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 공지합니다.

제 5조 (회원가입을 위한 정보)  
회사는 이용자의 회사 서비스에 대한 회원가입을 위하여 다음과 같은 정보를 수집합니다.  
1. 필수 수집 정보: 이메일 주소, 비밀번호, 이름 및 닉네임

제 6조 (회사 서비스 제공을 위한 정보)  
회사는 이용자에게 회사의 서비스를 제공하기 위하여 다음과 같은 정보를 수집합니다.  
1. 필수 수집 정보: 아이디, 이메일 주소 및 이름

제 7조 (개인정보 수집 방법)  
회사는 다음과 같은 방법으로 이용자의 개인정보를 수집합니다.  
1. 이용자가 회사의 홈페이지에 자신의 개인정보를 입력하는 방식  
2. 애플리케이션 등 회사가 제공하는 홈페이지 외의 서비스를 통해 이용자가 자신의 개인정보를 입력하는 방식  
3. 로그인 과정에서 이용자가 입력

제 8조 (개인정보의 이용)  
회사는 개인정보를 다음 각 호의 경우에 이용합니다.  
1. 공지사항의 전달 등 회사 운영에 필요한 경우  
2. 이용 문의에 대한 회신, 불만의 처리 등 이용자에 대한 서비스 개선을 위한 경우  
3. 회사의 서비스를 제공하기 위한 경우  
4. 법령 및 회사 약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용 행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제재를 위한 경우  
5. 신규 서비스 개발을 위한 경우  
6. 인구 통계학적 분석, 서비스 방문 및 이용 기록의 분석

제 9조 (개인정보의 보유 및 이용 기간)  
1. 회사는 이용자의 개인정보에 대해 개인정보의 수집, 이용 목적 달성을 위한 기간 동안 개인정보를 보유 및 이용합니다.  
2. 전항에도 불구하고 회사는 내부 방침에 의해 서비스 부정 이용 기록은 부정 가입 및 이용 방지를 위하여 회원 탈퇴 시점으로부터 최대 1년간 보관합니다.

제 10조 (법령에 따른 개인정보의 보유 및 이용 기간)  
회사는 관계 법령에 따라 다음과 같이 개인정보를 보유 및 이용합니다.  
1. 전자상거래 등에서의 소비자 보호에 관한 법률에 따른 보유 정보 및 보유 기간  
   가. 계약 또는 청약 철회 등에 관한 기록: 5년  
   나. 대금 결제 및 재화 등의 공급에 관한 기록: 5년  
   다. 소비자의 불만 또는 분쟁 처리에 관한 기록: 3년  
   라. 표시·광고에 관한 기록: 6개월  
2. 통신비밀보호법에 따른 보유 정보 및 보유 기간  
   가. 웹사이트 로그 기록 자료: 3개월  
3. 전자금융거래법에 따른 보유 정보 및 보유 기간  
   가. 전자금융거래에 관한 기록: 5년  
4. 위치 정보의 보호 및 이용 등에 관한 법률  
   가. 개인 위치 정보에 관한 기록: 6개월

제 11조 (개인정보의 파기 원칙)  
회사는 원칙적으로 이용자의 개인정보 처리 목적의 달성, 보유·이용 기간의 경과 등 개인정보가 필요하지 않게 될 경우 해당 정보를 지체 없이 파기합니다.
                    """,
                    style: TextStyle(fontSize: 16, color: HelPT.lightgrey3),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                    width: 100,
                    height: 50,
                    text: "확인",
                    buttonCount: 1,
                    func: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermPolicyBottomSheet extends StatelessWidget {
  const TermPolicyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Container(
        color: HelPT.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "서비스 이용약관",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HelPT.lightgrey3
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    """
제1조 (목적)
이 약관은 HelPT(이하 “회사”)가 운영하는 운동기록용 타이머 애플리케이션(이하 “엡”)의 서비스 이용 및 제공에 관한 제반 사항을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
1. 이 약관에서 사용하는 용어의 정의는 다음과 같습니다.

“서비스”라 함은 HelPT 앱을 통해 사용자가 이용할 수 있는 운동 기록, 타이머 등 회사가 제공하는 제반 서비스를 의미합니다.
“이용자”란 앱에 접속하여 이 약관에 따라 엡이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
“회원”이란 앱에 Google 계정 정보를 제공하여 회원가입을 한 자로서, 앱이 제공하는 서비스를 이용하는 자를 말합니다.
“Google 계정정보”란 회원의 ID, 이름, 비밀번호 등 Google 계정을 통해 제공된 정보를 의미합니다.
“앱”이란 회사가 제공하는 서비스를 이용하기 위하여 모바일 기기를 통해 다운로드 받거나 설치하여 사용하는 프로그램을 의미합니다.

제3조 (약관의 효력 및 변경)
1. 본 약관은 얍 내 또는 그 연결화면에 게시하거나 이용자에게 공지함으로써 효력이 발생합니다.

2. 회사는 관련 법령에 위배되지 않는 범위에서 이 약관을 개정할 수 있습니다.

3. 개정약관의 경우 적용일자 및 개정내용을 공지하고, 변경 내용이 중요한 경우 개별 통지합니다.

4. 회원이 개정된 약관에 동의하지 않을 경우 서비스 이용계약을 해지할 수 있습니다.

제4조 (약관 외 준칙)
이 약관에서 정하지 아니한 사항은 관련 법령 및 상 관례에 따릅니다.
                    """,
                    style: TextStyle(fontSize: 16, color: HelPT.lightgrey3),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                    width: 100,
                    height: 50,
                    text: "확인",
                    buttonCount: 1,
                    func: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperBottomSheet extends StatelessWidget {
  const DeveloperBottomSheet({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Container(
        color: HelPT.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "조용준  |  Yongjun Jo",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Text(
                "가천대학교 AI·소프트웨어학부",
                style: TextStyle(fontSize: 16, color: HelPT.grey3),
                textAlign: TextAlign.left,
              ),
              Text(
                "기술 스택: Dart, Flutter, Firebase",
                style: TextStyle(fontSize: 16, color: HelPT.grey3),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse('https://github.com/yongjun0702'));
                },
                child: Row(
                  children: [
                    Text(
                      "Github 보러가기",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Image.asset("assets/img/navigation.png", color: Colors.black),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: CustomButton(
                    width: 100,
                    height: 50,
                    text: "확인",
                    buttonCount: 1,
                    func: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
