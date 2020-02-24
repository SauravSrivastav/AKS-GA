FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine as build

WORKDIR /src

COPY AKS-GA.csproj .
RUN dotnet restore

COPY . .
RUN dotnet build -c Release

# RUN dotnet test ...

RUN dotnet publish -c Release -o /dist


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80

COPY --from=build /dist /app
CMD ["dotnet", "AKS-GA.dll"]
