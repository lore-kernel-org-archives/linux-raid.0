From: Peter Urbanec <linux-raid@urbanec.net>
Subject: RAID5 check does not read disk media
Date: Wed, 04 Apr 2012 23:23:18 +1000
Message-ID: <4F7C4B46.2090209@urbanec.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm running Gentoo kernel 3.3.0 with raid5 on four ICH7 AHCI connected 
Seagate 2TB 7200RPM disks. I also have two WD 1TB Green disks in raid1 
on a Sil3114 with a JBOD (non-RAID) BIOS.

When I attempt to do a scrub/check on the raid5, the check seems to 
proceed without actually reading any data from the disks - the disk 
activity lights do not even flicker.

Looking at the speed at which the check completes confirms this:

# cat /proc/sys/dev/raid/speed_limit_min
10000
# cat /proc/sys/dev/raid/speed_limit_max
4000000
# echo check > devices/virtual/block/md0/md/sync_action
# echo check > devices/virtual/block/md127/md/sync_action
...
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : active raid1 sdf1[1] sde1[0]
       976760384 blocks [2/2] [UU]
       [>....................]  check =  1.7% (17387072/976760384) 
finish=380.7min speed=41994K/sec

md0 : active raid5 sdb[1] sda[0] sdd[4] sdc[2]
       5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/4] [UUUU]
       [==================>..]  check = 93.9% (1835359616/1953511936) 
finish=0.8min speed=2332893K/sec


raid1 runs at about 42MB/s as expected with two WD 1TB Green drives.
raid5 runs at well over 2GB/s - not really possible with four Seagate 
2TB 7200RPM drives.

Any ideas on what may be going on there and how to fix it. Let me know 
what/if more information may be needed.

Thanks

     Peter Urbanec

