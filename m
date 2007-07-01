From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: RAID5 not being reassembled correctly after device swap
Date: Sun, 1 Jul 2007 23:21:48 +0200
Message-ID: <200707012321.48346.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello RAID-Experts,

I have three RAID5 consisting of different partitions on 3 disks (Debian 
stable) running the root-filesystem on a md (/boot is a separate non-raid 
partition) which is running rather nicely. For convenience I plugged all 
drives into the first ide controller making them hda, hdb and hdc. So far, so 
good. The partitions are flagged "fd", i.e. Linux raid autodetect.

As I have another builtin-ide-controller onboard, I'd like to distribute the 
disks for performance reasons, moving hdb to hde and hdc to hdg. The arrays 
would then consist of drives hda, hde and hdg.

This should not be a problem, as the arrays should assemble themselves using 
the superblocks on the partitions, shouldn't it? 

However, when I switch one drive (hdc), the array starts degraded with two 
drives present because it is still looking for hdc, which of course now is 
hdg. This shouldn't be happening. 

Well, then I re-added hdg to the degraded array, which went well and the array 
rebuilded itself. I now had healthy arrays consisting of hda, hdb and hdg. 
But after a reboot the array was degraded again and the system wanted its hdc 
drive.

And yes, I edited /boot/grub/device.map and changed hdc to hdg, so that can't 
be the reason.

I seem to be missing something here, but what is it?
-- 
YT,
Michael
