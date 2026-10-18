# Public Utility Vehicle Passenger Counting Using Computer Vision and YOLO

## Project Description

The Public Utility Vehicle Passenger Counting System is a web-based application designed to detect and count passengers in Public Utility Vehicle (PUV) images using computer vision and the YOLO object detection model.

The system allows authorized users to upload an image for passenger detection and view the resulting detection output and passenger count. The project aims to support passenger-counting tasks through image analysis rather than live camera monitoring.

The application is being developed using Flutter Web for the user interface, Python FastAPI for the REST API backend, YOLO for object detection, and PostgreSQL for database storage.

## Project Objectives

- Develop a web-based interface for the passenger-counting system.
- Allow users to upload PUV images for passenger detection.
- Use YOLO to detect passengers in uploaded images.
- Display detection results and passenger counts.
- Prepare database storage for users, PUV records, and counting results.
- Integrate the frontend, backend, object detection model, and database.
- Test the accuracy and reliability of passenger detection.

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter Web | Frontend user interface |
| Dart | Frontend programming language |
| Python | Backend programming language |
| FastAPI | REST API backend |
| YOLO | Passenger object detection |
| PostgreSQL | Planned database for application records |
| Git and GitHub | Version control and collaboration |
| Visual Studio Code | Development environment |

## System Workflow

1. The user signs in to the application.
2. The user opens the passenger detection feature.
3. The user uploads a PUV image.
4. Flutter Web sends the image to the FastAPI backend through an HTTP request.
5. The backend processes the image using the YOLO model.
6. The backend returns the detection output and available counting results as JSON.
7. The frontend displays the results to the user.
8. Once database integration is implemented, relevant records can be saved in PostgreSQL.

**Note:** Actual passenger entry and exit tracking is not implied by image-based detection alone. The system must implement and test the required counting logic before claiming that it measures passenger movement or entry and exit events.

## Main System Components

### 1. Login

Provides the user interface for entering an email address and password.

**Current status:** Login UI and input validation are implemented. The current demo login does not authenticate users against PostgreSQL.

### 2. Dashboard

Provides an overview of the system and access to its available features.

**Current status:** Frontend development and route integration should be verified against the current code.

### 3. PUV Management

Intended to manage PUV information used by the application.

**Current status:** Database and frontend integration remain subject to implementation and testing.

### 4. Image-Based Passenger Detection

Allows users to submit PUV images for YOLO-based passenger detection.

**Current status:** The FastAPI `/detect` endpoint has been tested with a YOLO model. Initial tests detected some people, but detection accuracy needs improvement.

### 5. Detection Results and History

Intended to display detection results and retain records of previous analyses.

**Current status:** Complete frontend, backend, and database integration must still be verified.

### 6. User and Database Management

Intended to support user records, PUV information, and passenger-counting records through PostgreSQL.

**Current status:** Database preparation and integration are still in progress.

## Architecture

The planned system architecture is:

**Flutter Web → FastAPI REST API → YOLO Model → Detection Results → Flutter Web**

PostgreSQL will be integrated through the backend for supported records and data retrieval.

The Flutter frontend must communicate with the backend API rather than connect directly to PostgreSQL.

## Development Progress

| Component | Current Status |
|---|---|
| Flutter Web frontend | Under development |
| Login interface | Implemented with form validation |
| Demo login navigation | Implemented; not real authentication |
| FastAPI backend | `/detect` endpoint available for testing |
| YOLO detection | Initial detection tested; accuracy needs improvement |
| Custom YOLO training | Pending dataset labeling and training |
| PostgreSQL integration | Pending verification and implementation |
| Full system integration | In progress |
| End-to-end testing | Pending |

## Planned Repository Structure

The following is the intended structure. Actual folders may differ depending on the current repository.

```text
puv-passenger-counting/
├── frontend/
│   └── Flutter Web application
├── backend/
│   └── FastAPI and YOLO integration
├── database/
│   └── SQL scripts and migrations
├── docs/
│   └── Project documentation and diagrams
├── .gitignore
├── .env.example
└── README.md
```

## Setup and Testing

### Frontend

Install Flutter and verify the development environment:

```bash
flutter doctor
```

From the directory containing the Flutter project's `pubspec.yaml`, run:

```bash
flutter pub get
flutter run -d chrome
```

### Backend

Activate the Python virtual environment and install the dependencies listed in the project's actual `requirements.txt`, if available.

Run the FastAPI application using the entry point configured in the repository. For example, if the backend entry point is `main.py` and defines `app`:

```bash
uvicorn main:app --reload
```

Open the FastAPI documentation at:

```text
http://127.0.0.1:8000/docs
```

The backend entry point and port must match the actual project configuration.

### YOLO Detection

Test the `/detect` endpoint with an image supported by the current API implementation. Review the detection output and compare the results against the actual passengers visible in the image.

The current model is a starting point. Custom dataset labeling, training, and validation are planned to improve detection performance.

### Database

PostgreSQL integration will be tested after the database configuration, schema, and backend connection have been implemented. Database credentials should be stored in environment variables and must not be committed to GitHub.

## Next Development Tasks

1. Collect representative PUV images and label the people to be detected.
2. Train and evaluate a custom YOLO model.
3. Improve detection accuracy using validation images.
4. Finalize the `/detect` API response format.
5. Implement and test the passenger-counting logic.
6. Connect the frontend to the FastAPI backend.
7. Integrate PostgreSQL through the backend.
8. Complete end-to-end testing and document the verified results.

## Version Control

Git and GitHub are used to track changes, maintain project history, and support collaboration. Commit messages should describe the changes made, and sensitive credentials must not be uploaded.

## Current Project Summary

The project is developing a web-based, image-driven PUV passenger-counting system using Flutter Web, FastAPI, YOLO, and PostgreSQL. The login interface and initial YOLO detection endpoint have been tested. Improving detection accuracy, custom model training, database integration, and complete system testing remain important development tasks.

The README should be updated as features are implemented and verified.
