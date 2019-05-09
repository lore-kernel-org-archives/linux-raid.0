From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] drivers: md: Unify common definitions of raid1 and raid10
Date: Thu,  9 May 2019 08:18:49 -0300
Message-ID: <20190509111849.22927-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: neilb@suse.com, Marcos Paulo de Souza <marcos.souza.org@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

These definitions are being moved to raid1-10.c.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/raid1-10.c | 25 +++++++++++++++++++++++++
 drivers/md/raid1.c    | 29 ++---------------------------
 drivers/md/raid10.c   | 27 +--------------------------
 3 files changed, 28 insertions(+), 53 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 400001b815db..7d968bf08e54 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -3,6 +3,31 @@
 #define RESYNC_BLOCK_SIZE (64*1024)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 
+/*
+ * Number of guaranteed raid bios in case of extreme VM load:
+ */
+#define	NR_RAID_BIOS 256
+
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio *)1)
+/* When we successfully write to a known bad-block, we need to remove the
+ * bad-block marking which must be done from process context.  So we record
+ * the success by setting devs[n].bio to IO_MADE_GOOD
+ */
+#define IO_MADE_GOOD ((struct bio *)2)
+
+#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
+
+/* When there are this many requests queue to be written by
+ * the raid thread, we become 'congested' to provide back-pressure
+ * for writeback.
+ */
+static int max_queued_requests = 1024;
+
 /* for managing resync I/O pages */
 struct resync_pages {
 	void		*raid_bio;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0c8a098d220e..bb052c35bf29 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -50,31 +50,6 @@
 	 (1L << MD_HAS_PPL) |		\
 	 (1L << MD_HAS_MULTIPLE_PPLS))
 
-/*
- * Number of guaranteed r1bios in case of extreme VM load:
- */
-#define	NR_RAID1_BIOS 256
-
-/* when we get a read error on a read-only array, we redirect to another
- * device without failing the first device, or trying to over-write to
- * correct the read error.  To keep track of bad blocks on a per-bio
- * level, we store IO_BLOCKED in the appropriate 'bios' pointer
- */
-#define IO_BLOCKED ((struct bio *)1)
-/* When we successfully write to a known bad-block, we need to remove the
- * bad-block marking which must be done from process context.  So we record
- * the success by setting devs[n].bio to IO_MADE_GOOD
- */
-#define IO_MADE_GOOD ((struct bio *)2)
-
-#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
-
-/* When there are this many requests queue to be written by
- * the raid1 thread, we become 'congested' to provide back-pressure
- * for writeback.
- */
-static int max_queued_requests = 1024;
-
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
 
@@ -2955,7 +2930,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->poolinfo)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-	err = mempool_init(&conf->r1bio_pool, NR_RAID1_BIOS, r1bio_pool_alloc,
+	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
 			   r1bio_pool_free, conf->poolinfo);
 	if (err)
 		goto abort;
@@ -3240,7 +3215,7 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->mddev = mddev;
 	newpoolinfo->raid_disks = raid_disks * 2;
 
-	ret = mempool_init(&newpool, NR_RAID1_BIOS, r1bio_pool_alloc,
+	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
 			   r1bio_pool_free, newpoolinfo);
 	if (ret) {
 		kfree(newpoolinfo);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3b6880dd648d..24cb116d950f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -73,31 +73,6 @@
  *    [B A] [D C]    [B A] [E C D]
  */
 
-/*
- * Number of guaranteed r10bios in case of extreme VM load:
- */
-#define	NR_RAID10_BIOS 256
-
-/* when we get a read error on a read-only array, we redirect to another
- * device without failing the first device, or trying to over-write to
- * correct the read error.  To keep track of bad blocks on a per-bio
- * level, we store IO_BLOCKED in the appropriate 'bios' pointer
- */
-#define IO_BLOCKED ((struct bio *)1)
-/* When we successfully write to a known bad-block, we need to remove the
- * bad-block marking which must be done from process context.  So we record
- * the success by setting devs[n].bio to IO_MADE_GOOD
- */
-#define IO_MADE_GOOD ((struct bio *)2)
-
-#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
-
-/* When there are this many requests queued to be written by
- * the raid10 thread, we become 'congested' to provide back-pressure
- * for writeback.
- */
-static int max_queued_requests = 1024;
-
 static void allow_barrier(struct r10conf *conf);
 static void lower_barrier(struct r10conf *conf);
 static int _enough(struct r10conf *conf, int previous, int ignore);
@@ -3684,7 +3659,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	conf->geo = geo;
 	conf->copies = copies;
-	err = mempool_init(&conf->r10bio_pool, NR_RAID10_BIOS, r10bio_pool_alloc,
+	err = mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_alloc,
 			   r10bio_pool_free, conf);
 	if (err)
 		goto out;
-- 
2.21.0
