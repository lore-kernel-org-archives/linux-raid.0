From: Jes.Sorensen@redhat.com
Subject: [PATCH v2] Avoid OOPS when reshaping raid1 to raid0
Date: Mon, 26 Mar 2012 10:31:25 +0200
Message-ID: <1332750685-31643-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

raid1 arrays do not have the notion of chunk size. Calculate the
larges chunk sector size we can use to avoid a divide by zero OOPS
when aligning the size of the new array to the chunk size.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid0.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f31f55..3ac9757 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -625,6 +625,7 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 static void *raid0_takeover_raid1(struct mddev *mddev)
 {
 	struct r0conf *priv_conf;
+	int chunksect;
 
 	/* Check layout:
 	 *  - (N - 1) mirror drives must be already faulty
@@ -635,10 +636,25 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
+	/*
+	 * a raid1 doesn't have the notion of chunk size, so
+	 * figure out the largest suitable size we can use.
+	 */
+	chunksect = 64 * 2; /* 64K by default */
+
+	/* The array must be an exact multiple of chunksize */
+	while (chunksect && (mddev->array_sectors & (chunksect - 1)))
+		chunksect >>= 1;
+
+	if ((chunksect << 9) < PAGE_SIZE)
+		/* array size does not allow a suitable chunk size */
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = 128; /* by default set chunk size to 64k */
+	mddev->chunk_sectors = chunksect;
 	mddev->delta_disks = 1 - mddev->raid_disks;
 	mddev->raid_disks = 1;
 	/* make sure it will be not marked as dirty */
-- 
1.7.7.6

