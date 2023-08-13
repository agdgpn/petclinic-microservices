# Petclinic - Jenkins
Ce document explique les étapes à suivre pour mettre en place avec Jenkins, un _pipeline CI/CD_ pour le projet _petclinic_, déployé dans un cluster Kubernetes. Le script du _pipeline_ se trouve dans le dossier **_pipeline/jenkins_**.
## 1. Installation de jenkins
Jenkins est installé avec un script _« user_data »_ fourni dans le fichier de configuration _terraform_ utilisé pour créer l’instance Jenkins dans _AWS_.
Voici une description des étapes principales de préparation et de configuration de l’environnement qui sont exécutées par le script :
-	Installation de Java<br>
`sudo apt install openjdk-11-jdk-headless -y`
-	Installation de curl<br>
`sudo apt install curl -y`
-	Installation de Jenkins<br>
`   curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \`<br>
`   /usr/share/keyrings/jenkins-keyring.asc > /dev/null`<br>
`   echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \`<br>
`   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \`<br>
`   /etc/apt/sources.list.d/jenkins.list > /dev/null`<br>
`   sudo apt update -y`<br>
`   sudo apt-get install jenkins -y`<br>
`   sudo systemctl start jenkins`<br>
`   sudo systemctl enable --now jenkins`<br>
-	Changement du port par défaut utilisé par Jenkins, 8080 en utilisant le port 9000 pour éviter un conflit avec le port du microservice _api-gateway_ :<br>
` # Jenkins config to set default port to 9000.`<br>
    `echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null`<br>
    `sudo su jenkins`<br>
    `sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=9000"/' /usr/lib/systemd/system/jenkins.service`<br>
    `sudo sed -i -e 's/^\s*#\s*AmbientCapabilities=CAP_NET_BIND_SERVICE/AmbientCapabilities=CAP_NET_BIND_SERVICE/' /usr/lib/systemd/system/jenkins.service
    sudo systemctl daemon-reload`<br>
    `sudo systemctl restart jenkins`<br>
## 2.	Installation des outils requis pour l’ exécution du pipeline
Le script **_« jenkins_requirements.sh »_** est créé pour installer tous les outils nécessaires à l’exécution du pipeline Jenkins. Pour installer ces outils, il suffit créer un job Jenkins de type freestyle (New Item > Construire un projet free-style) puis choisir _« Exécuter un script shell »_ dans la section _« Build Steps »_ et copier le contenu du script **_« jenkins_requirements.sh »_** dans le champ prévu pour le contenu du script et enfin cliquer sur le bouton **_« Sauver »_**.
Une fois ce job créé, il suffit de le lancer manuellement pour exécuter le script de création des logiciels et outils requis pour le _pipeline CI/CD_ du projet _petclinic_.
## 3.	Configuration du pipeline dans Jenkins
Pour configurer le _pipeline CI/CD_ du projet _petclinic microservices_ dans Jenkins, il faut créer un job Jenkins de type _pipeline_ : 
-	Cliquer sur **_« Tableau de bord »_** en haut à droite ;
-	Cliquer sur **_« Nouveau Item »_** dans le menu de gauche
-	Mettre _« petclinic »_ dans le champ **_« Saisissez un nom »_**
-	Sélectionner Pipeline comme type de job puis cliquer sur **_« OK »_**
-	Mettre **_« Petclinic Microservices »_** dans le champ **_« Description »_**
-	Cocher **_« GitHub project »_** dans la section **_« General »_**
-	Mette l’url du projet github : _git@github.com:damien-gregoire/petclinic-microservices-devops.git_
-	Dans la section **_« Build Triggers »_**, cocher **_« GitHub hook trigger for GITScm polling »_**
-	Dans la section **_«Pipeline»_**, sélectionner **_« Pipeline script from SCM »_**
-	Choisir **_« Git »_** pour le champ **_« SCM »_**.
-	Mettre l’url du projet dans le champ « Repository URL » (_git@github.com:damien-gregoire/petclinic-microservices-devops.git_) .
-	Dans la partie **_« Branches to build »_**, laisser la valeur par défaut **_« */master »_**
-	Dans la partie **_« Script Path »_** mettre le nom du _« jenkinsfile »_ avec son chemin relatif depuis la racine du projet (_pipeline/jenkins/Jenkinsfile_).
-	Cliquer sur **_« Sauver »_** pour terminer la configuration du pipeline Jenkins.
Dans l’état actuel, le pipeline est configuré, mais la communication avec github n’est pas encore effective, car il faut générer une paire de clés dans le serveur Jenkins puis copier la clé publique dans _GitHub_. Cette configuration sera détaillée dans la section suivante.
## 4.	Configurations dans GitHub
Les configurations à faire dans _Github_ concernent l’ajout de la clé publique dans le compte _GitHub_ d’une part et la configuration d’un **_« webhook »_** du projet pour déclencher automatiquement le pipeline après une modification de type **_« push »_** dans la branche **_« master »_** du projet.
### 4.1.	Configuration clé SSH du serveur Jenkins dans GitHub
Pour configurer la clé _SSH_ dans _GitHub_, il faudra dans un premier temps générer une paire de clés SSH sur le serveur Jenkins avec ssh-keygen. Puis dans un second temps, ajouter la clé publique (contenu de « ~/.ssh/id_rsa.pub » ) depuis la section **_« SSH key »_** des paramètres du compte _GitHub_.
### 4.2.	Configuration webhook du projet GitHub 
Pour configurer un **_« webhook »_** pour le projet _Petclinic_, il faudra ouvrir les paramètres du projet.
**Attention** : avec un compte gratuit GitHub, les paramètres d’un projet sont uniquement visibles pour la personne qui a créé le projet. Ce dernier est donc la seule personne à configurer le projet à travers ces paramètres.
Une fois les paramètres du projet ouverts, il faut cliquer sur **_« Webhooks »_** dans le menu de gauche, puis :
-	Cliquer sur **_« Add webhook »_** en haut à droite
-	Saisir le mot de passe du compte sur la popup ouverte puis valider
-	Dans le champ **_« Payload url »_**, ajouter l’url du serveur Jenkins avec le suffixe **_« /github-webhook/ »_**.
Par exemple : _http://34.244.27.89:8080/github-webhook/_ si l’url du serveur Jenkins est _http://34.244.27.89:8080_.
-	Choisir **_« application/json »_** comme **_« Content type »_**
-	Dans la section **_« Which events would you like to trigger this webhook? »_**, choisir **_« Let me select individual events. »_**
-	Cocher les cases suivantes :
    *	_Branch or tag creation_
    *	_Branch or tag deletion_
    *	_Packages_
    *	_Pull request review comments_
    *	_Pull request reviews_
    *	_Pushes_
    *	_Registry packages_
