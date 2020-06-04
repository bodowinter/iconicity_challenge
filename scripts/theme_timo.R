# Timo Roettger designed this theme for our #BhamStats18 Summerschool

## store our Birmingham theme
theme_timo <- 
  theme_classic() + 
  theme(
      # position and font style of the legend
      legend.position = "right",
      legend.title = element_text(size = 18, face = "bold"),
      legend.text = element_text(size = 16),
      legend.background = element_rect(fill = "transparent"),
      # style of the strip background when we use the facet command
      strip.background = element_blank(),
      strip.text = element_text(size = 18, face = "bold"),
      # distance between facet panels
      panel.spacing = unit(2, "lines"),
      # font style of your axes and titles
      axis.text = element_text(size = 16),
      axis.title = element_text(size = 18, face = "bold"),
      plot.title = element_text(size = 18, face = "bold"),
      # margins (white space) around your plot
      plot.margin = unit(c(1,1,1,1),"cm"),
      # make the plot background transparent so if you insert it into your slides it merges with your slide deck
      plot.background = element_rect(fill = "transparent", colour = NA),
      panel.background = element_rect(fill = "transparent"))  
