FROM python:3.11.0b1-buster

# set work directory
WORKDIR /app


# dependencies for psycopg2
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-dev=3.7.3-1
RUN apt-get install --no-install-recommends -y libpq-dev=11.16-0+deb10u1
RUN apt-get install --no-install-recommends -y libisc1100=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y libdns1104=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y libisccc161=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y libisccfg163=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y liblwres161=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y libbind9-161=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y libirs161=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y bind9-host=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get install --no-install-recommends -y dnsutils=1:9.11.5.P4+dfsg-5.1+deb10u7
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*


# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# Install dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# copy project
COPY . /app/


# install pygoat
EXPOSE 8000


RUN python3 /app/manage.py migrate
WORKDIR /app/pygoat/
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]
