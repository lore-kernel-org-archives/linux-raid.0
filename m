From: "John Doe" <public_address_911@hotmail.com>
Subject: Problem converting raid-5 array from 2.2.17 into 2.4.22
Date: Wed, 03 Sep 2003 01:31:43 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Law12-F83aJ0j4YbmBs00031071@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I used to have the following array:

# mdtab entry for /dev/md0
/dev/md0        raid5,128k,0,93fa4522   /dev/hda3 /dev/hdb1 /dev/hdc1 
/dev/hdd1

This ran on linux 2.2.17 and raidtools 0.42. When upgrading the kernel to 
2.4.22
and raid-tools 0.90 I understood that it would be necessary to run mkraid 
--upgrade
on the device. So I run it on the following raidtab:

/etc/raidtab:
raiddev /dev/md0
        raid-level      5
        nr-raid-disks   4
        nr-spare-disks  0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size      32
        device          /dev/hda3
        raid-disk       0
        device          /dev/hdb1
        raid-disk       1
        device          /dev/hdc1
        raid-disk       2
        device          /dev/hdd1
        raid-disk       3

This one was copied straight from Software-RAID HOWTO, unfortunately I 
noticed
only afterwards that the chunk-size was different than it was before. 
Anyway,
mkraid seemed to convert the array; it printed out many pages of information
which I didn't analyze further, but apparently it left the raid in a somehow
bad state, because:

# raidstart /dev/md0
/dev/md0: Invalid argument

# cat /proc/mdstat
Personalities : [raid5]
read_ahead not set
unused devices: <none>

I learned that mdadm would apparently be a good tool for analysing the 
situation,
but I had no success there:

# mdadm --examine /dev/md0
mdadm: /dev/md0 is too small for md

Trying to --upgrade with the correct chunk 128kb size set in /etc/raidtab 
just prints:

handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hda3, 78935377kB, raid superblock at 78935296kB
array needs no upgrade
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

And trying to go back to kernel 2.2.17 and raidtools 0.42 causes the 
following havoc in
/etc/init.d/raid start:

Adding md devices.
/dev/md0: Invalid argument
Some of the RAID devices have errors:
  Checking "md0":
ckraid: aborted
ckraid version 0.36.4
parsing configuration file
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hda3, 78935377kB, raid superblock at 78935296kB
disk 1: /dev/hdb1, 80035798kB, raid superblock at 80035712kB
disk 2: /dev/hdc1, 80035798kB, raid superblock at 80035712kB
disk 3: /dev/hdd1, 80035798kB, raid superblock at 80035712kB
reading raid superblock
unsupported raid array version 0.90.0
/dev/md0: Invalid argument
  WARNING: unrecovered RAID errors!

So apparently the superblocks _are_ there but the kernel just cannot read 
them.

Is there any way to correct the situation without remaking the array?

I'd just like to know if the data is definitely gone forever after 
specifying
the wrong chunk size, or is there still hope to recover it.

Any help would be greatly appreciated!

-J

_________________________________________________________________
Help STOP SPAM with the new MSN 8 and get 2 months FREE*  
http://join.msn.com/?page=features/junkmail

