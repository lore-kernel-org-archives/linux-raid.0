From: "michael@kmaclub.com" <michael@kmaclub.com>
Subject: Problem with assembly after a drive replacement
Date: Fri, 15 Aug 2008 08:27:07 -0700
Message-ID: <48A5A04B.4020809@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a six drive raid 6 consisting of sdc1 through sdh1.

Recently sdg died and I replaced it using mdadm -f and mdadm -r.

When I was adding the drive back, I accidentally added /dev/sdg instead 
of /dev/sdg1.  So, I went through and did mdadm -f and mdadm -r to 
remove it.

I repartitioned the drive to give me /dev/sdg1 again and used mdadm -a 
to add it back.

The drives sync'ed and I thought all was well.  However, now at boot up, 
I get:

md2 : inactive sdf1[3](S) sdd1[1](S) sde1[2](S) sdh1[5](S) sdc1[0](S) 
sdg[6](S)
       2930306176 blocks

Looking through dmesg, I see it is trying to add sdg and not sdg1.

md: bind<sdg>
md: bind<sdc1>
md: bind<sdh1>
md: bind<sde1>
md: bind<sdd1>
md: bind<sdb1>
md: bind<sda1>
md: bind<sdf1>


I can assemble the array by hand and all is well.

mdadm --assemble /dev/md2 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 
/dev/sdg1  /dev/sdh1

md2 : active raid6 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
       1953535744 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

mdadm --detail /dev/md2
/dev/md2: 

         Version : 00.90.03 

   Creation Time : Sat Jun 14 17:22:56 2008 

      Raid Level : raid6 

      Array Size : 1953535744 (1863.04 GiB 2000.42 GB) 

   Used Dev Size : 488383936 (465.76 GiB 500.11 GB) 

    Raid Devices : 6 

   Total Devices : 6 

Preferred Minor : 2 

     Persistence : Superblock is persistent 


     Update Time : Fri Aug 15 07:47:32 2008
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 64K

            UUID : 6679acd0:6d97197c:c917441c:58a2f77c
          Events : 0.205954

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        3       8       81        3      active sync   /dev/sdf1
        4       8       97        4      active sync   /dev/sdg1
        5       8      113        5      active sync   /dev/sdh1


How do I make it forget about /dev/sdg and assemble using sdg1?  I tried 
updating the super block minor at assemble time and that didn't seem to 
make a difference.

I am running Fedora 9 with kernel 2.6.25.14-108

Michael
