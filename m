From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Do I understand my RAID6 correctly?
Date: Tue, 12 Apr 2011 10:39:00 +0200
Message-ID: <4DA40FA4.80605@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Today I had a drive fail in a customers server.

It was part of a RAID6 which seems to have rebuilt onto a spare drive now.

Right now it looks like:

# mdadm -D /dev/md3
/dev/md3:
        Version : 00.90.03
  Creation Time : Thu Dec 20 17:47:07 2007
     Raid Level : raid6
     Array Size : 4391334912 (4187.90 GiB 4496.73 GB)
  Used Dev Size : 731889152 (697.98 GiB 749.45 GB)
   Raid Devices : 8
  Total Devices : 9
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Tue Apr 12 10:27:45 2011
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0

     Chunk Size : 64K

           UUID : e848b637:ca2bde73:9f92f3cc:128cdbad
         Events : 0.47127534

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8      177        1      active sync   /dev/sdl1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1
       7       8      145        7      active sync   /dev/sdj1

       8       8      161        -      faulty spare   /dev/sdk1

My question (just to be sure):

Do I understand it correctly that the system has substituted the failed
/dev/sdk1 by a former spare drive (dunno the device name now) and that I
now I have a valid RAID6-device with 8 drives in it?

So out of the 8 drives there could fail another 2 now without losing
data ...

correct?

I have to tell the customer what to do and the grade of redundancy
available also relates to how urgent it is to get a new drive into the
system.

I assume I would remove /dev/sdk1 from md3, swap the drive, fdisk it and
re-add sdk1 to md3 (it is failed already now, so the fail-step isn't
necessary anymore). It would the be the new spare drive ... ?

Thanks for refreshing my RAID-knowledge ;-)
Stefan
