From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: RAID Performance - 5x SSD RAID5
Date: Tue, 26 Nov 2013 17:19:33 +1100
Message-ID: <52943D75.50003@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

Back in February/March of this year, I started a very long thread 
(http://marc.info/?l=linux-raid&m=136021974127295&w=2). During that 
thread, I got lots of very helpful advice, and made some significant 
architecture changes to the systems, as well as purchasing lots of 
additional hardware.

Unfortunately, I don't have a complete summary of every change that has 
happened, and I still don't have a perfectly working system, however, I 
thought I might provide some information in case it is helpful (or 
interesting) to anyone.

My current hardware:
2 x Storage servers each with
       2 x Quad port 1Gbps ethernet cards (Intel)
       2 x Onboard 1Gbps ethernet cards
       5 x 480GB SSD (Intel 520s)

The storage servers have one ethernet crossover to each other, one to 
the "user LAN" and the other 8 in a Linux bond using balance-alb and mtu 
9000
The 5 x 480GB SSD is configured as a single RAID5 array:
md1 : active raid5 sdb1[7] sdd1[9] sde1[5] sdc1[8] sda1[6]
       1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] 
[UUUUU]
       bitmap: 4/4 pages [16KB], 65536KB chunk

That is used by DRBD to join the two servers together, using the 
crossover cable to keep the second server in-sync
I then use LVM2 on top to split it up into "drives" for each server
Finally, iSCSI (ietd) is used to server these LV's to the network (over 
the 8 x 1Gbps ethernet).

Raw throughput from fio at the time was seeing performance of approx 
2.5GB/s read and 1.6GB/s write performance, though at the time the 
secondary server was disconnected from DRBD and using 4 x 2TB drives in 
RAID10.

I then have 8 x Xen hosts, each with a dual port 1Gbps ethernet card 
(Intel) plus an onboard ethernet.
These servers have the onboard ethernet connected to a switch for the 
"User LAN", and the other two are configured with individual IP's, both 
on the same subnet, and also on the same subnet as the bond for the 
storage servers.

So, this has been working .... for some definition of that, for a number 
of months, but I shifted my attention away from the RAID layer and back 
to the network layer when I finally noticed periods of complete packet 
loss to the various windows VM's running on the Xen machines. Finally, 
at the beginning of this month, I (not really me, but the auther of the 
GPLPV drivers for windows) found the necesary bug and released a fix. 
Since then, I've had 0 packet loss (on the local LAN) to the various VM's.

I want to repeat that, for anyone still running Windows XP/2003 in Xen, 
please make sure you get the latest GPLPV to solve networking issues 
(they only happen under certain types of load, which my bunch of users 
seem to be good at generating).

In addition, (after a one hour outage on Sunday afternoon) found a bug 
in the switch firmware which causes it to reboot randomly (well, once in 
8 months isn't too bad, but I expect 100% perfection :). So tonight I'll 
be upgrading that.

However, I've still got a performance issue, and it still looks like a 
disk performance issue, but I'll come back to that hopefully later 
tonight after I do the firmware upgrade on the switch, then install the 
absolute latest GPLPV drivers, and then start performance testing all 
over again... I'll cross my fingers and hope I don't break everything 
too badly. If I'm lucky, I'll be able to pinpoint the cause now that so 
many of my other problems have been fixed.

Regards,
Adam
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
