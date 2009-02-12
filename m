From: NeilBrown <neilb@suse.de>
Subject: [PATCH 02/18] md: write bitmap information to devices that are
	undergoing recovery.
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031010.23983.53597.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When we add some spares to an array and start recovery, and with have
a bitmap which is stored 'internally' on all devices, we call
bitmap_write_all to make sure the bitmap is correct on the new
device(s).
However that doesn't work as write_sb_page only writes to
'In_sync' devices, and devices undergoing recovery are not
'In_sync' until recovery finishes.

So extend write_sb_page (actually next_active_rdev) to include devices
that are under recovery.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index be29937..96a43bd 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -265,7 +265,6 @@ static mdk_rdev_t *next_active_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 	list_for_each_continue_rcu(pos, &mddev->disks) {
 		rdev = list_entry(pos, mdk_rdev_t, same_set);
 		if (rdev->raid_disk >= 0 &&
-		    test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags)) {
 			/* this is a usable devices */
 			atomic_inc(&rdev->nr_pending);


