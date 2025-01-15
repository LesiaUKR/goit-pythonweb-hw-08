# Вибираємо базовий образ з Python 3.12
FROM python:3.13-slim

# Встановлюємо необхідні системні пакети для Poetry та компіляції залежностей
RUN apt-get update && apt-get install -y gcc curl

# Встановлюємо Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Додаємо Poetry до PATH
ENV PATH="/root/.local/bin:$PATH"

# Створюємо та переміщаємося до робочої директорії
WORKDIR /src

# Копіюємо файли проєкту до контейнера
COPY pyproject.toml poetry.lock ./
COPY . .

# Копіюємо .env файл
COPY .env .env

# Встановлюємо залежності через Poetry
RUN poetry install --no-interaction --only main

# Відкриваємо порт, який буде використовувати додаток
EXPOSE 8000

# Запускаємо сервер
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]