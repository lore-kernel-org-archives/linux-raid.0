From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/22] md: add honouring of suspend_{lo,hi} to raid1.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.28593.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This will allow us to stop writeout to portions of the array
while  they are resynced by someone else - e.g. another node in
a cluster.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e07ce2e..35b2d86 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -801,6 +801,25 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 	md_write_start(mddev, bio); /* wait on superblock update early */
 
+	if (bio_data_dir(bio) == WRITE &&
+	    bio->bi_sector + bio->bi_size/512 > mddev->suspend_lo &&
+	    bio->bi_sector < mddev->suspend_hi) {
+		/* As the suspend_* range is controlled by
+		 * userspace, we want an interruptible
+		 * wait.
+		 */
+		DEFINE_WAIT(w);
+		for (;;) {
+			flush_signals(current);
+			prepare_to_wait(&conf->wait_barrier,
+					&w, TASK_INTERRUPTIBLE);
+			if (bio->bi_sector + bio->bi_size/512 <= mddev->suspend_lo ||
+			    bio->bi_sector >= mddev->suspend_hi)
+				break;
+			schedule();
+		}
+		finish_wait(&conf->wait_barrier, &w);
+	}
 	if (unlikely(!mddev->barriers_work &&
 		     bio_rw_flagged(bio, BIO_RW_BARRIER))) {
 		if (rw == WRITE)
@@ -2271,6 +2290,9 @@ static void raid1_quiesce(mddev_t *mddev, int state)
 	conf_t *conf = mddev->private;
 
 	switch(state) {
+	case 2: /* wake for suspend */
+		wake_up(&conf->wait_barrier);
+		break;
 	case 1:
 		raise_barrier(conf);
 		break;


