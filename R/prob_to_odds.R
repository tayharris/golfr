prob_to_odds <- function(probability) {
  ifelse(probability >= 0.5,
         -((probability / (1 - probability)) * 100),  # Favorite
         ((1 - probability) / probability) * 100)  # Underdog
}
