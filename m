From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] A few more md patches for 2.6.26
Date: Tue, 29 Apr 2008 18:19:28 -0700
Message-ID: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

The first two patches add some necessary sysfs_notify calls for external
metadata arrays. They replace
md-ping-userspace-on-ext-metadata-events.patch which, as you noted, did
these notifications globally in md_check_recovery() rather than at the
local site where the state changes.

While testing these I ran into:

   WARNING: at include/linux/blkdev.h:443 queue_flag_clear+0x2c/0x4d()

...due to the recent "block: make queue flags non-atomic" (commit:
75ad23bc0fcb4f992a5d06982bf0857ab1738e9e).  I believe patch 3/3 is the
intended fix. 

---

Dan Williams (3):
      md: add new / required locking for calls to blk_remove_plug and blk_plug_queue
      md: ping userspace on 'stop' events
      md: ping userspace on 'write-pending' events


 drivers/md/md.c           |   25 +++++++++++++++++++++----
 drivers/md/raid1.c        |   10 ++++++++--
 drivers/md/raid10.c       |   10 ++++++++--
 drivers/md/raid5.c        |   12 ++++++++++--
 include/linux/raid/md_k.h |    3 +++
 5 files changed, 50 insertions(+), 10 deletions(-)

-- 
Regards,
Dan
