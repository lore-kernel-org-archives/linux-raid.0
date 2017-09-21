From: Shaohua Li <shli@kernel.org>
Subject: [PATCH 0/3] md: retry bailed bio
Date: Thu, 21 Sep 2017 10:42:56 -0700
Message-ID: <cover.1506015297.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

With cc27b0c78c79(md: fix deadlock between mddev_suspend() and
md_write_start()), pers->make_request could bail out without handling the bio.
If that happens, we should retry. There are two call sites we don't do the
retry and cause problems. This set fixes the issues.

Thanks,
Shaohua

Shaohua Li (3):
  md: separate request handling
  md: fix a race condition for flush request handling
  dm-raid: fix a race condition in request handling

 drivers/md/dm-raid.c |  2 +-
 drivers/md/md.c      | 72 +++++++++++++++++++++++++++++++---------------------
 drivers/md/md.h      |  1 +
 3 files changed, 45 insertions(+), 30 deletions(-)

-- 
2.11.0

