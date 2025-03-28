# Use an official Python runtime as a parent image
FROM python:3.6

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    git \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip setuptools wheel

# Install specific packages first to take advantage of Docker caching
RUN pip3 install yarl multidict

# Copy the requirements file into the container and install dependencies
COPY requirements.txt .

# Install the dependencies
RUN pip3 install -r requirements.txt || \
    (echo "Could not find pyrofork package, please check the source or remove it from requirements.txt" && exit 1)

# Make port 80 available to the world outside this container
EXPOSE 80

# Run app.py when the container launches
CMD ["python", "app.py"]
