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

RUN apt-get update && apt-get install -y curl

ARG BUILD_CONFIGURATION=Debug
ENV ASPNETCORE_ENVIRONMENT=Development
ENV DOTNET_USE_POLLING_FILE_WATCHER=true  
ENV ASPNETCORE_HTTP_PORTS=80
ENV ASPNETCORE_HTTPS_PORT=443
ENV ASPNETCORE_URLS=https://+:443;http://+:80
ENV HTTP_PORTS=80
ENV HTTPS_PORTS=443
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "AzureWebApi.dll", "--launch-profile http"]

# https://learn.microsoft.com/en-us/dotnet/core/docker/build-container?tabs=linux&pivots=dotnet-8-0
# docker build -t azurewebapi:latest -f Dockerfile .
#
# docker run --rm -it -p 8080:8080 azurewebapi-image:latest
#
# docker run -it --rm --entrypoint "bash" azurewebapi-image:latest
# dotnet run bin/Debug/net8.0/AzureWebApi.dll --launch-profile http
# 
# http://localhost:8080/swagger/index.html
#