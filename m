From: thomas62186218@aol.com
Subject: RAID6 issue: md_do_sync() got signal ... exiting
Date: Fri, 30 Nov 2007 04:47:57 -0500
Message-ID: <8CA014D38F0B1EC-68C-93FE@WEBMAIL-MC03.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am having trouble with creating a RAID 6 md device on a home-grown 
Linux 2.6.20.11 SMP 64-bit build.

I first create the RAID6 without problems, and see the following 
successful dump in /var/log/messages. If I check /proc/mdstat, the 
RAID6 is doing the initial syncing as expected.

Nov 30 01:26:39 testsystem kernel: md: bind<dm-3>
Nov 30 01:26:39 testsystem kernel: md: bind<dm-2>
Nov 30 01:26:39 testsystem kernel: md: bind<dm-1>
Nov 30 01:26:39 testsystem kernel: md: bind<dm-0>
Nov 30 01:26:39 testsystem kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Nov 30 01:26:39 testsystem kernel: raid5: device dm-0 operational as 
raid disk 3
Nov 30 01:26:39 testsystem kernel: raid5: device dm-1 operational as 
raid disk 2
Nov 30 01:26:39 testsystem kernel: raid5: device dm-2 operational as 
raid disk 1
Nov 30 01:26:39 testsystem kernel: raid5: device dm-3 operational as 
raid disk 0
Nov 30 01:26:39 testsystem kernel: raid5: allocated 4268kB for md0
Nov 30 01:26:39 testsystem kernel: raid5: raid level 6 set md0 active 
with 4 out of 4 devices, algorithm 0
Nov 30 01:26:39 testsystem kernel: RAID5 conf printout:
Nov 30 01:26:39 testsystem kernel:  --- rd:4 wd:4
Nov 30 01:26:42 testsystem kernel:  disk 0, o:1, dev:dm-3
Nov 30 01:26:42 testsystem kernel:  disk 1, o:1, dev:dm-2
Nov 30 01:26:42 testsystem kernel:  disk 2, o:1, dev:dm-1
Nov 30 01:26:42 testsystem kernel:  disk 3, o:1, dev:dm-0
Nov 30 01:26:42 testsystem kernel: md: resync of RAID array md0
Nov 30 01:26:42 testsystem kernel: md: minimum _guaranteed_  speed: 0 
KB/sec/disk.
Nov 30 01:26:42 testsystem kernel: md: using maximum available idle IO 
bandwidth (but not more than 0 KB/sec) for resync.
Nov 30 01:26:42 testsystem kernel: md: using 128k window, over a total 
of 143371968 blocks.


If I then delete the RAID6 and try to create the exact same RAID6 
again, it sometimes fails, with the following appearing in 
/var/log/messages. Note the md_do_sync() got signal ... exiting line:

Nov 30 01:28:03 testsystem kernel: md: bind<dm-3>
Nov 30 01:28:03 testsystem kernel: md: bind<dm-2>
Nov 30 01:28:03 testsystem kernel: md: bind<dm-1>
Nov 30 01:28:03 testsystem kernel: md: bind<dm-0>
Nov 30 01:28:03 testsystem kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Nov 30 01:28:03 testsystem kernel: raid5: device dm-0 operational as 
raid disk 3
Nov 30 01:28:03 testsystem kernel: raid5: device dm-1 operational as 
raid disk 2
Nov 30 01:28:03 testsystem kernel: raid5: device dm-2 operational as 
raid disk 1
Nov 30 01:28:03 testsystem kernel: raid5: device dm-3 operational as 
raid disk 0
Nov 30 01:28:03 testsystem kernel: raid5: allocated 4268kB for md0
Nov 30 01:28:03 testsystem kernel: raid5: raid level 6 set md0 active 
with 4 out of 4 devices, algorithm 0
Nov 30 01:28:03 testsystem kernel: RAID5 conf printout:
Nov 30 01:28:03 testsystem kernel:  --- rd:4 wd:4
Nov 30 01:28:04 testsystem kernel:  disk 0, o:1, dev:dm-3
Nov 30 01:28:05 testsystem kernel:  disk 1, o:1, dev:dm-2
Nov 30 01:28:05 testsystem kernel:  disk 2, o:1, dev:dm-1
Nov 30 01:28:05 testsystem kernel:  disk 3, o:1, dev:dm-0
Nov 30 01:28:05 testsystem kernel: md: resync of RAID array md0
Nov 30 01:28:05 testsystem kernel: md: minimum _guaranteed_  speed: 0 
KB/sec/disk.
Nov 30 01:28:05 testsystem kernel: md: using maximum available idle IO 
bandwidth (but not more than 0 KB/sec) for resync.
Nov 30 01:28:05 testsystem kernel: md: using 128k window, over a total 
of 143368192 blocks.
Nov 30 01:28:05 testsystem kernel: md: md_do_sync() got signal ... 
exiting
Nov 30 01:28:05 testsystem kernel: md: checkpointing resync of md0.
Nov 30 01:28:05 testsystem kernel: md: md0 stopped.
Nov 30 01:28:05 testsystem kernel: md: unbind<dm-0>
Nov 30 01:28:05 testsystem kernel: md: export_rdev(dm-0)
Nov 30 01:28:05 testsystem kernel: md: unbind<dm-1>
Nov 30 01:28:05 testsystem kernel: md: export_rdev(dm-1)
Nov 30 01:28:05 testsystem kernel: md: unbind<dm-2>
Nov 30 01:28:05 testsystem kernel: md: export_rdev(dm-2)
Nov 30 01:28:05 testsystem kernel: md: unbind<dm-3>
Nov 30 01:28:05 testsystem kernel: md: export_rdev(dm-3)


The failure is VERY intermittent. Sometimes it fails, sometimes it 
succeeds...with the exact same creation procedure. Any ideas on what 
may be causing this issue? Thank you very much in advance for your 
assistance!


Best regards,
Thomas









________________________________________________________________________
More new features than ever.  Check out the new AOL Mail ! - 
http://o.aolcdn.com/cdn.webmail.aol.com/mailtour/aol/en-us/text.htm?ncid=aolcmp00050000000003
