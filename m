From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 11/15] md/raid5: don't test ->writes_pending in
 raid5_remove_disk
Date: Wed, 15 Mar 2017 14:05:14 +1100
Message-ID: <148954711407.18641.13319777867112915321.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

This test on ->writes_pending cannot be safe as the counter
can be incremented at any moment and cannot be locked against.

Change it to test conf->active_stripes, which at least
can be locked against.  More changes are still needed.

A future patch will change ->writes_pending, and testing it here will
be very inconvenient.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4e906e5903e8..5eb3764bafd3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7528,9 +7528,12 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		/*
 		 * we can't wait pending write here, as this is called in
 		 * raid5d, wait will deadlock.
+		 * neilb: there is no locking about new writes here,
+		 * so this cannot be safe.
 		 */
-		if (atomic_read(&mddev->writes_pending))
+		if (atomic_read(&conf->active_stripes)) {
 			return -EBUSY;
+		}
 		log_exit(conf);
 		return 0;
 	}


