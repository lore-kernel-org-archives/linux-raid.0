From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v7 0/3] md/raid5: set STRIPE_SIZE as a configurable value
Date: Sat, 18 Jul 2020 05:29:06 -0400
Message-ID: <20200718092909.4020424-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

Hi, all

 For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5
 will issue each bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64.
 However, filesystem usually issue bio in the unit of 4KB. Then, RAID5 may
 waste resource of disk bandwidth.

 To solve the problem, this patchset try to set stripe_size as a configuare
 value. The default value is 4096. We will add a new sysfs entry and set it
 by writing a new value, likely:

 	echo 16384 > /sys/block/md1/md/stripe_size

 Normally, using default stripe_size can get better performance. So, NeilBrown
 have suggested just to fix the it as 4096. But, out test result shows that
 a big value of stripe_size may have better performance when size of issued
 IOs are mostly bigger than 4096. Thus, in this patchset, we still want to
 set stripe_size as a configurable value.

 This patchset just set STRIPE_SIZE as a configurable value for "PAGE_SIZE != 4096"
 system, likely arm64 with 'PAGE_SIZE=64KB'. It doesn't make any difference for 
 'PAGE_SIZE == 4096' system, likely x86.

 To save memory used by stripe_head, I will send the related optimiation patchset later. 

V7:
 * Just include configurable stripe_size strategy in this patchset.
 * Convert STRIPE_* to RAID_STRIPE_*(conf), without any effect for
   'PAGE_SIZE == 4096' system.
 * Make sysfs entry 'stripe_size' only read for 'PAGE_SIZE == 4096'
 * system.

V6:
 https://www.spinics.net/lists/raid/msg65018.html
 * Convert stripe_size and stripe_sectors from 'unsigned int' to
   'unsigned long' avoiding compiler warning.
 * Add a new member of stripes_per_page into r5conf, avoiding to
   compute each time.
 * Cover mddev->private with mddev_lock(mddev) for raid5_store/show_stripe_size().
 * Get rid of too many WARN_ON() and BUG_ON().
 * Unfold raid5_get_page_index() into raid5_get_dev_page() directly.


Yufen Yu (3):
  md/raid456: convert macro STRIPE_* to RAID5_STRIPE_*
  md/raid5: set default stripe_size as 4096
  md/raid5: support config stripe_size by sysfs entry

 drivers/md/raid5-cache.c |   8 +-
 drivers/md/raid5-ppl.c   |  11 +-
 drivers/md/raid5.c       | 302 ++++++++++++++++++++++++++-------------
 drivers/md/raid5.h       |  53 ++++---
 4 files changed, 246 insertions(+), 128 deletions(-)

-- 
2.25.4
