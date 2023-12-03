from sqlalchemy import create_engine, ForeignKey, Column, String, Integer, CHAR, Float, Enum, Text, Date, Time
from sqlalchemy import MetaData, update, and_, func, delete
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
import enum
from datetime import date, time
from fastapi import FastAPI, Request, Depends, Form, status
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
import random

Base = declarative_base()

class C_enum(enum.Enum):
    babysitter = "babysitter"
    caregiver_for_elderly = "caregiver for elderly"
    playmate_for_children = "playmate for children"
    
class W_enum(enum.Enum):
    confirmed = "confirmed"
    declined = "declined"
    in_progress = "in progress"
    
class User(Base):
    __tablename__ = "users"
    
    user_id = Column('user_id', Integer, primary_key=True)
    email = Column('email', String)
    given_name = Column('given_name', String)
    surname = Column('surname', String)
    city = Column('city', String)
    phone_number = Column('phone_number', String)
    profile_description = Column('profile_description', String)
    password = Column('password', String)
    
    caregiver = relationship('Caregiver', back_populates='user', cascade="all, delete, delete-orphan", uselist=False, passive_deletes=True)
    member = relationship('Member', back_populates='user', cascade="all, delete, delete-orphan", uselist=False, passive_deletes=True)
    
    def __repr__(self):
        return f"({self.user_id}) {self.given_name} {self.surname} {self.profile_description}"
    
    
class Caregiver(Base):
    __tablename__ = "caregivers"
    
    caregiver_user_id = Column('caregiver_user_id', Integer, ForeignKey('users.user_id', ondelete="cascade"), primary_key=True)
    photo = Column('photo', String)
    gender = Column('gender', CHAR)
    caregiving_type = Column('caregiving_type', Enum(C_enum, name = 'care_type', create_type=False))
    hourly_rate = Column('hourly_rate', Float)
    
    user = relationship('User', back_populates='caregiver', cascade="all, delete", passive_deletes=True)
    
    job_application = relationship('Job_application', cascade="all, delete, delete-orphan", back_populates='caregiver', passive_deletes=True)
    appointment = relationship('Appointment', cascade="all, delete, delete-orphan", back_populates='caregiver', passive_deletes=True)

        
class Member(Base):
    __tablename__ = "members"
    
    member_user_id = Column('member_user_id', Integer, ForeignKey('users.user_id', ondelete="cascade"), primary_key=True)
    house_rules = Column('house_rate', String)
    
    user = relationship('User', back_populates='member', cascade="all, delete", passive_deletes=True)
    
    address = relationship('Address', cascade="all, delete, delete-orphan", back_populates='member', uselist=False, passive_deletes=True)
    job = relationship("Job", cascade="all, delete, delete-orphan", back_populates='member', passive_deletes=True)
    appointment = relationship('Appointment', cascade="all, delete, delete-orphan", back_populates='member', passive_deletes=True)

    
class Address(Base):
    __tablename__ = "address"
    
    member_user_id = Column('member_user_id', Integer, ForeignKey('members.member_user_id', ondelete="cascade"), primary_key=True)
    house_number = Column('house_number', Integer)
    street = Column('street', String)
    town = Column('town', String)
    
    member = relationship('Member', back_populates='address', cascade="all, delete", uselist=False, passive_deletes=True)
    

class Job(Base):
    __tablename__ = "jobs"
    
    job_id = Column('job_id', Integer, primary_key=True)
    member_user_id = Column('member_user_id', Integer, ForeignKey('members.member_user_id', ondelete="cascade"))
    required_caregiving_type = Column('required_caregiving_type', Enum(C_enum, name = 'type', create_type=False))
    other_requirements = Column('other_requirements', Text)
    date_posted = Column('date_posted', Date)
    
    member = relationship("Member", cascade="all, delete", back_populates='job', passive_deletes=True)
    
    job_application = relationship('Job_application', back_populates='job', cascade="all, delete, delete-orphan", passive_deletes=True)
        
    
