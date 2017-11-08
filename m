From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 1/2] md: release allocated bitset sync_set
Date: Wed,  8 Nov 2017 13:44:55 +0100
Message-ID: <83671199e7b9095fece2671521b7a34ad5d92b0a.1510144853.git.zkabelac@redhat.com>
References: <cover.1510144853.git.zkabelac@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1510144853.git.zkabelac@redhat.com>
In-Reply-To: <cover.1510144853.git.zkabelac@redhat.com>
References: <cover.1510144853.git.zkabelac@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: linux-raid.ids

Patch fixes kmemleak on md_stop() path used likely only by dm-raid
wrapper. Code of md is using  mddev_put() where both  bitsets
are released however this bitmap freeing is not shared.

Also set NULL to bio_set and sync_set pointers just like mddev_put is
doing.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf6c90e..635ad7c38f67 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5834,8 +5834,14 @@ void md_stop(struct mddev *mddev)
 	 * This is called from dm-raid
 	 */
 	__md_stop(mddev);
-	if (mddev->bio_set)
+	if (mddev->bio_set) {
 		bioset_free(mddev->bio_set);
+		mddev->bio_set = NULL;
+	}
+	if (mddev->sync_set) {
+		bioset_free(mddev->sync_set);
+		mddev->sync_set = NULL;
+	}
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
-- 
2.15.0

