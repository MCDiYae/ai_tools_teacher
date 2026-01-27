# 🎓 AI Teacher Helper

**AI Teacher Helper** is a Flutter-based mobile application designed to assist educators in generating high-quality academic content instantly. Powered by the **DeepSeek AI API**, the app can create both quick classroom exercises and formal, structured examination papers across various subjects and grade levels.

---

## 📸 Screen Gallery

The following workflow illustrates the seamless process of generating content for both Exams and Exercises:

<p align="center">
  <img src="https://github.com/user-attachments/assets/bbfdf033-ef14-454b-b3ce-33f049229d94" alt="App Workflow" width="100%">
</p>

> **The Flow:** Splash Screen → Home → Select Subject → Select Level → Choose Topics → Get Results!

---

## ✨ Key Features

* **Dual Mode Functionality**:
    * **Exercise Mode**: Generates quick question-and-answer pairs for daily practice.
    * **Exam Mode**: Produces formal examination papers with Section A (MCQs), Section B (Short Answers), and Section C (Problem Solving).
* **Intelligent AI Integration**: Utilizes the **DeepSeek-Chat** model for accurate, context-aware academic content.
* **Dynamic Subject Mapping**: Support for Mathematics, Physics, Chemistry, Biology, English, and French, each with specific sub-topics.
* **Solution Transparency**: Every generated task comes with a full, step-by-step correction/marking scheme.
* **State Management**: Built using **Provider** for a clean, reactive user experience.
* **Secure Configuration**: API keys are managed securely using environment variables (`.env`).

---

## 🛠️ Tech Stack

* **Framework**: [Flutter](https://flutter.dev/)
* **Language**: [Dart](https://dart.dev/)
* **State Management**: [Provider](https://pub.dev/packages/provider)
* **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
* **AI Engine**: [DeepSeek API](https://api.deepseek.com/)

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone [https://github.com/YOUR_USERNAME/AI-Teacher-Helper.git](https://github.com/YOUR_USERNAME/AI-Teacher-Helper.git)
cd AI-Teacher-Helper
