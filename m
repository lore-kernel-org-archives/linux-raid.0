From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/4] md: raid1-10: Unify r{1,10}bio_pool_free
Date: Mon, 20 May 2019 18:44:24 -0300
Message-ID: <20190520214427.18729-2-marcos.souza.org@gmail.com>
References: <20190520214427.18729-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520214427.18729-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Avoiding duplicated code, since they just execute a kfree.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/raid1-10.c |  5 +++++
 drivers/md/raid1.c    | 13 ++++---------
 drivers/md/raid10.c   | 11 +++--------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 7d968bf08e54..54db34163968 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -34,6 +34,11 @@ struct resync_pages {
 	struct page	*pages[RESYNC_PAGES];
 };
 
+static void rbio_pool_free(void *rbio, void *data)
+{
+	kfree(rbio);
+}
+
 static inline int resync_alloc_pages(struct resync_pages *rp,
 				     gfp_t gfp_flags)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bb052c35bf29..3787c7e45849 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -76,11 +76,6 @@ static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 	return kzalloc(size, gfp_flags);
 }
 
-static void r1bio_pool_free(void *r1_bio, void *data)
-{
-	kfree(r1_bio);
-}
-
 #define RESYNC_DEPTH 32
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 #define RESYNC_WINDOW (RESYNC_BLOCK_SIZE * RESYNC_DEPTH)
@@ -156,7 +151,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	kfree(rps);
 
 out_free_r1bio:
-	r1bio_pool_free(r1_bio, data);
+	rbio_pool_free(r1_bio, data);
 	return NULL;
 }
 
@@ -176,7 +171,7 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 	/* resync pages array stored in the 1st bio's .bi_private */
 	kfree(rp);
 
-	r1bio_pool_free(r1bio, data);
+	rbio_pool_free(r1bio, data);
 }
 
 static void put_all_bios(struct r1conf *conf, struct r1bio *r1_bio)
@@ -2931,7 +2926,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
 	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   r1bio_pool_free, conf->poolinfo);
+			   rbio_pool_free, conf->poolinfo);
 	if (err)
 		goto abort;
 
@@ -3216,7 +3211,7 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->raid_disks = raid_disks * 2;
 
 	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   r1bio_pool_free, newpoolinfo);
+			   rbio_pool_free, newpoolinfo);
 	if (ret) {
 		kfree(newpoolinfo);
 		return ret;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 24cb116d950f..c0d9ee4311d4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -107,11 +107,6 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 	return kzalloc(size, gfp_flags);
 }
 
-static void r10bio_pool_free(void *r10_bio, void *data)
-{
-	kfree(r10_bio);
-}
-
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 /* amount of memory to reserve for resync requests */
 #define RESYNC_WINDOW (1024*1024)
@@ -217,7 +212,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	}
 	kfree(rps);
 out_free_r10bio:
-	r10bio_pool_free(r10_bio, conf);
+	rbio_pool_free(r10_bio, conf);
 	return NULL;
 }
 
@@ -245,7 +240,7 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 	/* resync pages array stored in the 1st bio's .bi_private */
 	kfree(rp);
 
-	r10bio_pool_free(r10bio, conf);
+	rbio_pool_free(r10bio, conf);
 }
 
 static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
@@ -3660,7 +3655,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	conf->geo = geo;
 	conf->copies = copies;
 	err = mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_alloc,
-			   r10bio_pool_free, conf);
+			   rbio_pool_free, conf);
 	if (err)
 		goto out;
 
-- 
2.21.0
