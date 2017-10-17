From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/5] Address deadlock associated with setting suspend_lo
Date: Tue, 17 Oct 2017 13:46:43 +1100
Message-ID: <150820826980.1646.6380214598725492144.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This series fixes the issue that Xiao Ni found
where a deadlock can happen if there are active writes
to an md/raid5 waiting for suspend_lo to be increased.

The last patch contains the important fix.  The others
prepare for it so that it can work reliably.

Thanks,
NeilBrown

---

NeilBrown (5):
      md: always hold reconfig_mutex when calling mddev_suspend()
      md: don't call bitmap_create() while array is quiesced.
      md: move suspend_hi/lo handling into core md code
      md: use mddev_suspend/resume instead of ->quiesce()
      md: allow metadata update while suspending.


 drivers/md/dm-raid.c     |    5 ++-
 drivers/md/md.c          |   74 ++++++++++++++++++++++++++++++++++------------
 drivers/md/md.h          |    6 ++++
 drivers/md/raid1.c       |   12 ++-----
 drivers/md/raid5-cache.c |   18 ++++++++---
 drivers/md/raid5.c       |   22 --------------
 6 files changed, 82 insertions(+), 55 deletions(-)

--
Signature

