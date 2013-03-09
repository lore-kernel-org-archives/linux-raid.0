From: Wieland Hoffmann <themineo@gmail.com>
Subject: [PATCH] mdadm.8.in: Fix typo: previous -> previously
Date: Sat,  9 Mar 2013 15:34:24 +0100
Message-ID: <1362839664-361-1-git-send-email-themineo@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Wieland Hoffmann <themineo@gmail.com>
---
 mdadm.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 1c06533..f7aa6aa 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1224,7 +1224,7 @@ with redundancy.  They don't apply to RAID0 or Linear.
 
 .TP
 .BR \-\-re\-add
-re\-add a device that was previous removed from an array.
+re\-add a device that was previously removed from an array.
 If the metadata on the device reports that it is a member of the
 array, and the slot that it used is still vacant, then the device will
 be added back to the array in the same position.  This will normally
-- 
1.8.1.5

