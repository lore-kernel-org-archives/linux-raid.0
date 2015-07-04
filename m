From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[4]: Issue removing failed drive and re adding on raid 6
Date: Sat, 04 Jul 2015 07:12:13 +0000
Message-ID: <em077982e3-5c16-48ac-a45a-e87d2249b80c@littlez>
References: <alpine.DEB.2.02.1507040854290.11810@uplift.swm.pp.se>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507040854290.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



>I found this:
>
>http://www.devinzuczek.com/anything-at-all/raid5-cannot-start-dirty-degraded-array-for-mdn/
>
>It indicates that you should be able to do "mdadm --manage /dev/md0 
>--run". I have never ended up in this situation so I don't know if 
>it'll work.
>
>>***** Parent of /run/mdadm does not exist.  Maybe set different 
>>RUN_DIR=
>>*****  e.g. make RUN_DIR=/dev/.mdadm
>>***** or set CHECK_RUN_DIR=0
>>make: *** [check_rundir] Error 1
>>[justin@BigBlue mdad]$
>
>You don't have to do "make install", you can just do "make" and find 
>the resulting mdadm binary and use ./mdadm to run it from current dir. 
>You probably only need it to actually get the array up and running 
>again, then your system mdadm will be fine. Btw, post "mdadm --version" 
>and "uname -a" so we know what kernel and mdadm version you're running.
>
>-- Mikael Abrahamsson email: swmike@swm.pp.se

Thanks Mikael.

I am running:

[justin@BigBlue Desktop]$ mdadm --version
mdadm - v3.2.6 - 25th October 2012
[justin@BigBlue Desktop]$ uname -a
Linux BigBlue 2.6.32-431.3.1.el6.x86_64 #1 SMP Fri Jan 3 21:39:27 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux
A bit unscientifically, I tried assembling again and nothing happened. 
Then I tried stopping the array again, and then forcing an assemble. 
This worked. I then added the new drive and the array is reporting that 
it is rebuilding! Below is the command output. I will report back in a 
day or so as it is a 15TB array - it will take a day to rebuild.


[root@BigBlue Desktop]# mdadm --assemble --scan --force
[root@BigBlue Desktop]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sdf1[8](S) sde1[2] sdg1[4] sdd1[1] sdh1[7] sdc1[0] 
sdb1[6]
       20510934584 blocks super 1.2
[root@BigBlue Desktop]# mdadm --assemble --force /dev/md0 
/dev/sd{b,c,d,e,g,h}1
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping
mdadm: /dev/sde1 is busy - skipping
mdadm: /dev/sdg1 is busy - skipping
mdadm: /dev/sdh1 is busy - skipping
[root@BigBlue Desktop]# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
[root@BigBlue Desktop]# mdadm --assemble --force /dev/md0 
/dev/sd{b,c,d,e,g,h}1mdadm: Marking array /dev/md0 as 'clean'
mdadm: /dev/md0 has been started with 6 drives (out of 7).
[root@BigBlue Desktop]# mdadm --manage /dev/md0 --add /dev/sdf1
mdadm: added /dev/sdf1
[root@BigBlue Desktop]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdf1[8] sdc1[0] sdb1[6] sdh1[7] sdg1[4] sde1[2] 
sdd1[1]
       14650666880 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[7/6] [UUU_UUU]
       [>....................]  recovery =  0.0% (2017024/2930133376) 
finish=725.8min speed=67234K/sec

