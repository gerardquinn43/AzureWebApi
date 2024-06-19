   
   Upload to Azure Container Registry ...

   1. az login
   2. az acr login --name bmmainacr
   3. docker build -t bmmainacr.azurecr.io/web/azure-webapi:latest -f Dockerfile .
   4. docker tag azure-webapi:latest bmmainacr.azurecr.io/web/azure-webapi:latest
   5. docker push bmmainacr.azurecr.io/web/azure-webapi:latest
   6. integrate acr+aks - az aks update --name bmakscluster --resource-group DefaultResourceGroup-SUK --attach-acr bmmainacr.azurecr.io
   
   7. az role assignment create --assignee 0c8067d7-f056-4667-b488-6dc82a349fee --scope /subscriptions/a68f78ab-30b8-4143-a578-d806e6f9fc85/resourceGroups/DefaultResourceGroup-SUK/providers/Microsoft.ContainerRegistry/registries/bmmainacr --role acrpull

docker run --rm -it -p 8080:8080 bmmainacr.azurecr.io/web/azure-webapi:latest


docker run -it --rm --entrypoint "bash" bmmainacr.azurecr.io/web/azure-webapi:latest



http://localhost:8080/swagger/index.html

http://localhost:8080/healthz

http://0.0.0.0:8080/

