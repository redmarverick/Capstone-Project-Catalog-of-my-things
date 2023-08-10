CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE labels (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  color TEXT NOT NULL
);

CREATE TABLE genres (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL
);

CREATE TABLE authors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL
);

CREATE TABLE books (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  label_id UUID REFERENCES labels(id),
  genre_id UUID REFERENCES genres(id),
  author_id UUID REFERENCES authors(id),
  published_date DATE NOT NULL,
  publisher TEXT NOT NULL,
  cover_state TEXT NOT NULL
);

CREATE TABLE music_albums (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  label_id UUID REFERENCES labels(id),
  genre_id UUID REFERENCES genres(id),
  author_id UUID REFERENCES authors(id),
  published_date DATE NOT NULL,
  on_spotify BOOLEAN NOT NULL
);

CREATE TABLE games (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  label_id UUID REFERENCES labels(id),
  genre_id UUID REFERENCES genres(id),
  author_id UUID REFERENCES authors(id),
  published_date DATE NOT NULL,
  last_played_at DATE NOT NULL
);
