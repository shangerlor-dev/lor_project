# Public Utility Vehicle Passenger Counting Using Computer Vision and YOLO

## 1. Project Description

The **Public Utility Vehicle Passenger Counting Using Computer Vision and YOLO** is a web-based system designed to detect and count passengers in Public Utility Vehicles (PUVs) using computer vision and the YOLO object detection model.

The system aims to provide a user interface for passenger-counting activities, display detection results, and support the organization of PUV information and counting records.

The project uses Flutter Web for the frontend, Python FastAPI for the backend REST API, YOLO for image detection, and PostgreSQL for planned persistent data storage.

The project is currently under development. The frontend and initial detection API have been started, and the team is working toward integrating all components into one functioning system.

## 2. Project Objectives

- Develop a web-based interface for the PUV passenger-counting system.
- Detect people in PUV images using YOLO.
- Process image-detection requests through a FastAPI REST API.
- Prepare a custom dataset to improve passenger detection.
- Design a PostgreSQL database for user accounts, PUV information, counting sessions, and results.
- Connect the frontend, backend, detection model, and database.
- Test the complete workflow and improve the reliability of the counting results.

## 3. Technology Stack

| Technology | Purpose | Current Status |
|---|---|---|
| Flutter Web | User interface and navigation | UI development in progress |
| Dart | Programming language for Flutter | In use |
| Python | Backend and model integration | In use |
| FastAPI | REST API and image-processing requests | Initial integration implemented |
| YOLO | Detecting people in images | Initial model tested; improvement needed |
| PostgreSQL | Persistent storage for application records | Design and SQL preparation |
| Git and GitHub | Version control and code sharing | Used for project management |
| Visual Studio Code | Development environment | In use |

## 4. Work Completed So Far

### 4.1 Frontend UI Development

**Status: In progress**

The Flutter Web frontend has been started. The current design direction uses a dark navy, blue, and teal visual theme.

Work completed or tested includes:

- Creating and developing the Login screen.
- Adding basic email and password form validation.
- Implementing the Login-to-Dashboard navigation.
- Testing that the Dashboard can be opened after valid form input.
- Organizing the UI into separate screens and reusable widgets.

The Register screen and other system modules are part of the frontend development plan.

**Important:** The current Login implementation is only a UI prototype. It does not yet authenticate real accounts through FastAPI or PostgreSQL.

### 4.2 FastAPI Backend

**Status: Initial integration implemented**

The Python FastAPI backend has been set up, and the `/detect` endpoint has been integrated with a YOLO model.

The endpoint has been tested with images. It can return detection results, but further testing and improvements are needed.

The backend will eventually handle requests from the Flutter frontend, execute the detection process, and return results in a format the frontend can display.

### 4.3 Initial YOLO Detection

**Status: Tested; improvement needed**

The current YOLO model, previously identified as `yolo26n.pt`, has been tested on images.

The initial tests showed that the model can detect some people, but it misses others in certain images.

The next tasks are to:

1. Collect suitable images of passengers and PUV environments.
2. Label the people in the images using bounding boxes.
3. Organize the dataset in the required YOLO format.
4. Split the dataset into training, validation, and testing sets.
5. Train a custom model.
6. Evaluate the model on images it has not seen during training.
7. Test the trained model through the existing FastAPI `/detect` endpoint.

Custom training has not yet been confirmed as complete.

### 4.4 PostgreSQL Database Preparation

**Status: Design and preparation**

The planned database configuration is:

- Database name: `puv_passenger_counting_db`
- Schema name: `passenger_counting`

The proposed database structure includes records for:

- User accounts and roles.
- PUV information.
- Counting sessions.
- Detection records.
- Tracking records.
- Passenger counts.

The database design and SQL preparation are part of the project. The actual connection between PostgreSQL and the backend must still be implemented and tested before database integration can be marked complete.

### 4.5 GitHub and Documentation

**Status: Ongoing**

Git and GitHub are used to store project source code, record changes, and share work among team members.

The repository should be kept updated with the actual frontend, backend, database scripts, and documentation as the project develops.

