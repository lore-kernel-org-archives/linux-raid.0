From: Jeff Morrow <jmorrow@jmorrow.org>
Subject: Missing capacity in a RAID 5 array?
Date: Wed, 05 May 2004 23:04:04 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4099D554.808@jmorrow.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've created a software RAID 5 array consisting of 8 160 GB drives.  One 
of the drives had prior data I wanted to keep, so I first created a 
7-drive array, copied the data from the original drive to the array, 
then added the 8th drive using raidreconf.  Worked like a charm (took 
about 27 hours, though!)

The OS now reports that the total capacity on /dev/md0 is about 920 GB:

/dev/md0             923029884 172872252 750157632  19% /mnt/store

Now, even if we take into account that the drives are 160 decimal GB, 
which equates to 149 binary GB, my array should still have a total 
capacity somewhere around 7 x 149 = 1043 GB.

Am I really losing 120 GB to reserved space for RAID and/or filesystem 
accounting?  I feel like I'm missing something obvious here.  Can I get 
my full terabyte somehow?

Here's my /etc/raidtab:

raiddev /dev/md0
         raid-level 5
         nr-raid-disks 8
         nr-spare-disks 0
         persistent-superblock 1
         parity-algorithm left-symmetric
         chunk-size 32
         device /dev/hdc
         raid-disk 0
         device /dev/hdd
         raid-disk 1
         device /dev/hde
         raid-disk 2
         device /dev/hdg
         raid-disk 3
         device /dev/hdh
         raid-disk 4
         device /dev/hdi
         raid-disk 5
         device /dev/hdk
         raid-disk 6
         device /dev/hdf
         raid-disk 7

And here's my /proc/mdstat:

Personalities : [raid5]
md0 : active raid5 hdf[7] hdk[6] hdi[5] hdh[4] hdg[3] hde[2] hdd[1] hdc[0]
       1094035712 blocks level 5, 32k chunk, algorithm 2 [8/8] [UUUUUUUU]

unused devices: <none>

Thanks for the help.

Jeff Morrow



