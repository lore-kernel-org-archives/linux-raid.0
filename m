From: maarten van den Berg <maarten@vbvb.nl>
Subject: new problem has developed
Date: Sun, 26 Oct 2003 21:08:50 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310262108.50632.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi list,

Last week I asked about restoring a raid5 array with multiple failed disks. 
Thanks for your help, I've got it back online in degraded mode and was able 
to burn 10 DVD+RWs as a backup measure.  Now I have a new problem though.

I added a spare new disk to the degraded array after making said backups and 
it started resyncing. I went to sleep, only to find out next morning that the 
resync was only at 5.3% and speed was 5K/sec (!).  The system was still 
responsive, no runaway processes and no sign of any hardware trouble in 
/var/log/messages.  I killed the machine and retried... with the same result: 
at exactly 5.3% the speed starts dropping until it is near zero.

For various reasons I decided to decommission the old hardware (AMD K6) and I 
built a newer (and 100% known-good) board in it earlier today. That makes a 
BIG difference in initial speed, I now get 14000K/sec instead of the dead 
slow AMD K6 did. However, at 5.2% the speed drops significantly. We're now 
back at 5.3% and speed has dropped from 13000K to 170K and continues to drop.

I investigated already on the old machine with several tools, of course mdadm, 
but also iostat and keeping an eye on /var/log/messages.  All seems proper.
Also, immediately after "rescueing" the array from the miltiple disk failure I 
ran a long reiserfsck --check on the volume which found no problems at all.

I'm now at a loss...  Does anyone know what to monitor or check first ??

I'm unsure if this could be due to a disk hardware fault but then it would 
surely show up in syslog, right ? Could disk corruption be the culprit ? My 
guess would be "no", not only the reiserfs on top of the md0 tests fine, but 
these are on different layers anyhow, correct ?

One last remark; once this state occurs (near the 5.3% mark) any command that 
tries to query the array hangs indefinitely. (umount, mount, mdadm, even df).
Those commands are unkillable, what also entails that there is no way to 
reboot the machine except by resetswitch (shutdown hangs forever).
Apart from those commands the machine is still totally responsive (on another 
terminal).  Needless to say this bugs me enormously...  :-(

Some info:
The machine has a boot disk which provides "/" and a full linux system. Apart 
from that it has seven (7) 80GB disks connected to 2 promise adapters(100TX2)
Those disks should be a raid5 array with one spare (but they are obviously 
kinda inbetween states right now).  The kernel was 2.4.10 and is now 2.4.18.

If anyone can help, that would be greatly appreciated...
Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
