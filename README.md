# RFI
RFI prdlab UO

## File descriptions:

### RFI_percept.Rmd
Finds pse for each participant in each frame tilt x SOA condition then determines RFI at each SOA. Psychometric functions are fit to individual RFI time courses as well as to the group average time course. 

Generates plots: 
  1) Group average left vs right frame tilt time course
  2) Group average RFI time course (raw data and with curve fit)
  3) Individual staircases, psychometric function fits to raw data, individual RFI time courses

Additional code (line 548 & beyond) compares the pse as estimated by the staircase to pse estimated by fits to raw data as well as creates a plot with all participant time courses overlaid.

### RFI_timecourse_rawdata.csv 
Created with data agg loop in RFI_percept.Rmd (lines 144 - 170). This dataset contains unedited output from experiment builder (all participants concatenated). 

Column Descriptions:
- TRIAL_TYPE:     practice or real (ie experimental)
- trial_variant:  staircase label (L or R indicates approach direction)
- BLOCK_NUMBER:   current block number (block size changes as staircases begin to close)
- TRIAL_NUMBER:   current trial number
- TRIAL_ITERATION_VAL: iteration of current condition
- frame_tilt:     current frame tilt -15 (left) or 15 (right) degrees
- rod_tilt:       current rod tilt -20:20 degrees
- response:       0 (perceived left) or 1 (perceived right)
- step_size:      how much to adjust rod tilt for next iteration of condition (degrees)
- reversal:       whether current response was a reversal for condition (0 = FALSE, 1 = TRUE)
- reversal_num:   total number of reversals in current condition
- RT:             reaction time (response button - probe onset time)
- probe_del:      probe-frame SOA measured in retraces (negative values = probe first, then frame)
- sid:            subject ID
  
--------------------------------------------------------

## Task description

Participants judged the orientation of a briefly flashed rod (~8 ms) with respect to vertical in 2AFC task. Judgement occured in the presence of a large frame tilted 15 degrees left or right of vertical. The onset of the rod was offset from the onset of the frame such that the rod could apper before or after frame onset. There were a total of eight SOAs (-200, -133, -100, -67, -33, 0, 33, 200). After its onset, the tilted frame remained visible until the participant made their response. The frame then turned upright to prevent carry over effects between trials.

Central fixation was required from trial onset to probe offset. Aborted trials are not recorded in output file from experiment builder.

The PSE in each frame tilt x SOA condition was estimated using a staircasing procedure. Two staircases were used for each condition: one starting with rods tilted 20 degrees to the left, the other starting with rods 20 degrees to the right. Staircases remained open until 12 reversals occured. PSE estimated using the average rod tilt at last six reversals. In total, there were 32 conditions (2 frame tilts x 8 SOAs x 2 staircase approaches)



