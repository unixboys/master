FROM node:18-bullseye

# Enable 32-bit architecture for Android build tools (aapt)
RUN dpkg --add-architecture i386

# Install Java (required for apktool and keytool) and 32-bit libraries
RUN apt-get update && apt-get install -y \
    default-jdk \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    lib32z1 \
    libbz2-1.0:i386 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application
COPY . .

# Expose ports
# 8080: Web Interface
# 22222: Control/Socket Port
EXPOSE 8080 22222

# Start the application
CMD ["npm", "start"]
