```markdown
# NileAGI Chat

**Cross-platform AI Chat Application**  
Built for the NileAGI Mobile App Intern – Second Interview Technical Task

A clean, modern chat application that connects to a local inference server (Ollama) using an OpenAI-compatible API. The app runs a small language model (`gemma4:e4b`) entirely on-device/local and provides a ChatGPT-style experience.

---

## Demo

The application was demonstrated as a **Linux desktop app** (window resized to phone dimensions) connected to a local Ollama instance.

- Platform shown: Linux (Flutter desktop)
- Model: `gemma4:e4b` (via Ollama)
- API: OpenAI-compatible (`/v1/chat/completions`)

---

## Features

- Modern chat interface inspired by ChatGPT / Gemini
- Real-time conversation with a local LLM
- **Multiple chat history** with sidebar navigation
- Create, switch, and delete conversations
- Persistent chat history (survives app restart)
- Markdown rendering (headings, bold, lists, tables, code blocks)
- Loading / typing indicator
- Error handling
- Settings screen (Base URL + Model name)
- Clean empty state
- Cross-platform: Linux, Android, and iOS

---

## Tech Stack

| Layer              | Technology                          |
|--------------------|-------------------------------------|
| Frontend           | Flutter                             |
| State Management   | Provider                            |
| Local Storage      | SharedPreferences                   |
| HTTP Client        | `http` package                      |
| Markdown Rendering | `flutter_markdown`                  |
| Inference Server   | Ollama (OpenAI-compatible API)      |
| Model              | `gemma4:e4b`                        |

---

## Architecture Overview

```
Flutter App
├── UI Layer (Chat Screen + Sidebar + Settings)
├── State Management (ChatProvider)
├── Service Layer (OllamaService)
└── Local Persistence (SharedPreferences)
         ↓
   HTTP (OpenAI-compatible)
         ↓
   Ollama (localhost:11434)
         ↓
   gemma4:e4b
```

The app communicates with Ollama using the standard OpenAI Chat Completions format:

```
POST /v1/chat/completions
```

---

## Prerequisites

- Flutter SDK 3.2 or higher
- Ollama installed
- Model pulled:

```bash
ollama pull gemma4:e4b
```

---

## Setup & Installation

1. **Clone the repository**

```bash
git clone <your-github-repo-url>
cd nileagi_chat
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Make sure Ollama is running**

```bash
ollama list
# You should see gemma4:e4b
```

If Ollama is not running:

```bash
ollama serve
```

4. **Run the application**

```bash
# Linux (recommended for demo)
flutter run -d linux

# Android
flutter run -d android

# iOS
flutter run -d ios
```

---

## Configuration

Open **Settings** (gear icon) to configure:

| Setting     | Default Value                  | Description                          |
|-------------|-------------------------------|--------------------------------------|
| Base URL    | `http://localhost:11434/v1`   | Ollama OpenAI-compatible endpoint    |
| Model Name  | `gemma4:e4b`                  | Model to use for inference           |

---

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── message.dart          # Message + Conversation models
├── services/
│   └── ollama_service.dart   # OpenAI-compatible API client
├── providers/
│   └── chat_provider.dart    # State management + persistence
├── screens/
│   ├── chat_screen.dart      # Main chat interface
│   └── settings_screen.dart  # Settings page
└── widgets/
    ├── message_bubble.dart   # Message UI + Markdown
    ├── typing_indicator.dart # Loading animation
    └── chat_sidebar.dart     # Conversation history sidebar
```

---

## Key Implementation Details

### OpenAI-Compatible Integration
The app sends requests in the standard OpenAI format so it can work with Ollama, Groq, OpenRouter, or any compatible server by simply changing the Base URL.

### Chat History
- Multiple independent conversations
- Sidebar for navigation
- Auto-generated titles from the first user message
- Persisted locally using SharedPreferences

### Markdown Support
Assistant responses are rendered with proper formatting (headings, bold, lists, tables, code blocks) for a clean reading experience.

### Error Handling
Network errors, timeouts, and server issues are caught and displayed cleanly inside the chat.

---

## How to Test

1. Launch the app
2. Open the sidebar → click **New Chat**
3. Ask a question (e.g. “Explain machine learning with examples”)
4. Create another chat and switch between them
5. Close and reopen the app → history should still be present

---

## Deliverables Checklist

- [x] Cross-platform Flutter application (Linux / Android / iOS)
- [x] Clean modern chat interface
- [x] Integration with local small language model via OpenAI-compatible API
- [x] Chat history
- [x] Loading states
- [x] Error handling
- [x] Basic settings
- [x] Source code in Git repository
- [x] README with setup instructions

---

## Author

Submitted for the **NileAGI Mobile App Intern – Second Interview Technical Task**  
Timeline: 7 – 13 September 2026
```