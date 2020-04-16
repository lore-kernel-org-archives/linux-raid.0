From: Coly Li <colyli@suse.de>
Subject: [BUG REPORT] md raid5 with write log does not start
Date: Fri, 17 Apr 2020 00:30:25 +0800
Message-ID: <4ad57f1f-a00f-3bc6-33d2-f30ca8e18c0d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

When I try to create md raid5 array with 4 NVMe SSD (3 for raid array
component disks, 1 for write log), the kernel is Linux v5.6 (not Linux
v5.7-rc), I find the md raid5 array cannot start.

I use this command to create md raid5 with writelog,

mdadm -C /dev/md0 -l 5 -n 3 /dev/nvme{0,1,2}n1 --write-journal /dev/nvme3n1

From terminal I have the following 2 lines information,

mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Invalid argument

From kernel message, I have the following dmesg lines,

[13624.897066] md/raid:md0: array cannot have both journal and bitmap
[13624.897068] md: pers->run() failed ...
[13624.897105] md: md0 stopped.

But from /proc/mdstat, it seems an inactive array is still created,

/proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : inactive nvme2n1[4](S) nvme0n1[0](S) nvme3n1[3](S)
      11251818504 blocks super 1.2

unused devices: <none>

From all the information it seems when initialize raid5 cache the bitmap
information is not cleared, so an error message shows up and raid5_run()
fails.

I don't have clear idea who to handle bitmap, journal and ppl properly,
so I firstly report the problem here.

So far I am not sure whether this is a bug or I do something wrong. Hope
other people may reproduce the above failure too.

Thanks.

Coly Li
