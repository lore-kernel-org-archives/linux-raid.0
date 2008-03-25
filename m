From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/8] md: analyze_sbs(): Fix potential NULL-pointer dereference.
Date: Tue, 25 Mar 2008 21:38:30 +0100
Message-ID: <S1754836AbYGHQde/20080708163334Z+60@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

If no device in the array contains a valid super block, "freshest"
will be NULL, but we happily dereference that pointer in the subsequent
call to validate_super().

Fix it by returning early in this case.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7943df1..bf1499c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2249,6 +2249,10 @@ static void analyze_sbs(mddev_t * mddev)
 			kick_rdev_from_array(rdev);
 		}
 
+	if (!freshest) {
+		printk(KERN_ERR "md: no valid devices found\n");
+		return;
+	}
 
 	super_types[mddev->major_version].
 		validate_super(mddev, freshest);
-- 
1.5.3.8

