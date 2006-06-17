From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: mdadm 2.5.1 - A problem came up ...
Date: Fri, 16 Jun 2006 19:12:44 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0606161855270.17622@filesrv1.baby-dragons.com>
References: <17554.895.666628.776527@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17554.895.666628.776527@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Neil ,  If I add any disk partition to end of the below command as
 	man mdadm requests .  Ok ,  Now I get it ,  "partitions" or "none" are
 	required .  But still ...

 	<Quote>
 	mdadm --examine --brief --scan --config=partitions
 	mdadm -Ebsc partitions
 	Create  a list of devices by reading /proc/partitions, scan these for RAID superblocks, and printout a brief listing of all that was found.
 	<\Quote>

root@privateers:~# mdadm -Ebsc
mdadm: option requires an argument -- c
Usage: mdadm --help
   for help

 	Ok ,  But when I do a ...

root@privateers:~# mdadm -Ebsc --help
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=8d5cd2c7:42544200:d2bdaaad:ce1bab0c
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=e8a0caca:1e477715:f7f74d6b:88dd401c
ARRAY /dev/md3 level=raid1 num-devices=2 UUID=a87d5acf:17038a98:03577e48:76e31d5c
ARRAY /dev/md2 level=raid1 num-devices=2 UUID=8f4b56fa:840ad5eb:0c28a667:6a46f759

 	I was expecting a help readout not the command to actually function .
 		Hth ,  JimL
-- 
+----------------------------------------------------------------------+
| James   W.   Laferriere |   System    Techniques   | Give me VMS     |
| Network        Engineer | 3600 14th Ave SE #20-103 |  Give me Linux  |
| babydr@baby-dragons.com |  Olympia ,  WA.   98501  |   only  on  AXP |
+----------------------------------------------------------------------+
