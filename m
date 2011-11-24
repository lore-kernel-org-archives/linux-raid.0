From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] md: Add ability for disable bad block management
Date: Thu, 24 Nov 2011 13:19:53 +0100
Message-ID: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When external metadata doesn't support BBM, mdadm cannot answer correctly
for BBM requests. It causes reshape process being stopped.

Add ability for external metadata /mdadm/ to disable BBM via sysfs.
md will ignore bad blocks as it is for metadata v0.90.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 drivers/md/md.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 266e82e..6591108 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2935,7 +2935,16 @@ static ssize_t bb_show(struct md_rdev *rdev, char *page)
 }
 static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len)
 {
-	int rv = badblocks_store(&rdev->badblocks, page, len, 0);
+	int rv;
+
+	/* disable bad blocks managment
+	 */
+	if (strstr(page, "disable") == page) {
+		bb->shift = -1;
+		return len;
+	}
+
+	rv = badblocks_store(&rdev->badblocks, page, len, 0);
 	/* Maybe that ack was all we needed */
 	if (test_and_clear_bit(BlockedBadBlocks, &rdev->flags))
 		wake_up(&rdev->blocked_wait);

