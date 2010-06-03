From: Andrew Dunn <andrew.g.dunn.dod@gmail.com>
Subject: Question about preferred minor.
Date: Wed, 2 Jun 2010 20:53:28 -0400
Message-ID: <AANLkTimbMat99Su8F4FauQIa8mpeZJk6syJ0oXjHyygG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have never noticed this, my apologies for not being able to resolve
this independently.

I have this array that I am using for the primary bulk of my data and
today was the first day that I noticed this designator in the detailed
output:

storrgie@MINERVA:~$ sudo mdadm -D /dev/md2
/dev/md2:
        Version : 00.90
  Creation Time : Fri Apr 30 21:13:28 2010
     Raid Level : raid6
     Array Size : 11721071616 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Jun  2 20:42:04 2010
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           UUID : f340fbe8:51967d4b:6d37f269:4e81e338 (local to host MINERVA)
         Events : 0.26

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       1       8       81        1      active sync   /dev/sdf1
       2       8       97        2      active sync   /dev/sdg1
       3       8      113        3      active sync   /dev/sdh1
       4       8      129        4      active sync   /dev/sdi1
       5       8      145        5      active sync   /dev/sdj1
       6       8      161        6      active sync   /dev/sdk1
       7       8      177        7      active sync   /dev/sdl1


What is the meaning of Preferred Minor : 2 ?

Thank you all.
