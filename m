From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/3] raid5-cache fixes
Date: Wed, 30 Sep 2015 16:15:37 -0700
Message-ID: <cover.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Neil,

These are some fixes for raid5-cache. The first one fixes the issue related to
trim. The last two make raid5-cache support log device IO error.

Thanks,
Shaohua

Shaohua Li (3):
  raid5-cache: add trim support for log
  md: don't export log device
  raid5-cache: IO error handling

 drivers/md/md.c          |  4 ++--
 drivers/md/raid5-cache.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 4 deletions(-)

-- 
2.4.6

