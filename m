From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/6] raid5-cache fixes
Date: Sun, 4 Oct 2015 09:20:10 -0700
Message-ID: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Hi,

some fixes for raid5-cache.
patch 1, a small fix
patch 2-3, move reclaim teardown to quiesce handling and add trim support. I
still need md_update_sb there and play the mddev_is_locked trick as the
reconfig_mutex is already hold at md stop. The md_update_sb probably can move
to md core later.
patch 4-6, add error handling. For patch 4, I still need the journal bit check
in in md core, otherwise there is no way to prevent 'echo remove > rdev/state'
to delete journal disk. For patch 6, I didn't change has_failed() yet. Handling
assemble with miss/failed log disk is still on going.

Next step is to make assemble correct with miss/failed log disk. This will need
kernel/utilities cooperation. Song and I are working on it.

Thanks,
Shaohua

Shaohua Li (6):
  md: show journal for journal disk in disk state sysfs
  raid5-cache: move reclaim stop to quiesce
  raid5-cache: add trim support for log
  md: don't export log device
  md: set In_Sync for log disk
  raid5-cache: IO error handling

 drivers/md/md.c          |  9 ++++--
 drivers/md/raid5-cache.c | 83 ++++++++++++++++++++++++++++++++++++++++--------
 drivers/md/raid5.c       |  7 +++-
 drivers/md/raid5.h       |  3 ++
 4 files changed, 85 insertions(+), 17 deletions(-)

-- 
2.4.6

