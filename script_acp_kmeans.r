# ────────────────────────────────────────────────
# ANALYSE ACP DU WORLD HAPPINESS REPORT 2019 AVEC FACTOSHINY
# ────────────────────────────────────────────────

#setwd("C:/Users/ton_nom_utilisateur/chemin/vers/dossier")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Étape 1 : Installer et charger les packages nécessaires
packages <- c("FactoMineR", "factoextra", "tidyverse", "cluster", "readr", "Factoshiny")
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}
lapply(packages, install_if_missing)

# Étape 2 : Importer les données
# Assurez-vous que le fichier CSV est dans votre répertoire de travail
# ou modifier le chemin ci-dessous
data <- read_csv("2019.csv")

# Étape 3 : Nettoyage et sélection des variables utiles
colnames(data) <- make.names(colnames(data))  # standardiser noms
data_acp <- data %>%
  select(Score,
         GDP.per.capita,
         Social.support,
         Healthy.life.expectancy,
         Freedom.to.make.life.choices,
         Generosity,
         Perceptions.of.corruption)

# Étape 4 : Supprimer les valeurs manquantes et standardiser les données
data_acp <- na.omit(data_acp)
data_scaled <- scale(data_acp)

# Étape 5 : Option 1 - Interface FactoShiny pour ACP
# Cette fonction ouvre une interface web interactive pour explorer l'ACP
PCAshiny(data_scaled)

# Les fonctions suivantes sont disponibles pour une exécution en script après analyse via FactoShiny
# Pour exécuter le script sans interface, commentez la ligne PCAshiny et décommentez le code ci-dessous

# Étape 5 : Option 2 - Exécution de l'ACP en script (sans interface)
# res_pca <- PCA(data_scaled, graph = FALSE)

# Étape 6 : Visualisations de l'ACP
# Variance expliquée (scree plot)
# fviz_screeplot(res_pca, addlabels = TRUE, ylim = c(0, 60),
#                main = "Scree Plot - Variance expliquée")

# Cercle des corrélations
# fviz_pca_var(res_pca,
#              col.var = "cos2",
#              gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
#              repel = TRUE,
#              title = "Cercle des corrélations")

# Projection des pays (individus) sur le plan factoriel
# fviz_pca_ind(res_pca,
#              geom.ind = "point",
#              col.ind = "cos2",
#              gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
#              repel = TRUE,
#              title = "Projection des pays sur PC1-PC2")

# Étape 7 : Clustering K-means sur les deux premières composantes
# pca_scores <- res_pca$ind$coord[, 1:2]
# set.seed(123)  # reproductibilité
# km <- kmeans(pca_scores, centers = 3, nstart = 25)

# Ajouter les clusters aux données
# pca_clusters <- as.data.frame(pca_scores)
# pca_clusters$cluster <- factor(km$cluster)
# pca_clusters$Country <- data$Country.or.region

# Visualiser les clusters
# fviz_cluster(km,
#              data = pca_scores,
#              ellipse.type = "euclid",
#              palette = "jco",
#              ggtheme = theme_minimal(),
#              main = "Clustering des pays selon l'ACP")

# Étape 8 : Résumé des moyennes des variables par cluster
# data_with_cluster <- cbind(data_acp, cluster = km$cluster)
# print("Résumé des moyennes par cluster :")
# print(aggregate(. ~ cluster, data = data_with_cluster, mean))

# ──── Script pour récupérer le résultat de l'ACP réalisée avec FactoShiny ────

# Fonction pour réaliser l'ACP et le clustering après avoir utilisé FactoShiny
# Pour utiliser cette fonction, exécutez d'abord PCAshiny
# puis après avoir exploré les données, fermez l'interface et exécutez cette fonction
analyser_resultats_acp <- function(donnees = data_scaled, nb_clusters = 3) {
  # Réaliser l'ACP
  res_pca <- PCA(donnees, graph = FALSE)
  
  # Visualisations principales
  # Scree plot
  p1 <- fviz_screeplot(res_pca, addlabels = TRUE, ylim = c(0, 60),
                 main = "Scree Plot - Variance expliquée")
  print(p1)
  
  # Cercle des corrélations
  p2 <- fviz_pca_var(res_pca,
               col.var = "cos2",
               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
               repel = TRUE,
               title = "Cercle des corrélations")
  print(p2)
  
  # Projection des individus
  p3 <- fviz_pca_ind(res_pca,
               geom.ind = "point",
               col.ind = "cos2",
               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
               repel = TRUE,
               title = "Projection des pays sur PC1-PC2")
  print(p3)
  
  # Clustering K-means
  pca_scores <- res_pca$ind$coord[, 1:2]
  set.seed(123)
  km <- kmeans(pca_scores, centers = nb_clusters, nstart = 25)
  
  # Visualisation des clusters
  p4 <- fviz_cluster(km,
                data = pca_scores,
                ellipse.type = "euclid",
                palette = "jco",
                ggtheme = theme_minimal(),
                main = "Clustering des pays selon l'ACP")
  print(p4)
  
  # Résumé des clusters
  data_with_cluster <- cbind(data_acp, cluster = km$cluster)
  print("Résumé des moyennes par cluster :")
  resultat_clusters <- aggregate(. ~ cluster, data = data_with_cluster, mean)
  print(resultat_clusters)
  
  # Sauvegarder les graphiques
  ggsave("01_screeplot_variance.png", plot = p1, width = 8, height = 6)
  ggsave("02_cercle_correlations.png", plot = p2, width = 8, height = 6)
  ggsave("03_projection_pays_PCA.png", plot = p3, width = 8, height = 6)
  ggsave("04_clusters_pays.png", plot = p4, width = 8, height = 6)
  
  # Retourner les résultats pour une utilisation ultérieure
  return(list(pca = res_pca, kmeans = km, clusters = resultat_clusters))
}

# Pour utiliser la fonction après avoir exploré avec FactoShiny:
# resultats <- analyser_resultats_acp(data_scaled, 3)

# ──────────────── FIN DU SCRIPT ────────────────