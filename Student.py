import pandas as pd
import psycopg2 as pg
import tabulate
conn = pg.connect(
    host="localhost",
    database="Student-db",
    user="postgres",
    password="2006"
)
print("Connection established successfully!")

def display_meua():
    print("1 . display_student")
    print("2 . search_by_student_id ")
    print("3 . Insert_student")
    print("4 . update_Student")
    print("5 . delete_Student")
    print("6 . Exit")
def display_student():
    
    df=pd.read_sql("select student_id,first_name,last_name,phone from student limit 4",conn)
    print(df.to_markdown(index=False))
def search_by_student_id():
    student_id=int(input("Enter a student_id:"))
    dt=pd.read_sql("select first_name,last_name,phone from Student where student_id = %s " % student_id,conn)
    print(dt.to_markdown(index=False))
def insert_Student():
    try:
        student_id=int(input("Enter the Student_id:"))
        first_name=input("Enter the frist name:")
        last_name=input("Enter the last name:")
        phone=input("Enter the phone:")
        Qurey="insert into Student(student_id,first_name,last_name,phone) values (%s,%s,%s,%s)"
        cursor = conn.cursor()
        cursor.execute(Qurey,(student_id,first_name,last_name,phone))
        conn.commit()
        print("the insert is sucessful")
        
    except Exception as e:
        print(f"the errors the insert: {e}")
        conn.rollback()
def update_Student():
     try:
        student_id=int(input("Enter the student_id:"))
        n_first_name=input("Enter the frist name:")
        n_last_name=input("Enter the last name:")
        n_phone=input("Enter the phone:")
        Query="update Student set first_name=%s, last_name=%s, phone=%s where student_id=%s"
        cursor=conn.cursor()
        cursor.execute(Query,(n_first_name,n_last_name,n_phone,student_id))
        conn.commit()
        print("update is successfully")
     except Exception as e:
         print(f"errors the update : {e}")
         conn.rollback()

def delete_Student():
    try:
       student_id=int(input("Enter the student_id:"))
       Query=("delete from Student where student_id=%s")
       cursor=conn.cursor()
       cursor.execute(Query,(student_id,))
       conn.commit()
       print("the delete is successfully")
    except Exception as e:
          print(f"errors the delete : {e}")
          conn.rollback()
def Exit():
    print("Goodbye!!")
    conn.close()

while True:
    display_meua()
    choice=input("Enter a choice (1-6):")
    if choice=='1':
      display_student()
    elif choice=='2':
         search_by_student_id()
    elif choice=='3':
        insert_Student()
    elif choice=='4':
        update_Student()
    elif choice=='5':
        delete_Student()
    elif choice=='6':
        Exit()
        break
    else:
        print("Invalid choice ,please select 1-6 ")
    

    