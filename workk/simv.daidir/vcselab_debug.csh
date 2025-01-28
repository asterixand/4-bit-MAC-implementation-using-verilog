#!/bin/csh -f

cd /net/marysrock.ece.Virginia.EDU/maryisan/users/hwu6hc/synopsys/workk

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/app6/synopsys/vcs/S-2021.09-SP1-1/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

