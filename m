From: "Paul M. Goorskis" <pmg@rimako.lv>
Subject: remove 'spare' mark on drive
Date: Fri, 07 May 2004 18:09:29 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <409BA6A9.4080203@rimako.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looks like it's a good place to ask. Didn't noticed my question answered 
in FAQ.

Software IDE RAID-5 (non-root/boot) with 3 drives.
Array worked properly until one ide-drive came offline. Array started to 
work in 'degraded' mode. I tryied removing/readding the faulty drive and 
got it back to the array. Everything works fine for two weeks. Now the 
drive came offline again (surprise-surprise :).
Did some manipulations with raid-tools, like adding/removing drive from 
the raid, marking faulty and such, have no success.

Here comes the problem:
Initializing the array with raid-tools gives me the following: not 
enough operational devices for md0
Initializing the array with mdadm gives a little more info: /dev/md0 
assembled from 1 drive and 2 spares.

So i suppose that i should do "something" to remove spare mark from 2 
drives because they were part of an array and i hope my manipulations 
did not destroyed them :). Just need to reconstruct the array with old 
drives.

/proc/mdstat:
Personalities : [raid5]
read_ahead not set
md0 : inactive hdc1[1] hdb[4] hdd[3]
          0 blocks
unused devices: <none>

/etc/raidtab:
raiddev /dev/md0
    raid-level    5
    nr-raid-disks   3
    nr-spare-disks   0
    persistent-superblock   1
    parity-algorithm   left-symmetric
    chunk-size   128
    device   /dev/hdb1
    raid-disk   0
    device   /dev/hdc1
    raid-disk   1
    device   /dev/hdd1
    raid-disk   2


