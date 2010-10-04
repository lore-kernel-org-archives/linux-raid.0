From: Hank Barta <hbarta@gmail.com>
Subject: RAID1 hangs on startup when 1 of 5 drives is disconnected.
Date: Mon, 4 Oct 2010 14:46:05 -0500
Message-ID: <AANLkTikbOkvyu8ynGYYfD+9=yq710Y-VEwxN6ACN0FUK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I have a Ubuntu host with a 5 disk RAID5 setup. This has been running
nearly 5 years. At present It is on Ubuntu Server 10.04 LTS and was
setup either with Ubuntu or Debian. The RAID consists of a mix of 5
IDE and SATA drives The SATA drives are on a Promise PCI controller:
00:08.0 Mass storage controller: Promise Technology, Inc. PDC20318
(SATA150 TX4) (rev 02)

I'm in the process of trying to upgrade to new drives and I cannot get
a new SATA drive recognized by the motherboard controller (probably a
BIOS issue) so I thought I could disconnect one of the RAID drives and
bring it up in degraded mode for as long as it takes to transfer
contents to the new drive. However, when I disconnect one SATA cable,
the system comes up to the point where it reports (to the console)
that /dev/sda1 is clean and gets stuck. It just hangs there.
(/dev/sda1 is not part of the RAID and is the drive that the system
boots from.) This is not what I expected. I thought the system would
come up and the RAID would be available in a degraded mode. At that
point my plan was to plug a new drive into the existing cable and
transfer contents of the RAID to it.

This system is running the stock Ubuntu kernel:
hbarta@oak:~$ uname -a
Linux oak 2.6.32-25-server #44-Ubuntu SMP Fri Sep 17 21:13:39 UTC 2010
x86_64 GNU/Linux

Raid status:
hbarta@oak:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdd1[1] sdf1[3] sde1[2] sdc1[0] sdb1[4]
      781433344 blocks level 5, 32k chunk, algorithm 2 [5/5] [UUUUU]
unused devices: <none>
hbarta@oak:~$


From dmesg I see:
[   10.166465] raid5: device sdd1 operational as raid disk 1
[   10.166470] raid5: device sdf1 operational as raid disk 3
[   10.166472] raid5: device sde1 operational as raid disk 2
[   10.166474] raid5: device sdc1 operational as raid disk 0
[   10.166477] raid5: device sdb1 operational as raid disk 4
[   10.167079] raid5: allocated 5334kB for md0
[   10.167347] 1: w=1 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[   10.167350] 3: w=2 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[   10.167353] 2: w=3 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[   10.167355] 0: w=4 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[   10.167358] 4: w=5 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[   10.167360] raid5: raid level 5 set md0 active with 5 out of 5
devices, algorithm 2
[   10.167362] RAID5 conf printout:
[   10.167363]  --- rd:5 wd:5
[   10.167365]  disk 0, o:1, dev:sdc1
[   10.167367]  disk 1, o:1, dev:sdd1
[   10.167369]  disk 2, o:1, dev:sde1
[   10.167371]  disk 3, o:1, dev:sdf1
[   10.167372]  disk 4, o:1, dev:sdb1
[   10.167410] md0: detected capacity change from 0 to 800187744256
[   10.168989]  md0: unknown partition table
[   10.432562] EXT4-fs (sda1): mounted filesystem with ordered data mode

There is a lot of other information about MD in the dmesg output but
it looks like is is registering capabilities built into the kernel.
What I quoted above looks specific to my RAID. My RAID is broken into
three partitions via LVM.

Suggestions for resolving this would be most appreciated. My first
thought is to mark a drive as faulted or failed and then disconnect
the cable (while power is off) More detailed suggestions would be most
appreciated!

If further information would help, please do not hesitate to ask.

thanks,
hank

--
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
