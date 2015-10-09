From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/9] raid5-cache fixes
Date: Thu, 8 Oct 2015 21:54:04 -0700
Message-ID: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi,

some fixes for raid5-cache/md. Mainly supports trim, handle IO error and
handling array assemble with missing/faulty disks.
patch 1: fix a bug
patch 2: support trim
patch 3-4, IO error handling
patch 5-9, handle assemble issue when journal disk is missing/faulty

If there is IO error to journal disk, write IO will fail immediately. If we
assemble an array with journal feature enabled but with journal disk
missing/faulty, the raid array will start readonly.

Thanks,
Shaohua

Shaohua Li (6):
  MD: fix info output for journal disk
  raid5-cache: add trim support for log
  raid5: journal disk can't be removed
  raid5-cache: IO error handling
  raid5-cache: start raid5 readonly if journal is missing
  MD: set journal disk ->raid_disk

Song Liu (3):
  MD: add new bit to indicate raid array with journal
  MD: kick out journal disk if it's not fresh
  MD: when RAID journal is missing/faulty, block RESTART_ARRAY_RW

 drivers/md/md.c          | 77 +++++++++++++++++++++++++++++++++++++---------
 drivers/md/md.h          |  1 +
 drivers/md/raid5-cache.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       | 29 ++++++++++++++++--
 drivers/md/raid5.h       |  2 ++
 5 files changed, 169 insertions(+), 19 deletions(-)

-- 
2.4.6

