From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/3] md: fix mddev->flags issues
Date: Thu, 8 Dec 2016 15:48:16 -0800
Message-ID: <cover.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

We had some places the mddev->flags are abused. Today I hit a reshape hang,
which is related to this issue.

Neil,

I will appreciate if you could review the patches before the merge window
start.

Thanks,
Shaohua


Shaohua Li (3):
  md: takeover should clear unrelated bits
  md: MD_RECOVERY_NEEDED is set for mddev->recovery
  md: separate flags for superblock changes

 drivers/md/bitmap.c      |   4 +-
 drivers/md/dm-raid.c     |   4 +-
 drivers/md/md.c          | 117 ++++++++++++++++++++++++-----------------------
 drivers/md/md.h          |  16 ++++---
 drivers/md/multipath.c   |   2 +-
 drivers/md/raid0.c       |   5 ++
 drivers/md/raid1.c       |  17 ++++---
 drivers/md/raid10.c      |  22 ++++-----
 drivers/md/raid5-cache.c |   6 +--
 drivers/md/raid5.c       |  32 +++++++------
 10 files changed, 121 insertions(+), 104 deletions(-)

-- 
2.9.3

