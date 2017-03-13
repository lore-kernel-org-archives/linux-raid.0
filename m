From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/r5cache: fix set_syndrome_sources()
Date: Mon, 13 Mar 2017 13:44:35 -0700
Message-ID: <20170313204435.1732089-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

With srctype == SYNDROME_SRC_WRITTEN, we need include both
dev with non-null ->written and dev with R5_InJournal.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1c554a8..88cc898 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1499,7 +1499,8 @@ static int set_syndrome_sources(struct page **srcs,
 		     (test_bit(R5_Wantdrain, &dev->flags) ||
 		      test_bit(R5_InJournal, &dev->flags))) ||
 		    (srctype == SYNDROME_SRC_WRITTEN &&
-		     dev->written)) {
+		     (dev->written ||
+		      test_bit(R5_InJournal, &dev->flags)))) {
 			if (test_bit(R5_InJournal, &dev->flags))
 				srcs[slot] = sh->dev[i].orig_page;
 			else
-- 
2.9.3

