From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: raid1 does not seem faster
Date: Sun, 1 Apr 2007 14:19:41 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,


normally, I'd think that combining drives into a raid1 array would give 
me at least a little improvement in read speed. In my setup however, 
this does not seem to be the case.

14:16 opteron:/var/log # hdparm -t /dev/sda
 Timing buffered disk reads:  170 MB in  3.01 seconds =  56.52 MB/sec
14:17 opteron:/var/log # hdparm -t /dev/md3
 Timing buffered disk reads:  170 MB in  3.01 seconds =  56.45 MB/sec
(and dd_rescue shows the same numbers)

The raid array was created using
# mdadm -C /dev/md3 -b internal -e 1.0 -l 1 -n 2 /dev/sd[ab]3


Jan
-- 
