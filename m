From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/9] replace printk() with pr_*()
Date: Wed, 02 Nov 2016 14:16:48 +1100
Message-ID: <147805657658.23566.1748253447749986766.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This series removes all printk() calls from md code, preferring
pr_warn(), pr_err() etc.

All strings that were split over multiple lines are not joined
back together because being able to search for a message is more
important that not having long lines in the code.
Lots of printk(KERN_DEBUG... are not pr_debug() which means the
messages won't get printed unless they are explicitly disabled.

I included some rough guidelines on which pr_* to choose in md.c.
Many things became pr_debug(), most of the rest are pr_warn().
pr_err() and pr_crit() are used sparingly.

I simplified some code in multipath.c too.

A particular benefit of this is that the various "print_conf()"
functions are not silent by default.
On very large arrays (raid10 with hundreds of devices), these can
be very noisy.

---

NeilBrown (9):
      md: fix some issues with alloc_disk_sb()
      md: change all printk() to pr_err() or pr_warn() etc.
      md/bitmap: change all printk() to pr_*()
      md/linear: replace printk() with pr_*()
      md/multipath: replace printk() with pr_*()
      md/raid0: replace printk() with pr_*()
      md/raid1: change printk() to pr_*()
      md/raid10: change printk() to pr_*()
      md/raid5: change printk() to pr_*()


 drivers/md/bitmap.c    |  107 ++++++-------
 drivers/md/linear.c    |   13 +-
 drivers/md/md.c        |  409 +++++++++++++++++++++---------------------------
 drivers/md/multipath.c |   90 ++++-------
 drivers/md/raid0.c     |   89 +++++-----
 drivers/md/raid1.c     |   99 +++++-------
 drivers/md/raid10.c    |  141 +++++++----------
 drivers/md/raid5.c     |  207 ++++++++++--------------
 8 files changed, 495 insertions(+), 660 deletions(-)

--
Signature

