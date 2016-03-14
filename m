From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 0/3] md: trivial changes
Date: Mon, 14 Mar 2016 17:01:36 +0800
Message-ID: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Hi,

I found some trivial issues when look into md code, and
all the changes are based on for-next branch of new md
tree.

Thanks,
Guoqing

Guoqing Jiang (3):
  md/raid1: remove unnecessary BUG_ON
  md/bitmap: remove redundant return in bitmap_checkpage
  md: fix typos for stipe

 drivers/md/bitmap.c | 1 -
 drivers/md/bitmap.h | 4 ++--
 drivers/md/raid1.c  | 1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.6.2

