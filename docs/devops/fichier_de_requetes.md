# Fichier de requêtes d'accès aux données (CURL)

## Propriétaires et leurs animaux de compagnie

Liste des propriétaires :
```bash
curl -X 'GET' \
  'https://<hostname>/api/customer/owners' \
  -H 'accept: application/json'
```

Ajout d'un propriétaire :
```bash
curl -X 'POST' \
  'https://<hostname>/api/customer/owners' \
  -H 'accept: application/json' \
  -d '{
    "firstName":"Damien",
    "lastName":"Datascientest",
    "address":"Tour Initiale, 1 Terr. Bellini","city":"Puteaux",
    "telephone":"339808079491"
  }'
```

Modification des infos d'un propriétaire :
```bash
curl -X 'PUT' \
  'https://<hostname>/api/customer/owners/{ownerId}' \
  -H 'accept: application/json' \
  -d '{
    "firstName":"Nico",
    "lastName":"Datascientest",
    "address":"Tour Initiale, 1 Terr. Bellini","city":"Puteaux",
    "telephone":"339808079491"
  }'
```


Récupération des infos d'un propriétaire :
```bash
curl -X 'GET' \
  'https://<hostname>/api/customer/owners/{ownerId}' \
  -H 'accept: application/json'
```


Récupération de la liste des animaux d'un propriétaire :
```bash
curl -X 'GET' \
  'https://<hostname>api/customer/owners/{ownerId}/pets' \
  -H 'accept: application/json'
```

Ajouter un animal de compagnie à un propriétaire :
```bash
curl -X 'POST' \
  'https://<hostname>/api/customer/owners/{ownerId}/pets' \
  -H 'accept: application/json' \
  -d '{
    "name":"Rex",
    "birthDate":"2015-08-07T22:00:00.000Z",
    "typeId":"2"
  }'
```

Modifier les infos d'un animal de compagnie :
```bash
curl -X 'POST' \
  'https://<hostname>/api/customer/owners/{ownerId}/pets/{petId}' \
  -H 'accept: application/json' \
  -d '{
    "name":"RexOne",
    "birthDate":"2015-08-07T22:00:00.000Z",
    "typeId":"2"
  }'
```

## Visites

Liste des visites pour un animal de compagnie : 
```bash
curl -X 'GET' \
  'https://<hostname>/api/visit/owners/{ownerId}/pets/{petId}/visits' \
  -H 'accept: application/json'
```

Ajout d'une visite pour un animal de compagnie :
```bash
curl -X 'POST' \
  'https://<hostname>/api/visit/owners/{ownerId}/pets/{petId}/visits' \
  -H 'accept: application/json' \
  -d '{
    "name":"RexOne",
    "birthDate":"2015-08-07T22:00:00.000Z",
    "typeId":"2"
  }'
```

Modification d'une visite pour un animal de compagnie :
```bash
curl -X 'PUT' \
  'https://<hostname>/api/visit/owners/{ownerId}/pets/{petId}/visits/{visitId}' \
  -H 'accept: application/json' \
  -d '{
    "name":"RexOne",
    "birthDate":"2015-08-07T22:00:00.000Z",
    "typeId":"2"
  }'
```


## Vétérinaires et leurs spécialités

Liste des vétérinaires avec leurs spécialités : 
```bash
curl -X GET https://<hostname>/api/vets/vets
```