## 5. Planned System Modules

| Module | Purpose | Current Status |
|---|---|---|
| Login | User sign-in interface | UI validation and navigation tested |
| Register | Account registration | UI and backend functionality need completion |
| Dashboard | Summary of system information | Navigation tested; real data integration pending |
| PUV Management | Manage PUV information | Planned / under development |
| Passenger Counting | Submit images and display detection results | Detection API tested; full UI integration pending |
| History | Review previous counting sessions | Planned |
| Reports | Summarize saved counting records | Planned |
| Authentication | Verify user accounts and permissions | Backend implementation pending |
| Database Integration | Save and retrieve application records | Pending implementation and testing |
| Custom YOLO Training | Improve passenger detection | Dataset preparation and training pending |

The status of each module should be updated whenever the team completes and tests a feature.

## 6. How the System Components Will Be Connected

The project has four main technical components:

1. **Flutter Web** – The frontend used by the operator or authorized user.
2. **FastAPI REST API** – The backend that receives requests and coordinates processing.
3. **YOLO** – The detection model that identifies people in an image.
4. **PostgreSQL** – The database intended to store persistent application records.

### 6.1 Flutter Web to FastAPI

The Flutter frontend will send an HTTP request to the backend when the user submits an image for passenger detection.

For example, the Passenger Counting screen will:

1. Allow the user to select an image.
2. Send the image to the FastAPI `/detect` endpoint.
3. Wait for the backend response.
4. Receive the detection results.
5. Display the results in the Flutter interface.

The request and response formats must match the actual FastAPI implementation.

For local development, the frontend and backend may run separately on the same computer. The Flutter app must use the correct backend URL, and the backend must allow the necessary browser requests through its CORS configuration.

### 6.2 FastAPI to YOLO

The FastAPI backend will use the YOLO model to process the submitted image.

The intended process is:

1. FastAPI receives the image.
2. The backend validates and prepares the image.
3. YOLO performs object detection.
4. The backend processes the detection output.
5. FastAPI returns the results as JSON.

A response could contain detection labels, confidence values, bounding-box coordinates, and a count, depending on the endpoint's actual implementation.

The existing `/detect` endpoint is already integrated with a YOLO model and has undergone initial testing. The next task is to improve detection performance and ensure the endpoint returns consistent results.

### 6.3 FastAPI to PostgreSQL

The backend will connect to PostgreSQL when the database integration is implemented.

The planned process is:

1. FastAPI receives a request that requires a database operation.
2. The backend validates the request and applies the relevant business rules.
3. The backend reads or writes the appropriate records in PostgreSQL.
4. The backend returns a response to Flutter.

For example, after a counting session is processed, the backend may save the selected PUV, session details, detection information, and passenger-counting results.

The backend should handle database transactions and errors appropriately. Database credentials should be stored in environment variables and must not be committed to a public repository.

### 6.4 Flutter Web to PostgreSQL

The Flutter frontend should **not connect directly to PostgreSQL**.

Instead, the intended connection is:

`Flutter Web → FastAPI REST API → PostgreSQL`

This keeps database credentials on the server side and allows the backend to validate requests and control access to the records.

### 6.5 Complete Passenger-Counting Workflow

The intended workflow is:

1. The operator opens the system in a browser.
2. The operator selects the Passenger Counting module.
3. The operator submits a suitable image.
4. Flutter sends the image to FastAPI.
5. FastAPI passes the image to YOLO.
6. YOLO detects people in the image.
7. FastAPI prepares the detection response.
8. Flutter displays the results.
9. Once database integration is implemented, the backend can save the relevant session and counting records in PostgreSQL.
10. The History and Reports modules can retrieve saved records through the backend.

This is the planned end-to-end workflow. The entire workflow has not yet been confirmed as complete.

## 7. Important Difference Between Detection and Passenger Counting

Detecting people in a single image is not the same as reliably counting passengers entering and leaving a PUV.

