import json
import logging
import sys
from collections.abc import Generator

from fastapi import Depends, FastAPI, HTTPException, status
from sqlalchemy import select, text
from sqlalchemy.orm import Session

from app.config import Settings
from app.database import SessionLocal
from app.models import Task
from app.schemas import TaskCreate, TaskRead

settings = Settings()
logging.basicConfig(
    level=settings.log_level,
    stream=sys.stdout,
    format=json.dumps(
        {"timestamp": "%(asctime)s", "level": "%(levelname)s", "logger": "%(name)s", "message": "%(message)s"}
    ),
)
logger = logging.getLogger("task-api")
app = FastAPI(title="Kind Task API", version="1.0.0")


def get_db() -> Generator[Session, None, None]:
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()


@app.get("/health/live")
def live() -> dict[str, str]:
    return {"status": "alive"}


@app.get("/health/ready")
def ready(db: Session = Depends(get_db)) -> dict[str, str]:
    try:
        db.execute(text("SELECT 1"))
    except Exception as exc:
        logger.warning("Database readiness check failed")
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail="database unavailable") from exc
    return {"status": "ready"}


@app.get("/api/tasks", response_model=list[TaskRead])
def list_tasks(db: Session = Depends(get_db)) -> list[Task]:
    return list(db.scalars(select(Task).order_by(Task.id)).all())


@app.post("/api/tasks", response_model=TaskRead, status_code=status.HTTP_201_CREATED)
def create_task(payload: TaskCreate, db: Session = Depends(get_db)) -> Task:
    task = Task(title=payload.title)
    db.add(task)
    db.commit()
    db.refresh(task)
    logger.info("Task created", extra={"task_id": task.id})
    return task
