From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 0/5] misc cleanups for RAID5
Date: Wed, 22 Jun 2011 13:50:25 +0900
Message-ID: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

These are assorted cleanup patches for RAID5 code.
Please take a look. Any comments are welcomed.

Thanks.


Namhyung Kim (5):
  md/raid5: use kmem_cache_zalloc()
  md/raid5: factor out dev_need_read()
  md/raid5: factor out dev_need_for_write()
  md/raid5: use r5_for_each_bio()
  md/raid5: get rid of duplicated call to bio_data_dir()

 drivers/md/raid5.c |  146 ++++++++++++++++++++++++++--------------------------
 1 files changed, 73 insertions(+), 73 deletions(-)

-- 
1.7.5.2

