From: Novak David-DNOVAK1 <David.Novak@motorola.com>
Subject: Linear Raid Problems...
Date: Fri, 2 Apr 2004 08:27:16 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8E4E38BF6D087F4488E80ABAACA2F3F484D646@il27exm02.cig.mot.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

  Sorry, but this message might be a tad long.  But I'm running an 
UltraSparc Debian Linux (with SMP!).  Anyway, I've got a few extra disks I 
want to span into one Uber-partion, and figured Software RAID (linear) was 
the way to go.  I've read the howto's and the faq's, and thought I was 
doing everything right...but alas something is amiss, and I implore for the 
Linux community's help.  Here's my setup:

/etc/raidtab:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   3
        chunk-size      32
        persistent-superblock 1
        device          /dev/sdb1
        raid-disk       0
        device          /dev/sdc1
        raid-disk       1
        device          /dev/sdd1
        raid-disk       2

mkraid command:

Homer:/etc# mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdb1, 8841042kB, raid superblock at 8840960kB
disk 1: /dev/sdc1, 11879560kB, raid superblock at 11879488kB
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

mkraid version:
Homer:/etc# mkraid --version
mkraid version 0.90.0

Kernel version:
Homer:/etc# cat /proc/version
Linux version 2.4.19 (root@hopper) (gcc version egcs-2.92.11 19980921 (gcc2 ss-9
80609 experimental)) #1 SMP Fri Oct 4 19:11:01 EDT 2002

After running mkraid they syslog says:
Apr  2 07:47:39 Homer kernel:  I/O error: dev 08:21, sector 23758976

In desperation tried:
mkraid --really-force /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdb1, 8841042kB, raid superblock at 8840960kB
disk 1: /dev/sdc1, 11879560kB, raid superblock at 11879488kB
disk 2: /dev/sdd1, 2076320kB, raid superblock at 2076224kB
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

Then syslog says:
Apr  2 07:50:18 Homer kernel: md: array md0 already exists!

Which is weird because that exact command didn't work last night...
but now mdstat says:

Homer:/etc# cat /proc/mdstat
Personalities :
read_ahead not set9L, 906C                                    1,1           All
md0 : inactive sdd1[2] sdc1[1] sdb1[0]
      0 blocks
unused devices: <none>

Which is weird, because last night it didn't say that...

So I think the kernel thinks it's there right, but when I do an fdisk:
Homer:/# fdisk /dev/md0
Unable to read /dev/md0

Or if I try to create a fs:
Homer:/# mkfs.ext3 /dev/md0
mke2fs 1.27 (8-Mar-2002)
mkfs.ext3: Device size reported to be zero.  Invalid partition specified, or
        partition table wasn't reread after running fdisk, due to
        a modified partition being busy and in use.  You may need to reboot
        to re-read your partition table.

I think that's all the data somebody really smart might need to diagnose my 
problem.  Thanks in advance for any info!

  David

-------
David J.  Novak                           GSM Radio Firmware
GSM Products Division                     CE/NSS
Motorola                                  Life v7.0
--------------------------------------------------------------------------
"Not all who wander are lost." - J.R.R. Tolkien
