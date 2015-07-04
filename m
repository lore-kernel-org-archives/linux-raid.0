From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re[4]: Issue removing failed drive and re adding on raid 6
Date: Sat, 4 Jul 2015 09:25:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507040924130.11810@uplift.swm.pp.se>
References: <em077982e3-5c16-48ac-a45a-e87d2249b80c@littlez>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <em077982e3-5c16-48ac-a45a-e87d2249b80c@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 4 Jul 2015, Justin Stephenson wrote:

> [root@BigBlue Desktop]# mdadm --assemble --scan --force
> [root@BigBlue Desktop]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sdf1[8](S) sde1[2] sdg1[4] sdd1[1] sdh1[7] sdc1[0] sdb1[6]
>      20510934584 blocks super 1.2
> [root@BigBlue Desktop]# mdadm --assemble --force /dev/md0 
> /dev/sd{b,c,d,e,g,h}1
> mdadm: /dev/sdb1 is busy - skipping
> mdadm: /dev/sdc1 is busy - skipping
> mdadm: /dev/sdd1 is busy - skipping
> mdadm: /dev/sde1 is busy - skipping
> mdadm: /dev/sdg1 is busy - skipping
> mdadm: /dev/sdh1 is busy - skipping

You can't do assemble on an already running array, so this did nothing.

> [root@BigBlue Desktop]# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> [root@BigBlue Desktop]# mdadm --assemble --force /dev/md0 
> /dev/sd{b,c,d,e,g,h}1mdadm: Marking array /dev/md0 as 'clean'
> mdadm: /dev/md0 has been started with 6 drives (out of 7).

So this did the trick because the --assemble --force above failed because 
you tried to do it on an already assembled array.

> [root@BigBlue Desktop]# mdadm --manage /dev/md0 --add /dev/sdf1
> mdadm: added /dev/sdf1
> [root@BigBlue Desktop]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdf1[8] sdc1[0] sdb1[6] sdh1[7] sdg1[4] sde1[2] sdd1[1]
>      14650666880 blocks super 1.2 level 6, 128k chunk, algorithm 2 [7/6] 
> [UUU_UUU]
>      [>....................]  recovery =  0.0% (2017024/2930133376) 
> finish=725.8min speed=67234K/sec

Great!

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
