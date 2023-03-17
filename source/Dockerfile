FROM dart:stable

WORKDIR /app

COPY pubspec.* ./

RUN dart pub get

COPY . .

EXPOSE 9090

ENTRYPOINT ["dart", "run", "conduit:conduit", "serve", "--port", "9090"]