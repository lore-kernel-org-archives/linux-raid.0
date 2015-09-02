From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/8] raid5-cache fixes
Date: Wed, 2 Sep 2015 13:49:43 -0700
Message-ID: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Fix some bugs, improve performance and add trim/resync support.

Thanks,
Shaohua

Christoph Hellwig (1):
  raid5-cache: move functionality out of __r5l_set_io_unit_state

Shaohua Li (7):
  md: fix feature map check
  raid5: fix build error
  raid5-cache: switching to state machine for log disk cache flush
  raid5-cache: fix a user-after-free bug
  raid5-cache: optimize FLUSH IO with log enabled
  md: skip resync for raid array with journal
  raid5-cache: add trim support for log

 drivers/md/md.c          |   6 +-
 drivers/md/md.h          |   1 +
 drivers/md/raid5-cache.c | 254 ++++++++++++++++++++++++++++-------------------
 drivers/md/raid5.c       |  17 +++-
 drivers/md/raid5.h       |   1 +
 5 files changed, 175 insertions(+), 104 deletions(-)

-- 
1.8.1

