# Petclinic - Kubernetes

Ce document explique les étapes à suivre pour déployer le projet petclinic dans un cluster Kubernetes. Les fichiers de configuration pour déployer les différents microservices dans _Kubernetes_ se trouvent dans le dossier **_« kubernetes »_** se trouvant à la racine du dépôt du projet.
## 1. Déploiement standard
Le sous-répertoire _« standard »_ se trouvant dans le répertoire _kubernetes_ contient les fichiers de configuration pour déployer les microservices en utilisant **_kubectl_**, l'outil en ligne de commande de kubernetes.
Le déploiement standard d’une application (microservice) peut se faire avec kubectl en précisant le fichier de configuration Yaml de l’application à déployer dans la commande à exécuter pour effectuer ce déploiement :
`Kubectl -n <namespace> apply -f <chemin_vers_config_appli.yaml>` où : 

**_\<namespace\>_** : est le namespace dans lequel on souhaite déployer l’application ;<br>
**_\<chemin_vers_config_appli.yaml\>_** : est le chemin relatif au fichier de config depuis l’endroit où la commande « kubectl » est exécutée.<br>
**Exemple** : La commande suivante, exécutée depuis la racine du projet, permet de déployer le micro service **_« config-server »_** dans le namespace **_dev_** est : `kubectl -n dev -f kubernetes/standard/config-kube.yml`.  

**Attention** : Il faudra respecter l’ordre de déploiement ci-dessous pour le bon fonctionnement des microservices. 

Il faudra dans un premier temps, déployer la base de données et veiller à ce qu'il soit en cours d'exécution au moment du déploiement des microservices qui y dépendent (customers-service, vets-service et visits-service).
Ensuite, il faudra déployer le microservice de configuration (config-server), puis déployer le microservice annuaire (discovery-server). On pourra par la suite déployer les microservices utilisant la base de données (customers-service, vets-service et visits-service) et enfin finir par le déploiement du microservice api-gateway qui est le service front permettant d’accéder aux fonctionnalités offertes par les services de backend. 

## 2. Gestion des microservices avec helm
Helm est un gestionnaire de paquets (applications) dans un cluster **Kubernetes**.
Le sous-répertoire **_« helm »_** du dossier **kubernetes** contient les charts _helm_ permettant de gérer (installer / désinstaller) les microservices dans le cluster **Kubernetes**.

### 2.1. Script d'installation de microservices avec helm
Le script scrips/devops/helm_install permet :
-	De déployer une application avec les gestionnaires de paquets helm avec la commande :
`./scripts/devops/helm_install.sh <app> <namespace>`, où:<br>
**_\<app\>_** est le nom court de l’application (par exemple config pour l’application config-server);<br>
**_\<namespace\>_** est le namespace dans lequel on souhaite déployer l’application.
-	De déployer toutes les applications d’un coup avec le gestionnaire de paquets helm avec la commande :
`./scripts/devops/helm_install.sh all <namespace>`, où :<br>
**_\<namespace\>_** est le namespace dans lequel on souhaite déployer toutes les applications.

**Remarques** :
-	L’utilisation du script d’installation requiert l’installation de helm.
-	Le script peut être lancé depuis le dossier racine du projet en précisant son chemin relatif par rapport à ce dossier ou depuis le dossier _"scripts/devops"_ en indiquant juste le nom du script (_./helm_install.sh_).

### 2.1. Script de désinstallation de microservices avec helm
Le script _"scrips/devops/helm_uninstall"_ permet :
-	Désinstaller (avec les mêmes arguments que lors de l'installation) un microservice avec la commande : 
`./scripts/devops/helm_uninstall.sh <app>  <namespace>`
-	Désinstaller tous les microservices d’un coup avec la commande :<br>
`./scripts/devops/helm_uninstall.sh all <namespace>`


