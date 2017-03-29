From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCH 1/2] super1: replace hard-coded values with bit definitions
Date: Wed, 29 Mar 2017 11:40:33 +0200
Message-ID: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: linux-raid.ids

Some hard-coded values for disk status are replaced
with bit definitions.

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 super1.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index f3520ac..e8b9f61 100644
--- a/super1.c
+++ b/super1.c
@@ -1010,7 +1010,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 		info->disk.state = 0; /* spare: not active, not sync, not faulty */
 		break;
 	case MD_DISK_ROLE_FAULTY:
-		info->disk.state = 1; /* faulty */
+		info->disk.state = (1 << MD_DISK_FAULTY); /* faulty */
 		break;
 	case MD_DISK_ROLE_JOURNAL:
 		info->disk.state = (1 << MD_DISK_JOURNAL);
@@ -1503,11 +1503,12 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	}
 
 	dk_state = dk->state & ~(1<<MD_DISK_FAILFAST);
-	if ((dk_state & 6) == 6) /* active, sync */
+	if ((dk_state & (1<<MD_DISK_ACTIVE)) &&
+	    (dk_state & (1<<MD_DISK_SYNC)))/* active, sync */
 		*rp = __cpu_to_le16(dk->raid_disk);
 	else if (dk_state & (1<<MD_DISK_JOURNAL))
                 *rp = MD_DISK_ROLE_JOURNAL;
-	else if ((dk_state & ~2) == 0) /* active or idle -> spare */
+	else if ((dk_state & ~(1<<MD_DISK_ACTIVE)) == 0) /* active or idle -> spare */
 		*rp = MD_DISK_ROLE_SPARE;
 	else
 		*rp = MD_DISK_ROLE_FAULTY;
-- 
2.5.0

