
import base64
import io

import numpy as np
from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image, UnidentifiedImageError
from ultralytics import YOLO


app = FastAPI(title="PUV Vision YOLO API")

# Allow your Flutter web app to communicate with this API.

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load a small pretrained YOLO model.
# The model file is downloaded automatically when needed.
model = YOLO("yolo26n.pt")

MAX_IMAGE_SIZE = 10 * 1024 * 1024  # 10 MB


@app.get("/")
def root():
    return {
        "app": "PUV Vision YOLO API",
        "status": "running",
    }


@app.get("/health")
def health():
    return {
        "status": "connected",
        "model": "yolo26n.pt",
    }



@app.post("/detect")
async def detect_people(file: UploadFile = File(...)):
    content_type = (file.content_type or "").lower().split(";")[0].strip()

    allowed_types = {"image/jpeg", "image/png", "image/webp"}

    image_bytes = await file.read()

    if not image_bytes:
        raise HTTPException(
            status_code=400,
            detail="The uploaded image is empty.",
        )

    if len(image_bytes) > MAX_IMAGE_SIZE:
        raise HTTPException(
            status_code=413,
            detail="Image is too large. Maximum size is 10 MB.",
        )

    try:
        image_file = io.BytesIO(image_bytes)

        # Verify the actual file contents.
        with Image.open(image_file) as check_image:
            actual_format = check_image.format
            check_image.verify()

        format_to_mime = {
            "JPEG": "image/jpeg",
            "PNG": "image/png",
            "WEBP": "image/webp",
        }

        actual_mime = format_to_mime.get(actual_format)

        if actual_mime is None:
            raise HTTPException(
                status_code=400,
                detail="Only JPEG, PNG, and WebP images are supported.",
            )

        # Reject a supplied image MIME type that conflicts with
        # the actual image, but tolerate generic octet-stream.
        if content_type in allowed_types and content_type != actual_mime:
            raise HTTPException(
                status_code=400,
                detail="The uploaded image type does not match its contents.",
            )

        image_file.seek(0)
        with Image.open(image_file) as opened_image:
            image = opened_image.convert("RGB")

    except HTTPException:
        raise
    except (UnidentifiedImageError, OSError, ValueError):
        raise HTTPException(
            status_code=400,
            detail="The uploaded file is not a valid image.",
        )

    try:
        result = model.predict(
            source=np.array(image),
            classes=[0],
            conf=0.25,
            verbose=False,
        )[0]

        detections = []

        for box in result.boxes:
            detections.append({
                "class_name": "person",
                "confidence": round(float(box.conf[0]), 3),
                "box": [
                    round(float(value), 2)
                    for value in box.xyxy[0].tolist()
                ],
            })

        annotated_bgr = result.plot()
        annotated_rgb = annotated_bgr[:, :, ::-1]
        output_image = Image.fromarray(annotated_rgb)
        output_buffer = io.BytesIO()
        output_image.save(output_buffer, format="JPEG", quality=85)

        annotated_base64 = base64.b64encode(
            output_buffer.getvalue()
        ).decode("utf-8")

        return {
            "success": True,
            "passenger_count": len(detections),
            "people_count": len(detections),
            "detections": detections,
            "annotated_image": annotated_base64,
            "message": "Image detection completed.",
        }

    except Exception as exc:
        print(f"YOLO detection error: {type(exc).__name__}: {exc}")
        raise HTTPException(
            status_code=500,
            detail=f"People detection failed: {type(exc).__name__}: {exc}",
        )
