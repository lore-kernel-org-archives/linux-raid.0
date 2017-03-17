From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCH 1/2] super1: ignore failfast flag for setting device role
Date: Fri, 17 Mar 2017 17:47:01 +0100
Message-ID: <1489769222-31855-2-git-send-email-gi-oh.kim@profitbricks.com>
References: <1489769222-31855-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489769222-31855-1-git-send-email-gi-oh.kim@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

There is corner case for setting device role,
if new device has failfast flag.
The failfast flag should be ignored.

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 super1.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index 882cd61..1da33ef 100644
--- a/super1.c
+++ b/super1.c
@@ -1491,6 +1491,7 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	struct devinfo *di, **dip;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 	int rv, lockid;
+	int dk_state;
 
 	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
 		rv = cluster_get_dlmlock(&lockid);
@@ -1501,11 +1502,12 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 		}
 	}
 
-	if ((dk->state & 6) == 6) /* active, sync */
+	dk_state &= ~(1<<MD_DISK_FAILFAST);
+	if ((dk_state & 6) == 6) /* active, sync */
 		*rp = __cpu_to_le16(dk->raid_disk);
-	else if (dk->state & (1<<MD_DISK_JOURNAL))
+	else if (dk_state & (1<<MD_DISK_JOURNAL))
                 *rp = MD_DISK_ROLE_JOURNAL;
-	else if ((dk->state & ~2) == 0) /* active or idle -> spare */
+	else if ((dk_state & ~2) == 0) /* active or idle -> spare */
 		*rp = MD_DISK_ROLE_SPARE;
 	else
 		*rp = MD_DISK_ROLE_FAULTY;
-- 
2.5.0

