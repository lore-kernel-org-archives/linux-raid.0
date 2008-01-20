From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: RE: mdadm error when trying to replace a failed drive in RAID5 array
Date: Sun, 20 Jan 2008 21:01:19 -0000
Message-ID: <013801c85ba7$9b62f940$0603a8c0@meanmachine>
References: <4793AEEC.7090802@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4793AEEC.7090802@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Bill Davidsen' <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for the response Bill.  Neil has responded to me a few times, but
I'm more than happy to try and keep it on this list instead as it feels
like I'm badgering Neil which really isn't fair...

Since my initial email, I got to the point of believing it was down to
the superblock, and that --zero-superblock wasn't working, so a good few
hours and a dd if=/dev/zero of=/dev/hdc later, I tried adding it again
to the same result.

As it happens, I did the --zero-superblock, then tried to insert it
again and then examined (mdadm -E) again and the block was 'still there'
- What really happened was that the act of trying to add it writes in
the superblock.  So --zero-superblock is working fine for me, but it's
still refusing to add the device.

The only other thing I've tried is moving the replacement drive to
/dev/hdd instead (secondary slave) with an small old HD I had lying
around as hdc.

[root@space ~]# mdadm -E /dev/hdd1
mdadm: No md superblock detected on /dev/hdd1.

[root@space ~]# mdadm /dev/md0 --add /dev/hdd1
mdadm: add new device failed for /dev/hdd1 as 5: Invalid argument

[root@space ~]# dmesg | tail
...
md: hdd1 has invalid sb, not importing!
md: md_import_device returned -22

[root@space ~]# mdadm -E /dev/hdd1
/dev/hdd1:
Magic : a92b4efc
Version : 00.90.00
UUID : 382c157a:405e0640:c30f9e9e:888a5e63
Creation Time : Wed Jan 9 18:57:53 2008
Raid Level : raid5
Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
Raid Devices : 5
Total Devices : 4
Preferred Minor : 0
Update Time : Sun Jan 20 13:02:00 2008
State : clean
Active Devices : 4
Working Devices : 4
Failed Devices : 1
Spare Devices : 0
Checksum : 198f8fb4 - correct
Events : 0.348270
Layout : left-symmetric
Chunk Size : 64K
Number Major Minor RaidDevice State
this 5 22 65 -1 spare /dev/hdd1
0 0 8 1 0 active sync /dev/sda1
1 1 8 17 1 active sync /dev/sdb1
2 2 8 33 2 active sync /dev/sdc1
3 3 0 0 3 faulty removed
4 4 8 49 4 active sync /dev/sdd1

I have mentioned it to Neil, but didn't mention it here before.  I am a
C developer by trade, so can easily devle into the mdadm source for
extra debug if anyone thinks it could help.  I could also delve into md
in the kernel if really wanted, but my knowledge of building kernels on
linux is some 4 years+ out of date and forgotten, so if that's a yes,
then some pointers on how to get the centos kernel config and a choice
of kernel from www.kernel.org, or from the centos distro would be
invaluable.

I'm away for a few days from tomorrow and probably wont be able to do
much if anything until I'm back on Thursday, so please be patient if I
don't respond before then.

Many Thanks,

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.7/1233 - Release Date:
19/01/2008 18:37
 

