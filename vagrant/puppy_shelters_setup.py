import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine

Base = declarative_base()


class Shelter(Base):
    __tablename__ = 'shelter'

    id = Column(Integer, primary_key=True)
    name = Column(String(250), nullable=False)
    address = Column(String(250), nullable=False)
    city = Column(String(250), nullable=False)
    state = Column(String(2), nullable=False)
    zipCode = Column(Integer(5), nullable=False)
    website = Column(String(250), nullable=False)

class Puppy(Base):
    __tablename__ = 'puppy'

    name = Column(String(80), nullable=False)
    shelter_id = Column(Integer, ForeignKey('shelter.id'))
    dateOfBirth = Column(String(250))
    gender = Column(String(8))
    weight = Column(String(250))
    picture = Column(String, primary_key=True)


engine = create_engine('sqlite:///puppies.db')


Base.metadata.create_all(engine)