From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/23] md/raid1,
 raid10: avoid deadlock during resync/recovery.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.74857.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If RAID1 or RAID10 is used under LVM or some other stacking
block device, it is possible to enter a deadlock during
resync or recovery.
This can happen if the upper level block device creates
two requests to the RAID1 or RAID10.  The first request gets
processed, blocks recovery and queue requests for underlying
requests in current->bio_list.  A resync request then starts
which will wait for those requests and block new IO.

But then the second request to the RAID1/10 will be attempted
and it cannot progress until the resync request completes,
which cannot progress until the underlying device requests complete,
which are on a queue behind that second request.

So allow that second request to proceed even though there is
a resync request about to start.

This is suitable for any -stable kernel.

Cc: stable@vger.kernel.org
Reported-by: Ray Morris <support@bettercgi.com>
Tested-by: Ray Morris <support@bettercgi.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c  |   17 +++++++++++++++--
 drivers/md/raid10.c |   17 +++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cb04d56..3309de7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -737,9 +737,22 @@ static void wait_barrier(struct r1conf *conf)
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		conf->nr_waiting++;
-		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
+		/* Wait for the barrier to drop.
+		 * However if there are already pending
+		 * requests (preventing the barrier from
+		 * rising completely), and the
+		 * pre-process bio queue isn't empty,
+		 * then don't wait, as we need to empty
+		 * that queue to get the nr_pending
+		 * count down.
+		 */
+		wait_event_lock_irq(conf->wait_barrier,
+				    !conf->barrier ||
+				    (conf->nr_pending &&
+				     current->bio_list &&
+				     !bio_list_empty(current->bio_list)),
 				    conf->resync_lock,
-				    );
+			);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ca1ea25..e0c5a88 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -863,9 +863,22 @@ static void wait_barrier(struct r10conf *conf)
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		conf->nr_waiting++;
-		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
+		/* Wait for the barrier to drop.
+		 * However if there are already pending
+		 * requests (preventing the barrier from
+		 * rising completely), and the
+		 * pre-process bio queue isn't empty,
+		 * then don't wait, as we need to empty
+		 * that queue to get the nr_pending
+		 * count down.
+		 */
+		wait_event_lock_irq(conf->wait_barrier,
+				    !conf->barrier ||
+				    (conf->nr_pending &&
+				     current->bio_list &&
+				     !bio_list_empty(current->bio_list)),
 				    conf->resync_lock,
-				    );
+			);
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;


