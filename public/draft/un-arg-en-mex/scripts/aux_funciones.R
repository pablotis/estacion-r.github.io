

#                          Armo theme                         ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
theme_mex <- function(){ 
  #font <- "Georgia"   #assign font family up front
  
  theme_minimal() %+replace% 
    
    theme(
      
      # Grilla
      line = element_blank(),
      # panel.background = element_rect(fill = "transparent"),
      # plot.background = element_rect(fill = "transparent", color = "transparent"),
      # panel.border = element_rect(color = "transparent"),
      strip.background = element_rect(color = "gray20"),
      axis.text = element_blank(),
      plot.margin = margin(25, 25, 10, 25),
      panel.grid.major = element_blank(),    #strip major gridlines
      panel.grid.minor = element_blank(),    #strip minor gridlines
      axis.ticks = element_blank(),          #strip axis ticks
      
      # Texto
      plot.title.position = 'plot',
      plot.title = element_text( 
        #family = font,            
        size = 20,                
        face = 'bold',            
        hjust = 0,                # Alineamiento a la izquierda
        vjust = 2),               # Elevo un toque
      
      plot.subtitle = element_text(
        #family = font,            
        size = 14),                
      
      plot.caption.position = 'plot',
      plot.caption = element_text(
        #family = font,            
        size = 9,                 
        hjust = 1),               
      
      axis.title = element_text(  
        #family = font,            
        size = 10),    
      
      # Leyenda
      
      legend.position = 'plot'
      
      # axis.text = element_text(   
      #   #family = font,            
      #   size = 9),                
      # 
      # axis.text.x = element_text( 
      #   margin=margin(5, b = 10))
      
    )
}



#                  Algunos seteos opcionales                  ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Leyenda
# guides(color = guide_colorbar(title.position = 'top', title.hjust = .5,
#                               barwidth = unit(20, 'lines'), barheight = unit(.5, 'lines')))


### Ejes
# coord_cartesian(expand = FALSE, clip = 'off')


### Bandera Mexicana
png <- magick::image_read(here::here("content", "posts", "2022-03-12-un-arg-en-mex", "img", "bandera_mex2.png"))
img <- grid::rasterGrob(png, interpolate = TRUE)
# annotation_custom(img, ymin = 22, ymax = 31, xmin = 55, xmax = 65.5)




#                        Colores México                       ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mex_colores <- function(...) {
  
  # Fuente - Manual estético del gobierno mexicano: file:///C:/Users/pablo/Downloads/MANUAL_DE_IDENTIDAD_GRAFICA_2018-2024.pdf
  ### Lista de colores de la dnmye
  colores <- c(
    `verde`  = "#235B4E",
    `rojo`   = "#9F2241",
    `marron` = "#BC955C",
    `gris`   = "#98989A")
  
  cols <- c(...)
  
  return(unname(colores[cols]))
  
}



#                      Paletas de colores                     ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mex_paletas <- function(palette = "tricolor", reverse = FALSE, ...) {
  
  ### Paleta de colores
  paletas <- list(
    
    `tricolor`  = c(mex_colores("verde"), mex_colores("marron"), mex_colores("rojo")),
    `cuatricolor` = c(mex_colores("verde"), mex_colores("marron"), mex_colores("rojo"), mex_colores("gris")))
  
  pal <- paletas[[palette]]
  
  if (reverse) pal <- rev(pal)
  
  grDevices::colorRampPalette(pal, ...)
}


scale_fill_mex <- function(palette = "cuatricolor", discrete = TRUE, reverse = FALSE, ...) {
  pal <- mex_paletas(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("fill", paste0("mex_paletas_", palette), palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}


#                    Tabulados univariados                    ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

tabulado_x1 <- function(base, x, formato = FALSE) {
  
  if (formato == FALSE){
    
  tabla <- base %>% 
    eph::calculate_tabulates(x = x, 
                             weights = "fac_viv") %>% 
    dplyr::bind_cols(b_total %>% 
                       eph::calculate_tabulates(x, 
                                                weights = "fac_viv", 
                                                add.percentage = "col") %>% 
                       dplyr::select(Porcentaje = Freq)) %>% 
    mutate(Porcentaje = as.numeric(stringr::str_remove(Porcentaje, "%")),
           Freq = as.numeric(Freq))
  
  return(tabla)
  }
  
  if(formato == TRUE){
    
    tabla <- base %>% 
      eph::calculate_tabulates(x = x, 
                               weights = "fac_viv") %>% 
      dplyr::bind_cols(b_total %>% 
                         eph::calculate_tabulates(x, 
                                                  weights = "fac_viv", 
                                                  add.percentage = "col") %>% 
                         dplyr::select(Porcentaje = Freq)) %>% 
      dplyr::mutate(
        Porcentaje = paste0(format(as.numeric(Porcentaje), decimal.mark = ","), "%"),
        Freq = format(Freq, big.mark = ".", decimal.mark = ","))
    
    return(tabla)

  }
}




