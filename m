From: NeilBrown <neilb@suse.de>
Subject: [PATCH 5/5] md/raid1: update next_resync under resync_lock.
Date: Wed, 10 Sep 2014 16:20:45 +1000
Message-ID: <20140910062044.26400.51324.stgit@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140910062039.26400.36745.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

raise_barrier() uses next_resync as part of its calculations, so it
really should be updated first, instead of afterwards.

next_resync is always used under  resync_lock so update it under
resync lock to, just before it is used.  That is safest.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 08a6989fcff6..53e163d31750 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -827,7 +827,7 @@ static void flush_pending_writes(struct r1conf *conf)
  *    there is no normal IO happeing.  It must arrange to call
  *    lower_barrier when the particular background IO completes.
  */
-static void raise_barrier(struct r1conf *conf)
+static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	spin_lock_irq(&conf->resync_lock);
 
@@ -837,6 +837,7 @@ static void raise_barrier(struct r1conf *conf)
 
 	/* block any new IO from starting */
 	conf->barrier++;
+	conf->next_resync = sector_nr;
 
 	/* For these conditions we must wait:
 	 * A: while the array is in frozen state
@@ -2542,9 +2543,8 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 	r1_bio = mempool_alloc(conf->r1buf_pool, GFP_NOIO);
-	raise_barrier(conf);
 
-	conf->next_resync = sector_nr;
+	raise_barrier(conf, sector_nr);
 
 	rcu_read_lock();
 	/*


