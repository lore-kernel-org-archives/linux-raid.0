From: Harald Koenig <koenig@tat.physik.uni-tuebingen.de>
Subject: [koenig@tat.physik.uni-tuebingen.de: [suse-beta-e] RFC: time_adj for HZ==250 in kernel/timer.c ?]
Date: Fri, 2 Sep 2005 14:23:11 +0200
Message-ID: <20050902122311.GA26608@turtle.tat.physik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mingo@elte.hu, mingo@redhat.com
Cc: linux-raid@vger.kernel.org, Harald Koenig <koenig@tat.physik.uni-tuebingen.de>, mantel@suse.de
List-Id: linux-raid.ids

Hi Ingo & linux-kernel,

as I'm not subscribed to linix-kernel list, please send answers as with CC: PM.  thanks!


playing with the openSUSE 10.0 beta-test I slipped over problems with procinfo etc.
so I noticed that at least suse/novell again changed the scheduler frequency HZ
from 1000 to 250.  which led me to the following question,  for which I got no
commets from SUSE so far, and since it's not a suse-only issue anyway... 
 

the linux kernel for suse 10.0 will run with HZ==250 by default (9.x used HZ==1000).

for HZ==100 and HZ==1000 there is special code in kernel/timer.c to 
adjust the value of time_adj  because HZ isn't a power of two and
clock stuff uses some binary shift operations instead of divides
(and 100!=128 or 1000!=1024).

what about having a similar special case for the new HZ==250 too ??
using 250 instead of 256 (SHIFT_HZ==8), which is an error of 2.4 %,
identical to 1000 vs. 1024.

any feelings or comments about the following patch ?

-------------------------------------------------------------------------------
--- kernel/timer.c~     2005-08-22 22:50:27.000000000 +0200
+++ kernel/timer.c      2005-08-31 15:12:57.801644750 +0200
@@ -752,7 +752,7 @@
     else
        time_adj += (time_adj >> 2) + (time_adj >> 5);
 #endif
-#if HZ == 1000
+#if HZ == 1000 || HZ == 250
     /* Compensate for (HZ==1000) != (1 << SHIFT_HZ).
      * Add 1.5625% and 0.78125% to get 1023.4375; => only 0.05% error (p. 14)
      */
-------------------------------------------------------------------------------


or maybe (just in case...:) even

#if HZ == 1000 || HZ == 500 || HZ == 250



comments ?

Harald
-- 
"I hope to die                                      ___       _____
before I *have* to use Microsoft Word.",           0--,|    /OOOOOOO\
Donald E. Knuth, 02-Oct-2001 in Tuebingen.        <_/  /  /OOOOOOOOOOO\
                                                    \  \/OOOOOOOOOOOOOOO\
                                                      \ OOOOOOOOOOOOOOOOO|//
Harald Koenig,                                         \/\/\/\/\/\/\/\/\/
Inst.f.Theoret.Astrophysik                              //  /     \\  \
koenig@tat.physik.uni-tuebingen.de                     ^^^^^       ^^^^^

-- 
To unsubscribe, e-mail: suse-beta-e-unsubscribe@suse.com
For additional commands, e-mail: suse-beta-e-help@suse.com

----- End forwarded message -----


Harald
-- 
"I hope to die                                      ___       _____
before I *have* to use Microsoft Word.",           0--,|    /OOOOOOO\
Donald E. Knuth, 02-Oct-2001 in Tuebingen.        <_/  /  /OOOOOOOOOOO\
                                                    \  \/OOOOOOOOOOOOOOO\
                                                      \ OOOOOOOOOOOOOOOOO|//
Harald Koenig,                                         \/\/\/\/\/\/\/\/\/
Inst.f.Theoret.Astrophysik                              //  /     \\  \
koenig@tat.physik.uni-tuebingen.de                     ^^^^^       ^^^^^
