# ElijahAPI — документация по API

## Базовая информация
- Базовый URL: `http://localhost:8000/api`
- Формат данных: JSON (кроме `/auth/login`, там `application/x-www-form-urlencoded`)
- Аутентификация: JWT в заголовке `Authorization: Bearer <access_token>`

## Аутентификация
### 1) Регистрация
`POST /api/auth/register`

**Тело запроса (JSON):**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "first_name": "Ivan",
  "last_name": "Petrov",
  "is_active": true,
  "is_superuser": false,
  "is_verified": false
}
```
`is_active`, `is_superuser`, `is_verified` — необязательные поля (по умолчанию значения указаны выше).

**Ответ (201):** объект пользователя (см. модель `UserRead`).

### 2) Логин
`POST /api/auth/login`

**Тело запроса (form-urlencoded):**
```
username=user@example.com&password=password123
```

**Ответ (200):**
```json
{
  "access_token": "<jwt>",
  "token_type": "bearer"
}
```

### 3) Выход
`POST /api/auth/logout` (требуется токен)

**Ответ:** `204 No Content`

### 4) Запрос токена верификации
`POST /api/auth/request-verify-token`

**Тело запроса (JSON):**
```json
{ "email": "user@example.com" }
```

**Ответ:** `202 Accepted`

### 5) Верификация
`POST /api/auth/verify`

**Тело запроса (JSON):**
```json
{ "token": "<verification_token>" }
```

**Ответ (200):** объект пользователя (`UserRead`).

### 6) Запрос на сброс пароля
`POST /api/auth/forgot-password`

**Тело запроса (JSON):**
```json
{ "email": "user@example.com" }
```

**Ответ:** `202 Accepted`

### 7) Сброс пароля
`POST /api/auth/reset-password`

**Тело запроса (JSON):**
```json
{
  "token": "<reset_token>",
  "password": "new_password"
}
```

**Ответ:** `200 OK`

---

## Пользователи
### Модель `UserRead`
```json
{
  "id": 1,
  "email": "user@example.com",
  "is_active": true,
  "is_superuser": false,
  "is_verified": false,
  "first_name": "Ivan",
  "last_name": "Petrov"
}
```

### Модель `UserUpdate`
```json
{
  "email": "new@example.com",
  "password": "new_password",
  "is_active": true,
  "is_superuser": false,
  "is_verified": false
}
```

### Эндпоинты
- `GET /api/users/me` — получить текущего пользователя (требуется токен)
- `PATCH /api/users/me` — обновить текущего пользователя (требуется токен)
- `GET /api/users/{id}` — получить пользователя по ID (**только superuser**)
- `PATCH /api/users/{id}` — обновить пользователя (**только superuser**)
- `DELETE /api/users/{id}` — удалить пользователя (**только superuser**)

---

## Кулинарные сущности
### Cuisine
```json
{
  "id": 1,
  "name": "Italian"
}
```

### Allergen
```json
{
  "id": 1,
  "name": "Gluten"
}
```

### Ingredient
```json
{
  "id": 1,
  "name": "Tomato"
}
```

---

## Рецепты
### Особые значения
- `difficulty`: целое число от 1 до 5
- `measurement`:
  - `1` — GRAMS
  - `2` — PIECES
  - `3` — MILLILITERS

### Модель рецепта (ответ)
```json
{
  "id": 10,
  "title": "Spaghetti Carbonara",
  "description": "Classic Italian pasta",
  "cooking_time": 30,
  "difficulty": 2,
  "cuisine": { "id": 1, "name": "Italian" },
  "author": { "id": 5, "first_name": "Ivan", "last_name": "Petrov" },
  "allergens": [ { "id": 1, "name": "Gluten" } ],
  "ingredients": [
    { "id": 3, "name": "Pasta", "quantity": 200, "measurement": 1 }
  ]
}
```

### Создание рецепта
`POST /api/recipes/` (требуется токен)

**Тело запроса (JSON):**
```json
{
  "title": "Spaghetti Carbonara",
  "description": "Classic Italian pasta",
  "cooking_time": 30,
  "difficulty": 2,
  "cuisine_id": 1,
  "allergen_ids": [1],
  "ingredients": [
    { "ingredient_id": 3, "quantity": 200, "measurement": 1 }
  ]
}
```

### Обновление рецепта
`PUT /api/recipes/{recipe_id}` (требуется токен и автор рецепта)

**Тело запроса (JSON):**
```json
{
  "title": "Updated title",
  "description": "Updated description",
  "cooking_time": 25,
  "difficulty": 3
}
```

### Удаление рецепта
`DELETE /api/recipes/{recipe_id}` (требуется токен и автор рецепта)

**Ответ:** `204 No Content`

### Получение рецептов
- `GET /api/recipes/` — список всех рецептов
  - Query: `skip` (по умолчанию 0), `limit` (по умолчанию 100)
- `GET /api/recipes/{recipe_id}` — рецепт по ID

### Пагинация и фильтрация
`GET /api/recipes/paginated/`

**Query параметры:**
- `name__like`: строка для поиска по названию
- `ingredient_id`: список ID ингредиентов (можно передавать несколько значений)
- `sort`: поле сортировки (`-id` по умолчанию, минус означает убывание)
- `page`: номер страницы (начиная с 1)
- `size`: размер страницы

**Ответ (пример):**
```json
{
  "items": [/* массив RecipeResponse */],
  "total": 50,
  "page": 1,
  "size": 10,
  "pages": 5
}
```

---

## Cuisines
- `POST /api/cuisines/` — создать
- `GET /api/cuisines/` — список (query: `skip`, `limit`)
- `GET /api/cuisines/{cuisine_id}` — по ID
- `PUT /api/cuisines/{cuisine_id}` — обновить
- `DELETE /api/cuisines/{cuisine_id}` — удалить (204)

**Тело запроса (создание/обновление):**
```json
{ "name": "Italian" }
```

---

## Allergens
- `POST /api/allergens/` — создать
- `GET /api/allergens/` — список (query: `skip`, `limit`)
- `GET /api/allergens/{allergen_id}` — по ID
- `PUT /api/allergens/{allergen_id}` — обновить
- `DELETE /api/allergens/{allergen_id}` — удалить (204)

**Тело запроса (создание/обновление):**
```json
{ "name": "Gluten" }
```

---

## Ingredients
- `POST /api/ingredients/` — создать
- `GET /api/ingredients/` — список (query: `skip`, `limit`)
- `GET /api/ingredients/{ingredient_id}` — по ID
- `PUT /api/ingredients/{ingredient_id}` — обновить
- `DELETE /api/ingredients/{ingredient_id}` — удалить (204)

**Тело запроса (создание/обновление):**
```json
{ "name": "Tomato" }
```

### Рецепты по ингредиенту
`GET /api/ingredients/{ingredient_id}/recipes`

**Query параметры:**
- `include`: список связанных сущностей через запятую (`cuisine, ingredients, allergens, author`)
- `select`: список полей рецепта через запятую (`id, title, difficulty, description, cooking_time`)

**Пример запроса:**
```
GET /api/ingredients/3/recipes?include=cuisine,author&select=id,title
```

**Ответ:** массив объектов рецептов, где состав полей зависит от `include` и `select`.

---

## Общие ошибки
- `400` — некорректные данные (например, неверный пароль или токен)
- `401` — отсутствует или невалиден токен
- `403` — нет прав (например, не superuser)
- `404` — объект не найден
- `422` — ошибка валидации схемы

## Автодокументация
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
