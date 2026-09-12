# NileAGI Chat

Cross-platform mobile chat application built for the **NileAGI Mobile App Intern** technical task.

The app connects to a local inference server (Ollama) using an OpenAI-compatible API and runs a small language model (`gemma4:e4b`).

## Features

- Clean, modern chat interface (ChatGPT / Gemini style)
- Real-time conversation with a local LLM
- Chat history during the session
- Loading / typing indicator
- Error handling
- Settings screen (Base URL + Model name)
- Works on Linux, Android, and iOS

## Tech Stack

- **Frontend**: Flutter
- **State management**: Provider
- **Inference**: Ollama (OpenAI-compatible API)
- **Model**: `gemma4:e4b`

## Prerequisites

- Flutter SDK (3.2+)
- Ollama installed and running
- Model pulled:

```bash
ollama pull gemma4:e4b