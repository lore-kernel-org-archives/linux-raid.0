From: Brett King <king.br@gmail.com>
Subject: Re: Update: mdadm 3.1.1 / 2.6.32 - trouble reducing active devices in
	13TB RAID6
Date: Tue, 6 Apr 2010 09:10:32 +1000
Message-ID: <m2i8cf253381004051610s9079ef8du63711ba580f0fed@mail.gmail.com>
References: <n2j8cf253381004040015ga48536b2s204f3b622367b06a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n2j8cf253381004040015ga48536b2s204f3b622367b06a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Another update: things didn't quite go as planned .. the reshape
didn't quite finish - it got to 99.9% and stopped there:

md0 : active raid6 sdq[0] sdc[12] sdb[11] sda[10] sdo[9] sdn[8] sdm[7]
sdl[6] sdv[5] sdu[4] sdd[3] sds[2] sdr[1]
      9767624960 blocks super 0.91 level 6, 64k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]
      [===================>.]  reshape = 99.9% (976761856/976762496)
finish=0.0min speed=4K/sec

I left it overnight hence the low speed average. A stop and restart
using the backup-file also didn't end well:

array:/tmp/mdadm-3.1.2 # ./mdadm -S /dev/md0
mdadm: stopped /dev/md0
array:/tmp/mdadm-3.1.2 # ./mdadm -A /dev/md0 --backup-file /export/md0-backup
mdadm: Failed to restore critical section for reshape, sorry.

(the backup-file isn't on the array being reshaped).

Looks like the code's almost there but not quite .. there are 640
remaining blocks.

array:/tmp/mdadm-3.1.2 # uname -a
Linux array 2.6.34-rc3-7-default #1 SMP 2010-03-31 17:12:53 +0200
x86_64 x86_64 x86_64 GNU/Linux
array:/tmp/mdadm-3.1.2 # ./mdadm -V
mdadm - v3.1.2 - 10th March 2010
array:/tmp/mdadm-3.1.2 #

Any ideas ?

Cheers,
Brett.
