From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 01/13] mdadm/manpage: raid10 doesn't support resize 'far' arrays
Date: Fri,  1 Dec 2017 17:48:02 +0800
Message-ID: <1512121694-18168-2-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

md->raid10_resize(): Resize of 'far' arrays is not supported.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index f0fd1fc..270781c 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2761,7 +2761,7 @@ can be changed. Once the change is complete a new bitmap can be created.
 .PP
 Note:
 .B "--grow --size"
-is not yet supported for external file bitmap.
+is not yet supported for external file bitmap and 'far' mode of raid10.
 
 .SS RAID\-DEVICES CHANGES
 
-- 
1.8.5.6

