From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md_u: Remove unused ioctl declaration of START_ARRAY
Date: Wed, 31 May 2017 19:38:36 +0800
Message-ID: <1496230716-5843-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

START_ARRAY is no longer used in the code, so get rid of it.
MD commit: fbedac04fa11 ("[PATCH] md: the scheduled removal
of the START_ARRAY ioctl for md") merged in the year 2006.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 md_u.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/md_u.h b/md_u.h
index d59aa2d..2d66d52 100644
--- a/md_u.h
+++ b/md_u.h
@@ -34,7 +34,6 @@
 
 /* usage */
 #define RUN_ARRAY		_IOW (MD_MAJOR, 0x30, mdu_param_t)
-#define START_ARRAY		_IO (MD_MAJOR, 0x31)
 #define STOP_ARRAY		_IO (MD_MAJOR, 0x32)
 #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
-- 
2.6.6

