From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 10:33:05 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305140833.h4E8X5P00764@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Can you shed some light on this for me?

currspeed =
 (j-mddev->resync_mark_cnt)/2/((jiffies-mddev->resync_mark)/HZ +1) +1;

jiffies is divided by HZ here, which results in a quantity of dimension
time-squared!

I could understand it (better) if jiffies were multiplied by HZ.

Peter
