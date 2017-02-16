From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 11/14] md/raid5: don't test ->writes_pending in
 raid5_remove_disk
Date: Thu, 16 Feb 2017 15:39:02 +1100
Message-ID: <148721994284.7521.6077023777175048763.stgit@noble>
References: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721992248.7521.17160361058957519076.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

This test on ->writes_pending cannot be safe as the counter
can be incremented at any moment and cannot be locked against.

Change it to test conf->active_stripes.  This allows read requests
to interfere so it might make removal of the journal device
harder, but it is safer.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c96fca2c6a98..4de03479cdce 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7279,10 +7279,14 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we can't wait pending write here, as this is called in
 		 * raid5d, wait will deadlock.
 		 */
-		if (atomic_read(&mddev->writes_pending))
+		lock_all_device_hash_locks_irq(conf);
+		if (atomic_read(&conf->active_stripes)) {
+			unlock_all_device_hash_locks_irq(conf);
 			return -EBUSY;
+		}
 		log = conf->log;
 		conf->log = NULL;
+		unlock_all_device_hash_locks_irq(conf);
 		synchronize_rcu();
 		r5l_exit_log(log);
 		return 0;


