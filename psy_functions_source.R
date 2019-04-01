
# Improved functions. Still testing, though appear to work well

# Functions determine appropriate fit based on number of parameters supplied

psy_fun <- function(x_val, rsp, par, lapse = FALSE, invert = FALSE){
  
  # Input args: x_val: stimulus levels
  #             rsp: vector of participant's responses 
  #             par: initial parameters ex. c(1,1) or c(1,1,1)
  #                   !!! order is important !!! 
  #                 if two par: c(pse, slope)
  #                 if three par: c(pse, slope, height OR lapse)
  #  
  #             lapse: should functin fit lapse rate? TRUE or FALSE. Defaults to FALSE
  #             invert: should function be inverted (i.e. start at 1 on left and fall to 0 on right)
  #                 TRUE or FALSE. Defaults to FALSE
  #
  # If three parameters are supplied and lapse = FALSE, allows height of function to converge
  # at values other than one.
  
  
  # Output: sum of the squared differences between the observed effect (rsp) and 
  #         that predicted by the psychometric function with current parameter values 
  
  
  # This function is intended to be sent through optim() to perform minimization of
  # the output - that is, to determine which parameters minimize the error between
  # expected and observed values.
  
  
  # Default behavior, values nullify effect of lapse rate, inversion, and scaling
  inver_ctrla <- 0
  inver_ctrlb <- -1
  lapse_ctrl <- 0
  height_ctrl <- 1
  
  if(invert == TRUE){
    inver_ctrla <- 1
    inver_ctrlb <- 1
  }
  
  if(length(par) == 3 & lapse == FALSE) {height_ctrl <- par[3]}
  if(length(par) == 3 & lapse == TRUE) {lapse_ctrl <- par[3]}
  
  # psychometric function
  rhat <- (inver_ctrla - (inver_ctrlb * ((exp((x_val - par[1]) / par[2])) / 
                                           
                                           (1 + exp( (x_val - par[1]) / par[2]) )))) * 
    
    height_ctrl * (1 - 2 * lapse_ctrl) + lapse_ctrl 
  
  
  sum((rsp - rhat)^2) # value to be minimized
  
}


psy_plot <- function(x_val, par, lapse = FALSE, invert = FALSE) {
  
  # This function is intended to make plotting smooth psychometric functions easier
  # Input args: x_val: range of x values at which to plot (stimulus levels)
  #             par: parameters of function
  #                   !!! order is important !!! 
  #                 if two par: c(pse, slope)
  #                 if three par: c(pse, slope, height OR lapse)
  #             lapse: whether third parameter is height or lapse rate. TRUE or FALSE. Default = FALSE
  #             invert: is function inverted? (i.e. start at 1 on left and fall to 0 on right)
  #                 TRUE or FALSE. Defaults to FALSE
  #
  # Output: tibble with columns for x and y values of specified function.
  #         Can be easily used by plot() or ggplot(
  
  
  # Default behavior, values nullify effect of lapse rate, inversion, and scaling
  inver_ctrla <- 0
  inver_ctrlb <- -1
  lapse_ctrl <- 0
  height_ctrl <- 1
  
  if(invert == TRUE){
    inver_ctrla <- 1
    inver_ctrlb <- 1
  }
  
  if(length(par) == 3 & lapse == FALSE) {height_ctrl <- par[3]}
  if(length(par) == 3 & lapse == TRUE) {lapse_ctrl <- par[3]}
  
  # predicted value at given stimulus level & supplied parameters
  y_val <- (inver_ctrla - (inver_ctrlb * ((exp((x_val - par[1]) / par[2])) / 
                                            
                                            (1 + exp( (x_val - par[1]) / par[2]) )))) *
    
    height_ctrl * (1 - 2 * lapse_ctrl) + lapse_ctrl 
  
  return(tibble(x_val, y_val))  
  
}


find_thresh <- function(thresh, par){
  
  # !! NOT updated to accomodate inverted functions or functions with lapse rate !! 
  # Function for finding the x value at which a given function crosses an
  # arbitrary threshold (e.g. 10%). Rearranges psychometric function 
  # to solve for x_val.
  #
  # Input args: thresh: desired threshold 
  #             par: parameters of function
  #                   !!! order is important !!! 
  #                 if two par: c(pse, slope)
  #                 if three par: c(pse, slope, height OR lapse)
  #
  # Output: the x value at which the function crosses the given threshold 
  
  if(length(par) == 2){ par[3] <- 1 }
  
  thresh2 <- thresh * par[3]
  thresh_val <- log(thresh2 / (par[3] - thresh2)) * par[2] + par[1]
  
  return(thresh_val)
  
}

psy_funX <- function(x_val, rsp_bright, rsp_dim, par) {
  
  # Specifically designed for dim rod task. Fit functions to bright and dim rod time course
  # simultaneously while ensuring the "height" parameter is the same for each. We would not expect
  # larger RFI magnitude for bright vs dim rod, just change in time course
  
  rhat1 <- (exp((x_val - par[1]) / par[2])) / (1 + exp((x_val - par[1]) / par[2])) * par[5]
  rhat2 <- (exp((x_val - par[3]) / par[4])) / (1 + exp((x_val - par[3]) / par[4])) * par[5]
  
  sum((rsp_bright - rhat1)^2) + sum((rsp_dim - rhat2)^2)
  
  
}


psy_plotX <- function(x_val, pse1, pse2, slope1, slope2, height) {
  
  y_val1 <- (exp((x_val - pse1) / slope1)) / 
    (1 + exp((x_val - pse1) / slope1)) * height 
  
  y_val2 <- (exp((x_val - pse2) / slope2)) / 
    (1 + exp((x_val - pse2) / slope2)) * height 
  
  return(tibble(x_val, y_val1, y_val2))
  
  
}

