From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 00/18] Assorted minor fixes, particularly RCU protection.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The 'rdev' fields in each personality's config data are often accessed
under rcu_read_lock() protection to avoid races with
->hot_remove_disk() removing the rdev.

Originally this was not necessary during resync/recovery etc because
->hot_remove_disk() was only called from md_check_recovery(), and it
would only make the call if there was no resync etc happening.

However we now call ->hot_remove_disk() (from
remove_and_add_spares()) from other contexts, so there could be a race
in the resync code.

So this patch set adds a lot of extra rcu_read_lock protection and
clean up some other bits and pieces on the way.

My goal was the final patch.  If you have a large raid10 array and
fail half of the devices at once (e.g. unplug a rack with half of the
mirrors) then synchronize_rcu() will be called once for each device,
which can add up to a big delay.  A single call should suffice.
The final patch makes that change.

Thanks,
NeilBrown
---

NeilBrown (18):
      md: disconnect device from personality before trying to remove it.
      md/raid1,raid10: don't recheck "Faulty" flag in read-balance.
      md/raid10: fix refounct imbalance when resyncing an array with a replacement device.
      md/raid10: add rcu protection in raid10_status.
      md/raid10: add rcu protection to rdev access in raid10_sync_request.
      md/raid10: add rcu protection to rdev access during reshape.
      md/raid10: minor code improvement in fix_read_error()
      md/raid10: simplify print_conf a little.
      md/raid10: stop print_conf from being too verbose.
      md/raid1: small cleanup in raid1_end_read/write_request
      md/raid1: small code cleanup in end_sync_write
      md/raid1: add rcu protection to rdev in fix_read_error
      md/raid5: add rcu protection to rdev accesses in handle_failed_sync.
      md/raid5: add rcu protection to rdev accesses in want_replace
      md/raid5: add rcu protection to rdev accesses in raid5_status.
      md/multipath: add rcu protection to rdev access in multipath_status.
      md: be extra careful not to take a reference to a Faulty device.
      md: reduce the number of synchronize_rcu() calls when multiple devices fail.


 drivers/md/md.c        |   29 ++++++-
 drivers/md/md.h        |    5 +
 drivers/md/multipath.c |   29 ++++---
 drivers/md/raid1.c     |  125 ++++++++++++++--------------
 drivers/md/raid10.c    |  213 +++++++++++++++++++++++++++++-------------------
 drivers/md/raid5.c     |   41 ++++++---
 6 files changed, 264 insertions(+), 178 deletions(-)

--
Signature

