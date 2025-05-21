# 📊 Analyse ACP & Clustering K-Means sur le World Happiness Report 2019

Ce projet applique une **Analyse en Composantes Principales (ACP)** et un **clustering K-means** sur les données du **World Happiness Report 2019**. L'objectif est de réduire la dimensionnalité des données pour mieux visualiser les relations entre pays, puis regrouper ces pays selon leurs caractéristiques socio-économiques.

---

## 🎯 Objectifs
- Appliquer l'**ACP** pour explorer et visualiser les corrélations entre variables.
- Utiliser l'interface **Factoshiny** pour une exploration interactive des résultats.
- Appliquer le **clustering K-means** sur les composantes principales pour regrouper les pays.
- Générer des visualisations exploitables : cercle des corrélations, scree plot, clusters.

---

## 🧩 Technologies et packages utilisés
- Langage : **R**
- Packages :
  - FactoMineR
  - factoextra
  - cluster
  - tidyverse
  - readr
  - Factoshiny

---

## 📁 Structure du projet
| Fichier / Script | Description |
|-------------------------------|-------------|
| 2019.csv | Fichier de données du rapport |
| script_acp_kmeans.R | Script principal contenant tout le pipeline : prétraitement, ACP, clustering |
| README.md | Documentation du projet |
| *.png | Graphiques générés automatiquement lors de l'analyse |

---

## 🚀 Instructions pour exécuter le projet
1. **Cloner le dépôt :**
```bash
git clone https://github.com/ton-utilisateur/nom-du-repo.git
```

2. **Ouvrir le script** `script_acp_kmeans.R` dans RStudio.

3. **Installer les packages nécessaires :**
Le script contient une fonction pour installer automatiquement les packages manquants :
```r
packages <- c("FactoMineR", "factoextra", "tidyverse", "cluster", "readr", "Factoshiny") 
# La fonction install_if_missing() s'en charge automatiquement
```

4. **Lancer l'analyse interactive avec Factoshiny (option 1) :**
```r
PCAshiny(data_scaled)
```
Cette commande ouvre une interface graphique dans votre navigateur pour visualiser l'ACP.

5. **Ou exécuter l'analyse en script (option 2) :**
```r
resultats <- analyser_resultats_acp(data_scaled, nb_clusters = 3)
```
Les graphiques suivants seront générés :
* `01_screeplot_variance.png`
* `02_cercle_correlations.png`
* `03_projection_pays_PCA.png`
* `04_clusters_pays.png`

## 📊 Données utilisées
Les données sont issues du **World Happiness Report 2019** et incluent les indicateurs suivants :
* Score (Bonheur)
* PIB par habitant (`GDP.per.capita`)
* Soutien social (`Social.support`)
* Espérance de vie en bonne santé
* Liberté de faire des choix de vie
* Générosité
* Perception de la corruption

## 🧠 Résultats attendus
* Identification des variables les plus influentes dans la variation du bonheur.
* Visualisation des regroupements de pays sur la base des composantes principales.
* Segmentation des pays en **3 clusters distincts** selon leurs scores socio-économiques.

## 👨‍💻 Auteur
* Hafid Garhoum
* Étudiant à ENSA Berrechid
* LinkedIn *(à personnaliser)*

## 📜 Licence
Ce projet est open-source sous licence MIT. Tu es libre de l'utiliser, le modifier et le partager.

## 📌 Remarques
* Le script est commenté pour une meilleure compréhension pédagogique.
* Le code est compatible avec l'interface graphique RStudio.
* Bien veiller à positionner le fichier `2019.csv` dans le bon répertoire de travail (`setwd()`).