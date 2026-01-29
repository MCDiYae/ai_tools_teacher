# 🎓 AI Teacher Helper

**AI Teacher Helper** is a Flutter-based mobile application designed to assist educators in generating high-quality academic content instantly. Powered by the **DeepSeek AI API**, the app can create both quick classroom exercises and formal, structured examination papers across various subjects and grade levels.

<p align="center">
  <img src="https://github.com/user-attachments/assets/3202fad0-279e-46f0-8aa9-2ab867c731cf" alt="App Workflow" width="100%">
</p>


---

## 📸 Screen Gallery

The following workflow illustrates the seamless process of generating content for both Exams and Exercises:



> **The Flow:** Splash Screen → Home → Select Subject → Select Level → Choose Topics → Get Results!

---
## Scan Exercise Feature

The app now includes a powerful scanning feature that allows teachers to quickly digitize physical exercises:

    Camera Scan: Use your device's camera to capture exercises in real-time

    Text Extraction: Automatically recognize and extract text using OCR

    AI Processing: Send scanned content to AI for exercise/exam generation


> **Scan Workflow :** Scanner Screen → Capture/Select Image → OCR Processing → Scan Results → AI Generation
---

## ✨ Key Features

* **Dual Mode Functionality**:
    * **Exercise Mode**: Generates quick question-and-answer pairs for daily practice.
    * **Exam Mode**: Produces formal examination papers with Section A (MCQs), Section B (Short Answers), and Section C (Problem Solving).
* **Intelligent AI Integration**: Utilizes the **DeepSeek-Chat** model for accurate, context-aware academic content.
* **Dynamic Subject Mapping**: Support for Mathematics, Physics, Chemistry, Biology, English, and French, each with specific sub-topics.
* **Solution Transparency**: Every generated task comes with a full, step-by-step correction/marking scheme.
* **State Management**: Built using **Provider** for a clean, reactive user experience.
* **Scan & Camera Integration**: Scan printed or handwritten exercises using your device's camera or gallery.
* **OCR Text Recognition**: Extract text from images automatically using ML Kit technology.
* **Secure Configuration**: API keys are managed securely using environment variables (`.env`).

---

## 🛠️ Tech Stack

* **Framework**: [Flutter](https://flutter.dev/)
* **Language**: [Dart](https://dart.dev/)
* **State Management**: [Provider](https://pub.dev/packages/provider)
* **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
* **AI Engine**: [DeepSeek API](https://api.deepseek.com/)
* **Text Recognition**: [Text Recognition](https://pub.dev/packages/google_mlkit_text_recognition)
* **Image Picker**: [Image Picker](https://pub.dev/packages/image_picker)



---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/MCDiYae/ai_tools_teacher.git
cd AI-Teacher-Helper
