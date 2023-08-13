# Petclinic - Docker

Ce document explique les étapes à suivre pour configurer et exécuter le projet **« petclinic microservice »** dans des containers Docker, quelle que soit votre infrastructure.
Pour ce faire, voici les étapes à suivre.
## 1. Prérequis avant l'exécution des images docker
### 1.1. Installation JAVA
Une version de JAVA >= 17 est requise pour l'exécution du projet.
La variable d'environnement JAVA_HOME pointant sur le répertoire contenant le sous-répertoire _"bin"_ de JAVA doit être créée.
### 1.2. Variable d'environnement "PETCLINIC_HOME"
La variable d'environnement *"PETCLINIC_HOME"* est nécessaire, car elle est utilisée par certains scripts. Sa valeur est le répertoire racine du projet **_"petclinic-microservices-devops"_**.
Il faudra mettre le chemin complet de ce répertoire comme valeur de cette variable d'environnement :
- **Sous Linux** : exécuter `pwd` dans un terminal depuis le dossier **_"petclinic-microservices-devops"_** pour afficher ce chemin ;
- **Sous Windows** : exécuter `echo %cd%` dans une invite de commande depuis le dossier **_"petclinic-microservices-devops"_** pour afficher ce chemin.
## 2. Paramétrage dans le projet de base (" petclinic-microservices-devops")

Les différents éléments ajoutés dans la version d’origine du projet pour mettre exécuter le projet **_"petclinic microservices"_** dans des containers sont expliquées ci-après.
### Dans le dossier "scripts" :

#### Un sous-dossier "devops" contentant les scripts :
**_run_container_app.sh_** : le script utilisé par les différentes applications pour s’exécuter dans les containers.  
Ce script peut être lancé avec deux arguments :
- **_delay_** : premier argument (entier) du script pour indiquer le temps d’attente avant le démarrage de l’application lancée par le script ;
- **_profile_** : le profil « spring boot » utilisé par l’application démarrée par le script dans le container.
Ces arguments permettent d’une part d’assurer le bon ordonnancement du démarrage des applications et d’autre part la possibilité de démarrer les applications sous différents profils. Sans argument, les applications démarrent immédiatement avec le profil par défaut. 

**_build_image2.sh_** : le script qui permet de générer les images Docker utilisées pour lancer les containers. Ce script doit être lancé avec au moins l'argument :
- **_app_** : qui correspond au microservice dont on souhaite générer une image docker. Les valeurs possibles sont :
    * config : pour le microservice **_config-server_**.
    * discovery : pour le microservice **_discovery-server_**.
    * customers : pour le microservice **_customers-service_**.
    * vets : pour le microservice **_vets-service_**.
    * visits : pour le microservice **_visits-service_**.
    * admin : pour le microservice **_admin-server_**.
    * api-gateway : pour le microservice **_api-gateway_**.

Ce script peut être lancé avec les 3 autres arguments optionnel suivant :
- **_docker_id_** : l'identifiant du compte dockerhub pour lequel les images sont générées. Sa valeur par défaut est **_« agdgpn »_** un utilisateur créé pour le projet.
- **_tag_** : le tag de l'image à générer. Sa valeur par défaut est **_« latest»_**
- **_scope_** : pour le scope de génération de l'image. Si la valeur du scope est différente de **_« dockerhub »_** qui est sa valeur par défaut, une image locale sera générée sinon une image au format dockerhub sera générée.

En sortie, le script génère une image docker avec le suffixe **_« -image »_** est concaténé avec le nom d’application fourni en argument si **_« dockerhub »_** n'est la valeur de l'argument **_« scope »_**.
Sinon l'image est généré avec un préfixe **_docker_id/_** et pourra être poussé dans un dépôt du compte dockerhub de cet utilisateur. 

**Exemple :** L'exécution du script avec la commande ci-dessous permet de générer l'image ***config-image***.<br>
`./build_image2.sh config` va générer l'image **_« agdgpn/config-image:latest »_**.<br>
`./build_image2.sh config mon-id-docker 1.0` va générer l'image **_« mon-id-docker/config-image:1.0 »_**.

**Remarque** : <br> - Il est important de fournir les bons arguments au script de lancement des applications dans les containers. Par exemple pour les microservices utilisant la base de données, l’utilisation du profil « mysql » est obligatoire.

### Dans le dossier "docker" :
#### Un sous-dossier "devops" contentant les fichiers :
- **_generic-dockerfile_** : le fichier permettant de fabriquer les images Docker pour chaque application ou microservice.
-  **_docker-compose_** : pour le lancement des containers utilisés dans la phase de test du pipeline Jenkins. 
### Dans les applications et microservices :
#### Aller dans src > main > resources pour éditer le fichier "application.yml".

**Remarque :** Ces modifications étant déjà effectuées dans l'une des branches de développement du projet, il suffit de se mettre à jour avec ces branches pour les avoir automatiquement.

## 3. Paramétrage dans le projet de configuration ("petclinic-microservices-config-devops")
Le projet **_petclinic-microservices-config-devops_** est dans un dépôt github séparé contient la configuration centralisée des microservices et est géré par le microservice **_config-server_**. Ce dernier fournira aux autres microservices leurs configurations depuis la branche indiquée dans son fichier de configuration.
### Modifier les fichier *.yml se trouvant à la racine de ce projet.

**Remarque :** Ces modifications étant déjà effectuées dans la branche master du projet, il suffit de se mettre à jour avec ces branches pour les avoir automatiquement. Normalement, ces modifications sont effectuées au démarrage du projet et n'évolueront plus après.

## 4. Exécution
Pour exécuter les différentes applications du projet, il suffit d'exécuter la commande suivante
`docker-compose -f docker/devops/docker-compose.yml up -d` depuis le répertoire **_PETCLINIC_HOME_**

**Important** : Dans le fichier _"docker-compose.yml"_, la valeur de la variable d'environnement **_GIT_USER_** doit correspondre à un nom d'utilisateur _github_ ayant les droits de cloner le projet **_petclinic-microservices-config-devops_** et la valeur de **_GIT_PASS_** doit correspondre à un _"token"_ _github_ valide pour effectuer cette action de clonage de ce projet.

**Remarques** : 
- La gestion du temps d'attente avant le démarrage de chaque application est paramétrée dans le fichier _"docker-compose.yml"_. 
- Les profils _spring-boot_ utilisés sont aussi paramétrés dans le _"docker-compose.yml"_.
- La génération d'images locales (non au format dockerhub) est requise pour exécuter les containers avec le fichier _"docker-compose.yml"_.