From: Florian Lampel <florian.lampel@gmail.com>
Subject: RAID6 dead on the water after Controller failure
Date: Fri, 14 Feb 2014 17:19:35 +0100
Message-ID: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

The title says it all: 2 days before my RAID6 lost a HDD (sdh). Not  a problem, I thought, just let it reassemble and be done with it.

Unfortunately, my Mainboard-Controller didn't seem to like that, and after about 2 hours into the rebuilding process it showed me that the array was missing 5 drives ( 4 from the MB-Controller and the one that went south before).
Being a Admin for quite a while, I did not panic and have not issued a single command that writes to the RAID in any form as of yet.

Having read the wiki page about broken RAID arrays reading some messages on the list it became obvious that I should check with you guys before I do anything. The Server is still running, but I intend to restart it after unplugging an SATA cable that I assume to be faulty.

Here are the relevant logs and outputs of mdadm as requested on the Wiki:

h__p://pastebin.com/1xweaLYG

cat /proc/mdstat:
root@Lserve:~# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10] 
md0 : active raid6 sdh1[12](S) sdc1[10](F) sdb1[9](F) sda1[8](F) sdd1[11](F) sdf1[5] sdk1[1] sdl1[2] sdg1[6] sde1[4] sdm1[3] sdj1[0]
      19535129600 blocks super 1.0 level 6, 512k chunk, algorithm 2 [12/7] [UUUUUUU_____]
      
unused devices: <none>

sda, sdb, sdc and sdd can't be reached anymore by any means. I believe a restart might fix this, but I am not sure.

2) I assume that I should do the following, in this order: 

2.1) restart the machine and check all the cables etc.
---> and hope that /dev/sda, sdb, sdc and sdd will talk to me again.

2.2) mdadm --assemble --scan 
---> and hope for the best. I don't think it will work.

2.3 madm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 (since the Event count is the same) /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1
--> I don't believe this one will work, too. When using --force, is the sequence of the HDDs in the command important?

2.4) mdadm --create --assume-clean --chunk=512 --metadata=1.0 --level 6 --raid-devices=12 --size=1953512960 /dev/md0 /dev/sdj1 /dev/sdk1 /dev/sdl1 etc. (using the sequence numbers of the /proc/mdstat pasted above)

--> That should do it, right?

Thanks in advance,
Florian