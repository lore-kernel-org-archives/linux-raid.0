From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 26/36] md/raid10 - avoid reading from known bad blocks -
 part 3
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.64849.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When attempting to repair a read error, don't read from
devices with a known bad block.

As we are only reading PAGE_SIZE blocks, we don't try to
narrow down to smaller regions in the hope that only part of this
page is bad - it isn't worth the effort.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0dcd172..47e6959 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1594,10 +1594,15 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 
 		rcu_read_lock();
 		do {
+			sector_t first_bad;
+			int bad_sectors;
+
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
+			    test_bit(In_sync, &rdev->flags) &&
+			    is_badblock(rdev, r10_bio->devs[sl].addr + sect, s,
+					&first_bad, &bad_sectors) == 0) {
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				success = sync_page_io(rdev,


