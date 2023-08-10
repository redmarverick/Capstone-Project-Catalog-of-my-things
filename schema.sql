CREATE TABLE labels (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  color TEXT NOT NULL
);

CREATE TABLE genres (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  label_id INTEGER REFERENCES labels(id),
  genre_id INTEGER REFERENCES genres(id),
  author_id INTEGER REFERENCES authors(id),
  published_date DATE NOT NULL,
  publisher TEXT NOT NULL,
  cover_state TEXT NOT NULL
);

CREATE TABLE music_albums (
  id SERIAL PRIMARY KEY,
  label_id INTEGER REFERENCES labels(id),
  genre_id INTEGER REFERENCES genres(id),
  author_id INTEGER REFERENCES authors(id),
  published_date DATE NOT NULL,
  on_spotify BOOLEAN NOT NULL
);

CREATE TABLE games (
  id SERIAL PRIMARY KEY,
  label_id INTEGER REFERENCES labels(id),
  genre_id INTEGER REFERENCES genres(id),
  author_id INTEGER REFERENCES authors(id),
  published_date DATE NOT NULL,
  last_played_at DATE NOT NULL
);