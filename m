From: "Patrick Tschackert" <Killing-Time@gmx.de>
Subject: problems with dm-raid 6
Date: Sun, 20 Mar 2016 22:44:57 +0100
Message-ID: <trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I've been referred here after this exchange: https://mail-archive.com/linux-btrfs@vger.kernel.org/msg51726.html
Especially the last email: https://mail-archive.com/linux-btrfs@vger.kernel.org/msg51763.html

Here's a rundown of my problem:
After rebooting the system, one of the harddisks was missing from my md raid 6 (the drive was /dev/sdf), so i rebuilt it with a hotspare that was already present in the system.
I physically removed the "missing" /dev/sdf drive after the restore and replaced it with a new drive.
This was all done using the following kernel:

$ uname -a
Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
(2016-02-29) x86_64 GNU/Linux

After I got advice from the linux-btrfs mailing list, i upgraded to a newer kernel from the debian backports and increased the command timeout on the drives:

$ uname -a
Linux vmhost 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.5-1~bpo8+1 (2016-02-23) x86_64 GNU/Linux

$ cat /sys/block/md0/md/mismatch_cnt
0

$ for i in /sys/class/scsi_generic/*/device/timeout; do echo 120 > "$i"; done
(I know this isn't persistent across reboots...)

$ echo check > /sys/block/md0/md/sync_action

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sda[0] sdf[12](S) sdg[11](S) sdj[9] sdh[7] sdi[6] sdk[10] sde[4] sdd[3] sdc[2] sdb[1]
20510948416 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
[>....................] check = 1.0% (30812476/2930135488) finish=340.6min speed=141864K/sec

unused devices: <none>

After the raid was done checking, I got this:

$ cat /sys/block/md0/md/mismatch_cnt
311936608

And messages in dmesg (attached to this mail) lead me to believe that the /dev/sdh drive is also faulty:

[12235.372901] sd 7:0:0:0: [sdh] tag#15 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[12235.372906] sd 7:0:0:0: [sdh] tag#15 Sense Key : Medium Error [current] [descriptor]
[12235.372909] sd 7:0:0:0: [sdh] tag#15 Add. Sense: Unrecovered read error - auto reallocate failed
[12235.372913] sd 7:0:0:0: [sdh] tag#15 CDB: Read(16) 88 00 00 00 00 00 af b2 bb 48 00 00 05 40 00 00
[12235.372916] blk_update_request: I/O error, dev sdh, sector 2947727304
[12235.372941] ata8: EH complete
[12266.856747] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
[12266.856753] ata8.00: irq_stat 0x40000008
[12266.856756] ata8.00: failed command: READ FPDMA QUEUED
[12266.856762] ata8.00: cmd 60/40:d8:08:17:b5/05:00:af:00:00/40 tag 27 ncq 688128 in
res 41/40:00:18:1b:b5/00:00:af:00:00/40 Emask 0x409 (media error) <F>
[12266.856765] ata8.00: status: { DRDY ERR }
[12266.856767] ata8.00: error: { UNC }
[12266.858112] ata8.00: configured for UDMA/133

Here are the output for "smartctl -x" for each disk in the array: http://pastebin.com/PCMMByJc
And here's my complete dmesg: http://pastebin.com/bwkhXh2S

This is the current status of the array:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sda[0] sdf[12](S) sdg[11](S) sdj[9] sdh[7] sdi[6] sdk[10] sde[4] sdd[3] sdc[2] sdb[1]
20510948416 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]

unused devices: <none>

$ mdadm -D /dev/md0
/dev/md0:
Version : 1.2
Creation Time : Sat Jun 14 18:47:44 2014
Raid Level : raid6
Array Size : 20510948416 (19560.77 GiB 21003.21 GB)
Used Dev Size : 2930135488 (2794.40 GiB 3000.46 GB)
Raid Devices : 9
Total Devices : 11
Persistence : Superblock is persistent

Update Time : Sun Mar 20 18:04:04 2016
State : clean
Active Devices : 9
Working Devices : 11
Failed Devices : 0
Spare Devices : 2

Layout : left-symmetric
Chunk Size : 64K

Name : brain:0
UUID : e45daf8f:99d0ff7f:e8244429:827e7c71
Events : 2393

Number Major Minor RaidDevice State
0 8 0 0 active sync /dev/sda
1 8 16 1 active sync /dev/sdb
2 8 32 2 active sync /dev/sdc
3 8 48 3 active sync /dev/sdd
4 8 64 4 active sync /dev/sde
10 8 160 5 active sync /dev/sdk
6 8 128 6 active sync /dev/sdi
7 8 112 7 active sync /dev/sdh
9 8 144 8 active sync /dev/sdj

11 8 96 - spare /dev/sdg
12 8 80 - spare /dev/sdf

The RAID holds an encrypted LUKS container. After opening it, the filesys can't be mounted (see https://mail-archive.com/linux-btrfs@vger.kernel.org/msg51726.html[https://mail-archive.com/linux-btrfs@vger.kernel.org/msg51726.html]).
Could this be due to errors on the raid?
Should i manually fail /dev/sdh and rebuild?

Thank you & kind Regards
