   
   Upload to Azure Container Registry ...

   1. az login
   2. az acr login --name bmmainacr
   3. docker build -t azurewebapi:latest -f Dockerfile .
   4. docker tag azurewebapi:latest bmmainacr.azurecr.io/web/azure-webapi:latest
   5. docker push bmmainacr.azurecr.io/web/azure-webapi:latest