from app import models  # noqa: F401
from app.database import Base, engine


def main() -> None:
    Base.metadata.create_all(bind=engine)


if __name__ == "__main__":
    main()
