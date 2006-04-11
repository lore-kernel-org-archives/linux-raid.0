From: johnny@navtek.no
Subject: failed to RUN_ARRAY, input/output error
Date: Tue, 11 Apr 2006 23:22:28 +0200 (CEST)
Message-ID: <54490.84.236.149.243.1144790548.squirrel@www.navtek.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello all

I just ran into a problem with my RAID5 array. Everything seemed to run
fine, but then suddenly froze and upon reboot the boot process wouldn't
start from the array and panic'ed after a while.

Here's the data I've been able to gather from my FC 5 linux rescue session:

My partitions: /dev/hda2, /dev/hdc2, /dev/hde1, /dev/hdg1
/dev/hde is not working - lots of DriveReady SeekComplete Error and others

# mdadm -V
mdadm - v2.3.1

# mdadm -E /dev/hda2, /dev/hdc2 and /dev/hdg1 yields:
Same on all:
Magic: a92b4efc
Version: 00.90.01
UUID : <long id>
Raid Level: raid5
Raid Devices: 4
Total Devices: 4
Preferred Minor: 0
State: active
Active Devices: 3
Working Devices: 3
Failed Devices: 2
Events: 0.4188000
Layout: left-symmetric
Chunk size: 256K

Number Major Minor RaidDevice State
0 3  2 0 active sync /dev/hda2
1 22 2 1 active sync /dev/hdc2
2 0  0 2 faulty removed
3 34 1 3 active sync /dev/hdg1

Different on all:
Checksum

# mdadm --assemble /dev/md0 /dev/hda2 /dev/hdc2 /dev/hdg1
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

# cat /proc/mdstat
md0: inactive hda2[0] hdg1[3] hdc2[1]

# mdadm --detail /dev/md0
Persistence: Superblock is persistent
State: active, degraded
Active Devices: 3
Working Devices: 3
Failed Devices: 0

Number Major Minor RaidDevice State
0 3  2 0 active sync /dev/hda2
1 22 2 1 active sync /dev/hdc2
0 0  0 2311520 removed
3 34 1 3 active sync /dev/hdg1

I'm off to buy another 200GiB disk now, but is my current array doomed or
do I have a chance?
Any inputs would be highly welcome!

thanks
Johnny Ljunggren


