From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/28] md: add support for raid5 to raid4 conversion
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.80043.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is unlikely to be wanted, but we may as well provide it
for completeness.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bb28fd6..020143d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5788,6 +5788,18 @@ static void *raid5_takeover(mddev_t *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
+static void *raid4_takeover(mddev_t *mddev)
+{
+	/* raid4 can take over raid5 if layout is right.
+	 */
+	if (mddev->level == 5 &&
+	    mddev->layout == ALGORITHM_PARITY_N) {
+		mddev->new_layout = 0;
+		mddev->new_level = 4;
+		return setup_conf(mddev);
+	}
+	return ERR_PTR(-EINVAL);
+}
 
 static struct mdk_personality raid5_personality;
 
@@ -5903,6 +5915,7 @@ static struct mdk_personality raid4_personality =
 	.start_reshape  = raid5_start_reshape,
 	.finish_reshape = raid5_finish_reshape,
 	.quiesce	= raid5_quiesce,
+	.takeover	= raid4_takeover,
 };
 
 static int __init raid5_init(void)


