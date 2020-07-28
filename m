From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 0/5] misc patches for md
Date: Tue, 28 Jul 2020 12:01:38 +0200
Message-ID: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi,

Please review the patchset which has quite small change, :).

Thanks,
Guoqing

Guoqing Jiang (5):
  md: register new md sysfs file 'uuid' read-only
  md/raid5: remove the redundant setting of STRIPE_HANDLE
  md: print errno in super_written
  raid5-cache: hold spinlock instead of mutex in r5c_journal_mode_show
  raid5: don't duplicate code for different paths in handle_stripe

 Documentation/admin-guide/md.rst |  4 ++++
 drivers/md/md.c                  | 12 +++++++++++-
 drivers/md/raid5-cache.c         |  9 +++------
 drivers/md/raid5.c               | 17 +++++------------
 4 files changed, 23 insertions(+), 19 deletions(-)

-- 
2.17.1
