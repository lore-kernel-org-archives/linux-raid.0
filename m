From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: promise sx6000 success / raid options
Date: Sat, 26 Oct 2002 14:35:58 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210261429080.7303-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I had initial problems with a Promise SX6000 controller with the i2o block
driver and I also tried their source pti_st.o code but never got it to
compile. I emailed promise and got a response back quite quickly which
provided me with a new version of the source code version, plus beta
drivers they themselves compiled for redhat 7.3 and redhat 8.0 kernels.

I have today started using the redhat 8.0 kernel driver and it seems to
work very well. Write performance is approx 15 meg/s to a 5 times 120gig
drive stripe (seems a bit on the low side if you ask me but that's ok
anyway, perhaps ext3 is slowing things down). I recommend anyone who have 
problems with their SX6000 to do the same.

I made the filesystem with just mke2fs -j and no raid options, is the
"stride" options anything I should use? Does it provide better
performance? (I tried finding some information on this, but the mke2fs man
page is so spread that all the search engines give me are copies of the
man page).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

