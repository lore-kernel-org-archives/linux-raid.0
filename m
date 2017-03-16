From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/2] md/raid5: Add change_consistency_policy to raid4 and raid6
Date: Thu, 16 Mar 2017 15:14:08 -0700
Message-ID: <20170316221409.3283344-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Add change_consistency_policy to raid6_personality and
raid4_personality.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 88cc898..7a6e7ea 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8408,6 +8408,7 @@ static struct md_personality raid6_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.congested	= raid5_congested,
+	.change_consistency_policy = raid5_change_consistency_policy,
 };
 static struct md_personality raid5_personality =
 {
@@ -8456,6 +8457,7 @@ static struct md_personality raid4_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
 	.congested	= raid5_congested,
+	.change_consistency_policy = raid5_change_consistency_policy,
 };
 
 static int __init raid5_init(void)
-- 
2.9.3

