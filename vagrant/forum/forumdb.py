#
# Database access functions for the web forum.
# 

import bleach
import time

## Database connection
#DB = []
import psycopg2

## Get posts from database.
def GetAllPosts():
    DB = psycopg2.connect("dbname=forum")
    c = DB.cursor()
    c.execute("SELECT time, content FROM posts ORDER BY time DESC")
    posts = ({'content': str(row[1]), 'time': str(row[0])}
             for row in c.fetchall())
    DB.close()
    return posts

## Add a post to the database.
def AddPost(content):
    DB = psycopg2.connect("dbname=forum")
    content = bleach.clean(content)
    c = DB.cursor()
    c.execute("UPDATE posts set content = 'cheese' where content like '%spam%';")
    c.execute("DELETE FROM posts where content = 'cheese'")
    c.execute("INSERT INTO posts (content) VALUES (%s)",
              (content,))
    DB.commit()
    DB.close()
