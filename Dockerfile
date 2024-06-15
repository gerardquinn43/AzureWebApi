FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

ARG BUILD_CONFIGURATION=Debug
ENV ASPNETCORE_ENVIRONMENT=Development
ENV DOTNET_USE_POLLING_FILE_WATCHER=true  
ENV ASPNETCORE_HTTP_PORTS=8080
ENV ASPNETCORE_HTTPS_PORT=8585
ENV ASPNETCORE_URLS=https://+:8585;http://+:8080
ENV HTTP_PORTS=8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "AzureWebApi.dll", "--launch-profile http"]

# https://learn.microsoft.com/en-us/dotnet/core/docker/build-container?tabs=linux&pivots=dotnet-8-0
# docker build -t azurewebapi-image -f Dockerfile .
#
# docker run --rm -it -p 8080:8080 azurewebapi-image:latest
#
# docker run -it --rm --entrypoint "bash" azurewebapi-image:latest
# dotnet run bin/Debug/net8.0/AzureWebApi.dll --launch-profile http
# 
# http://localhost:8080/swagger/index.html
#