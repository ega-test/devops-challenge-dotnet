# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy src and restore as distinct layers
COPY *.sln .
COPY src ./src
# tests are dependencies
COPY tests ./tests
RUN dotnet restore "./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj"

# copy and publish app and libraries
COPY . .
RUN mkdir /app
RUN dotnet publish -c release "./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj" -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime:5.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "DevOpsChallenge.SalesApi.dll"]
