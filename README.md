readability
============


[![Project Status: Wip - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](http://www.repostatus.org/badges/0.1.0/wip.svg)](http://www.repostatus.org/#wip)
[![Build
Status](https://travis-ci.org/trinker/readability.svg?branch=master)](https://travis-ci.org/trinker/readability)
[![Coverage
Status](https://coveralls.io/repos/trinker/readability/badge.svg?branch=master)](https://coveralls.io/r/trinker/readability?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/readability_logo/r_readability.png" width="200" alt="readability Logo">

**readability** utilizes the
[**syllable**](https://github.com/trinker/syllable) package for fast
calculation of readability scores by grouping variables.


Table of Contents
============

-   [Installation](#installation)
-   [Contact](#contact)
-   [Examples](#examples)

Installation
============


To download the development version of **readability**:

Download the [zip
ball](https://github.com/trinker/readability/zipball/master) or [tar
ball](https://github.com/trinker/readability/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/syllable", "trinker/readability")

Contact
=======

You are welcome to: 
* submit suggestions and bug-reports at: <https://github.com/trinker/readability/issues> 
* send a pull request on: <https://github.com/trinker/readability/> 
* compose a friendly e-mail to: <tyler.rinker@gmail.com>


Examples
========

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(syllable, readability)

    (x <- with(presidential_debates_2012, readability(dialogue, list(person, time))))

    ##        person   time Flesch_Kincaid Gunning_Fog_Index Coleman_Liau
    ##  1:  QUESTION time 2       8.607578         12.485232    10.056261
    ##  2:     OBAMA time 1       9.059429         12.243625     8.871675
    ##  3:     OBAMA time 3       8.466015         11.974787     8.756874
    ##  4:    ROMNEY time 1       6.780839         10.155284     8.064754
    ##  5:     OBAMA time 2       6.816751         10.232397     7.770485
    ##  6:    ROMNEY time 3       6.678784         10.066703     7.541289
    ##  7:    ROMNEY time 2       6.133848          9.342517     7.361826
    ##  8: SCHIEFFER time 3       5.143031          8.664204     6.842990
    ##  9:    LEHRER time 1       4.296108          8.275411     5.860235
    ## 10:   CROWLEY time 2       4.340517          7.570080     5.558565
    ##          SMOG Automated_Readability_Index Average_Grade_Level
    ##  1: 12.025224                    8.195665           10.273992
    ##  2: 11.430748                    9.564840           10.234064
    ##  3: 11.521248                    8.508314            9.845448
    ##  4: 10.295072                    6.626319            8.384454
    ##  5: 10.312118                    6.584770            8.343304
    ##  6: 10.229507                    6.187829            8.140822
    ##  7:  9.731498                    5.613571            7.636652
    ##  8:  9.316118                    4.322151            6.857699
    ##  9:  8.971698                    3.013297            6.083350
    ## 10:  8.521246                    3.085136            5.815109

    plot(x)

![](inst/figure/unnamed-chunk-4-1.png)