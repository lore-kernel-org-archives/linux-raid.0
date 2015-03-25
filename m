From: Andrew Burgess <andrew.burgess@embecosm.com>
Subject: [PATCH] Fix minor typo in mdadm manpage.
Date: Wed, 25 Mar 2015 17:17:49 +0000
Message-ID: <1427303869-17319-1-git-send-email-andrew.burgess@embecosm.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andrew Burgess <andrew.burgess@embecosm.com>
List-Id: linux-raid.ids

Appologies if this is the wrong mailing list for this patch.

This is a very small patch for the manual page for the mdadm utility.

Thanks,
Andrew

---
Change 'is and of' to 'is one of' in mdadm manual page.

Signed-off-by: Andrew Burgess <andrew.burgess@embecosm.com>
---
 mdadm.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index a630310..b4a21d9 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -214,7 +214,7 @@ to detect and assemble arrays \(em possibly in an
 
 .P
 If a device is given before any options, or if the first option is
-and of
+one of
 .BR \-\-add ,
 .BR \-\-re\-add ,
 .BR \-\-add\-spare ,
-- 
2.2.2