YOLO can identify people visible in an image, but additional logic may be needed to determine whether a passenger is entering or exiting, avoid duplicate counts, and maintain reliable counting records.

If the project uses video-based counting, it may also need object tracking and a defined counting line or region.

The team must implement and test the appropriate counting logic before claiming that entry and exit counts are fully functional.

## 8. Current Project Structure

The intended repository structure is:

```text
puv-passenger-counting/
├── frontend/
│   └── Flutter Web application
├── backend/
│   ├── FastAPI application
│   └── YOLO detection integration
├── database/
│   └── PostgreSQL SQL scripts and migrations
├── docs/
│   └── Project documentation and diagrams
├── .gitignore
├── .env.example
└── README.md
```

This is a proposed structure. The team must update it to match the actual repository and avoid creating duplicate folders or moving existing files without checking their dependencies.

## 9. Next Steps in Development

### Step 1: Continue the Frontend

- Improve the Login and Register interfaces.
- Complete the Dashboard UI.
- Develop the PUV Management and Passenger Counting screens.
- Prepare the History and Reports interfaces.
- Test navigation between screens.

### Step 2: Improve YOLO Detection

- Check the existing model and detection settings.
- Gather suitable passenger images.
- Label the images.
- Prepare the dataset.
- Train and evaluate a custom model.
- Test the improved model using the existing `/detect` endpoint.

### Step 3: Finalize the REST API

- Confirm the request format for image uploads.
- Confirm the JSON response format.
- Handle invalid images and detection errors.
- Test the endpoint independently before connecting it to Flutter.

### Step 4: Implement PostgreSQL Integration

- Finalize the database schema.
- Run and test the SQL scripts.
- Configure the backend database connection.
- Implement the required database operations.
- Test saving and retrieving records.

### Step 5: Connect the Frontend and Backend

- Configure the backend base URL in Flutter.
- Create or complete the frontend API service.
- Send image requests from Flutter to FastAPI.
- Display the returned detection results.
- Handle loading states, errors, and empty results.

### Step 6: Complete and Test the Counting Workflow

- Implement the necessary counting logic.
- Test the detection and counting results.
- Save completed sessions through the backend.
- Retrieve saved records for History and Reports.
- Test the full workflow from image submission to result display and record storage.

### Step 7: Test and Document the System

- Test each module independently.
- Test communication between components.
- Check for invalid input and failed requests.
- Record known limitations and bugs.
- Update the README and GitHub repository whenever a feature is completed.

## 10. Getting Started

### Prerequisites

- Flutter SDK and Dart SDK.
- Python.
- Visual Studio Code.
- Google Chrome.
- Git.
- PostgreSQL when database integration is required.

### Running the Frontend

Open the actual Flutter project directory in Visual Studio Code and run:

```bash
flutter pub get
flutter run -d chrome
```

### Running the Backend

Open the backend directory and follow the project's actual Python dependency and environment setup instructions. The exact commands depend on the files and configuration already present in the repository.

Do not assume that the frontend and backend are connected simply because they run independently. Verify that the Flutter app can successfully send a request to the FastAPI endpoint.

## 11. Team Collaboration

All group members should coordinate their work and keep the repository organized.

Recommended practices:

- Agree on which member is responsible for each module.
- Communicate before modifying shared files.
- Commit working changes with clear commit messages.
- Test changes before marking a task as complete.
- Avoid committing passwords, API keys, database credentials, or local environment files.
- Update this README whenever significant progress is made.
- Use Git branches when working on separate features to reduce conflicts.

## 12. Current Summary

The project has started its Flutter Web UI development and has an initial FastAPI `/detect` integration with YOLO. The Login-to-Dashboard navigation has been tested, and the first model tests have shown that detection improvements are needed.

PostgreSQL database design and SQL preparation are part of the ongoing work, but full database integration has not yet been confirmed.

The next major priorities are to improve the YOLO model using a labeled dataset, continue building the frontend modules, finalize the REST API response format, integrate PostgreSQL through FastAPI, and test the complete passenger-counting workflow.

**Overall Project Status: Under Development.**