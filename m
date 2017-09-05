From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/3] mdadm/manpage: disable bitmap_resize for external file bitmap
Date: Tue,  5 Sep 2017 17:41:37 +0800
Message-ID: <1504604498-26048-3-git-send-email-zlliu@suse.com>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Update the manpage in "SIZE CHANGES" against the md commit.
Commit: e8a27f836f165c26f867ece7f31eb5c811692319
(md/bitmap: disable bitmap_resize for file-backed bitmaps.)

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.8.in | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index e0747fb..f0fd1fc 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2758,6 +2758,11 @@ Also the size of an array cannot be changed while it has an active
 bitmap.  If an array has a bitmap, it must be removed before the size
 can be changed. Once the change is complete a new bitmap can be created.
 
+.PP
+Note:
+.B "--grow --size"
+is not yet supported for external file bitmap.
+
 .SS RAID\-DEVICES CHANGES
 
 A RAID1 array can work with any number of devices from 1 upwards
-- 
2.6.6

