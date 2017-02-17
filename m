From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/3]md/raid5: improve IO pattern
Date: Fri, 17 Feb 2017 15:32:23 -0800
Message-ID: <cover.1487373517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

Hi,

These are some patches I'm testing to improve raid5-cache performance. The basic
idea is to flush a lot of stripes to raid disks and then do smart scheduling of
IOs. In my test of a 12-disk raid6 array, this improves around 20% throughput
and request size/disk seek are improved a lot. fio script I'm using are:

[global]
ioengine=libaio
direct=1
loops=1000
runtime=120
time_based=1
file_service_type=random:36
overwrite=1
thread=0
group_reporting=1

[test]
filename=/dev/md0
bs=4k
readwrite=randwrite
numjobs=8
offset_increment=10G

--------------------------------------------
Shaohua Li (3):
  md/raid5: prioritize stripes for writeback
  md/raid5-cache: bump flush stripe batch size
  md/raid5: sort bios

 drivers/md/raid5-cache.c |   2 +-
 drivers/md/raid5.c       | 189 ++++++++++++++++++++++++++++++++++++++---------
 drivers/md/raid5.h       |  13 +++-
 3 files changed, 169 insertions(+), 35 deletions(-)

-- 
2.9.3

