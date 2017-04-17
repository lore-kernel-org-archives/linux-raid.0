From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Lost second disk during resync, can I recover?
Date: Mon, 17 Apr 2017 14:08:00 +0500
Message-ID: <20170417140800.0731c206@natsu>
References: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam B <adam.backer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 16 Apr 2017 17:30:26 -0700
Adam B <adam.backer@gmail.com> wrote:

> I've got a synology ds1812+
> Could have sworn I did raid 6, but md says raid5 (dont recall
> personalities pre-failure)
> Lost disk 2, was rebuilding and disk 6 crashed.
> 
> Booting from a fresh machine, and attempting to discover the arrays
> (md125 is the target)
> 
> root@ds:~# mdadm --assemble --scan
> mdadm: /dev/md/DiskStation:2 assembled from 6 drives - not enough to
> start the array.
> mdadm: /dev/md/1_1 has been started with 7 drives (out of 8).
> mdadm: /dev/md/0_1 has been started with 7 drives (out of 8).
> mdadm: /dev/md/DiskStation:2 exists - ignoring
> mdadm: /dev/md125 assembled from 6 drives - not enough to start the array.
> root@ds:~# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md126 : active raid1 sda1[0] sdh1[7] sdg1[6] sde1[4] sdd1[3] sdc1[2] sdb1[1]
>       2490176 blocks [8/7] [UUUUU_UU]
> 
> md127 : active raid1 sda2[0] sdb2[7] sdh2[6] sdg2[5] sde2[3] sdd2[2] sdc2[1]
>       2097088 blocks [8/7] [UUUU_UUU]
> 
> md2 : active raid5 sdf3[5]
>       20478809792 blocks super 1.2 level 5, 64k chunk, algorithm 2
> [8/1] [_____U__]

From a quick glance it's not clear what is sdf3, why it's got an array of its
own, and why later you don't try to do anything with it (didn't try re-add,
neither list in assemble, nor examine). Isn't it that one more drive you need
(even if partially bad) that would let you start the RAID5?

Also perhaps before being able to do anything with it you will need to stop
its "md2" array.

-- 
With respect,
Roman