class Job_application(Base):
    __tablename__ = "job_applications"
    
    caregiver_user_id = Column('caregiver_user_id', Integer, ForeignKey('caregivers.caregiver_user_id', ondelete="cascade"), primary_key=True)
    job_id = Column('job_id', Integer, ForeignKey('jobs.job_id', ondelete="cascade"), primary_key=True)
    date_applied = Column('date_applied', Date)
    
    job = relationship('Job', back_populates='job_application', cascade="all, delete", passive_deletes=True)
    caregiver = relationship("Caregiver", cascade="all, delete", back_populates='job_application', passive_deletes=True)


class Appointment(Base):
    __tablename__ = "appointments"
    
    appointment_id = Column('appointment_id', Integer, primary_key=True)
    caregiver_user_id = Column('caregiver_user_id', Integer, ForeignKey('caregivers.caregiver_user_id', ondelete="cascade"))
    member_user_id = Column('member_user_id', Integer, ForeignKey('members.member_user_id', ondelete="cascade"))
    appointment_date = Column('appointment_date', Date)
    appointment_time = Column('appointment_time', Time)
    work_hours = Column('work_hours', Integer)
    status = Column('status', Enum(W_enum, name = 'status', create_type=False))
    
    member = relationship("Member", cascade="all, delete", back_populates='appointment', passive_deletes=True)
    caregiver = relationship("Caregiver", cascade="all, delete", back_populates='appointment', passive_deletes=True)
    
# DATABASE_URL = "postgresql://postgres:qwerty@localhost:5432/postgres"
DATABASE_URL = "postgresql://db_caregiving_user:iqduB6Ej4u3l8mfEcpJUxSAN1t0iLKzW@dpg-cledn6fpc7cc73enr6jg-a.oregon-postgres.render.com/db_caregiving"

engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)
 
templates = Jinja2Templates(directory="templates")

import os

if os.getenv('VIRTUAL_ENV'):
    print('Using Virtualenv')
else:
    print('Not using Virtualenv')
app = FastAPI()

from pathlib import Path

BASE_DIR = Path('main.py').resolve().parent

# import os
# script_dir = os.path.dirname(__file__)
# st_abs_file_path = os.path.join(script_dir, "static/")
# app.mount("/static", StaticFiles(directory=st_abs_file_path), name="static")
app.mount("/static", StaticFiles(directory="static"), name="static")
 
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
 
@app.get("/")
async def home(request: Request, db: Session = Depends(get_db)):
    users = db.query(User).order_by(User.user_id.asc())
    return templates.TemplateResponse("index.html", {"request": request, "users": users})
 
@app.get("/addnew/member")
async def addnew(request: Request):
    return templates.TemplateResponse("addnew_member.html", {"request": request})

@app.get("/addnew/caregiver")
async def addnew(request: Request):
    return templates.TemplateResponse("addnew_care.html", {"request": request})

@app.post("/add/member")
async def add(request: Request, given_name: str = Form(...), surname: str = Form(...), email: str = Form(...), 
              phone_number: str = Form(...), profile_description: str = Form(...), password: str = Form(...), 
              house_rules: str = Form(...), db: Session = Depends(get_db)):
    r = random.randint(30, 80)
    users = User(user_id = r, given_name=given_name, surname=surname, email=email, phone_number=phone_number, profile_description=profile_description,
                 password=password)
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.post("/add/caregiver")
async def add(request: Request, given_name: str = Form(...), surname: str = Form(...), email: str = Form(...), 
              phone_number: str = Form(...), profile_description: str = Form(...), password: str = Form(...), 
              photo: str = Form(...), gender: str = Form(...), caregiving_type: str = Form(...), db: Session = Depends(get_db)):
    if caregiving_type == "babysitter":
        care = C_enum.babysitter
    elif caregiving_type == "caregiver for elderly":
        care = C_enum.caregiver_for_elderly
    else:
        care = C_enum.playmate_for_children
    users = User(given_name=given_name, surname=surname, email=email, phone_number=phone_number, profile_description=profile_description,
                 password=password)
    caregivers = Caregiver(caregiver_user_id = users.user_id, photo = photo, gender=gender, caregiving_type = care, user = users)
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.get("/edit/{user_id}")
async def edit(request: Request, user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.user_id == user_id).first()
    return templates.TemplateResponse("edit.html", {"request": request, "user": user})

@app.get("/addnew/address")
async def addnew(request: Request):
    return templates.TemplateResponse("addnew_address.html", {"request": request})

