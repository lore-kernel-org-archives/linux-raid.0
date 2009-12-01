From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] room for one more md patch in 2.6.32??
Date: Tue, 1 Dec 2009 17:55:55 +1100
Message-ID: <19220.48635.156324.840990@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus / Greg,
 While reading code I found a bug in raid1 that can cause it handle
 read errors poorly.  It can sometimes report an error to the
 filesystem when it shouldn't have done.
 This bug was introduced in 2.6.29 and the patch is suitable for any
 -stable since then that it still active.

thanks,
NeilBrown


The following changes since commit a9366e61b03f55a6e009e687ad10e706714c9907:
  Linus Torvalds (1):
        Merge git://git.infradead.org/users/dwmw2/iommu-2.6.32

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      md: revert incorrect fix for read error handling in raid1.

 drivers/md/raid1.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)



From d0e260782c3702a009645c3caa02e381dab8798b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 1 Dec 2009 17:30:59 +1100
Subject: [PATCH] md: revert incorrect fix for read error handling in raid1.

commit 4706b349f was a forward port of a fix that was needed
for SLES10.  But in fact it is not needed in mainline because
the earlier commit dd00a99e7a fixes the same problem in a
better way.
Further, this commit introduces a bug in the way it interacts with
the automatic read-error-correction.  If, after a read error is
successfully corrected, the same disk is chosen to re-read - the
re-read won't be attempted but an error will be returned instead.

After reverting that commit, there is the possibility that a
read error on a read-only array (where read errors cannot
be corrected as that requires a write) will repeatedly read the same
device and continue to get an error.
So in the "Array is readonly" case, fail the drive immediately on
a read error.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: stable@kernel.org
---
 drivers/md/raid1.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a053423..e07ce2e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1650,11 +1650,12 @@ static void raid1d(mddev_t *mddev)
 					       r1_bio->sector,
 					       r1_bio->sectors);
 				unfreeze_array(conf);
-			}
+			} else
+				md_error(mddev,
+					 conf->mirrors[r1_bio->read_disk].rdev);
 
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=read_balance(conf, r1_bio)) == -1 ||
-			    disk == r1_bio->read_disk) {
+			if ((disk=read_balance(conf, r1_bio)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       bdevname(bio->bi_bdev,b),
-- 
1.6.4.3