@app.get("/address/{member_user_id}")
async def address(request: Request, member_user_id: int, db: Session = Depends(get_db)):
    address = db.query(Address).filter(Address.member_user_id == member_user_id).all()
    return templates.TemplateResponse("address.html", {"request": request, "address": address})

@app.post("/add/address")
async def add(request: Request, member_user_id: int, town: str = Form(...), street: str = Form(...), house_number: str = Form(...), 
                      db: Session = Depends(get_db)):
    address = Address(member_user_id=member_user_id, town=town, street=street, house_number=house_number)
    db.add(address)
    db.commit()
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.get("/members")
async def members(request: Request, db: Session = Depends(get_db)):
    members = db.query(Member).order_by(Member.member_user_id.asc())
    return templates.TemplateResponse("member.html", {"request": request, "members": members})

@app.get("/caregivers")
async def caregivers(request: Request, db: Session = Depends(get_db)):
    caregivers = db.query(Caregiver).order_by(Caregiver.caregiver_user_id.asc())
    return templates.TemplateResponse("caregiver.html", {"request": request, "caregivers": caregivers})

@app.get("/addnew/job")
async def addnew(request: Request):
    return templates.TemplateResponse("job.html", {"request": request})

@app.post("/add/job")
async def add(request: Request, job_id: int, member_user_id: int, required_caregiving_type: str = Form(...), 
              other_requirements: str = Form(...), 
                      db: Session = Depends(get_db)):
    job = Job(job_id = job_id, member_user_id=member_user_id, required_caregiving_type = C_enum.babysitter, other_requirements = other_requirements, date_posted = date(23,11,25))
    db.add(job)
    db.commit()
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.get("/jobs")
async def jobs(request: Request, db: Session = Depends(get_db)):
    jobs = db.query(Job).order_by(Job.job_id.asc())
    return templates.TemplateResponse("jobs.html", {"request": request, "jobs": jobs})

@app.get("/editjob/{job_id}")
async def edit(request: Request,job_id: int, db: Session = Depends(get_db)):
    jobs = db.query(Job).filter(Job.job_id == job_id).first()
    return templates.TemplateResponse("edit_jobs.html", {"request": request, "jobs": jobs})

@app.get("/appointment")
async def appointment(request: Request, db: Session = Depends(get_db)):
    appointments = db.query(Appointment).order_by(Appointment.appointment_id.asc())
    return templates.TemplateResponse("appointment.html", {"request": request, "appointments": appointments})

@app.get("/addnew/appointment")
async def addnew(request: Request):
    return templates.TemplateResponse("new_appointment.html", {"request": request})

@app.post("/add/appointment")
async def add(request: Request, appointment_id: int, member_user_id: int, caregiver_user_id: int, appointment_date : str = Form(...), 
              appointment_time : str = Form(...), work_hours : str = Form(...),dtatus: str = Form(...),
                      db: Session = Depends(get_db)):
    appointment = Appointment(appointment_id=appointment_id, member_user_id=member_user_id, caregiver_user_id=caregiver_user_id, 
                              appointment_date = date(23,11,25), appointment_time=time(20,40), status=W_enum.in_progress)
    db.add(appointment)
    db.commit()
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.get("/delete/{user_id}")
async def delete(request: Request, user_id: int, db: Session = Depends(get_db)):
    users = db.query(User).filter(User.user_id == user_id).first()
    db.delete(users)
    db.commit()
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.get("/deletejob/{job_id}")
async def delete(request: Request, job_id: int, db: Session = Depends(get_db)):
    jobs = db.query(Job).filter(Job.job_id == job_id).first()
    db.delete(jobs)
    db.commit()
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)

@app.get("/addnew/application")
async def addnew(request: Request):
    return templates.TemplateResponse("application.html", {"request": request})

@app.post("/add/application")
async def add(request: Request, caregiver_user_id: int, job_id: int, date_applied : str = Form(...), 
                      db: Session = Depends(get_db)):
    job_application = Job_application(job_id=job_id, caregiver_user_id=caregiver_user_id, 
                              date_applied = date(23,11,25))
    db.add(job_application)
    db.commit()
    return RedirectResponse(url=app.url_path_for("home"), status_code=status.HTTP_303_SEE_OTHER)