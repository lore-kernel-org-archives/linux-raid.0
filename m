From: Zhilong Liu <zlliu@suse.com>
Subject: [mdadm PATCH] retire the APIs that driver no longer supports
Date: Thu, 11 May 2017 16:52:41 +0800
Message-ID: <20170511085241.28136-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

refer to commit: e6e5f8f1267d ("Build: Stop
bothering about supporting md driver ...")
continue to retire the APIs that md driver
wasn't supported for very long period of time.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Build.c  | 4 ----
 Manage.c | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/Build.c b/Build.c
index ad59867..70ba068 100644
--- a/Build.c
+++ b/Build.c
@@ -24,10 +24,6 @@
 
 #include "mdadm.h"
 
-#define REGISTER_DEV		_IO (MD_MAJOR, 1)
-#define START_MD		_IO (MD_MAJOR, 2)
-#define STOP_MD			_IO (MD_MAJOR, 3)
-
 int Build(char *mddev, struct mddev_dev *devlist,
 	  struct shape *s, struct context *c)
 {
diff --git a/Manage.c b/Manage.c
index 14276b7..467efb7 100644
--- a/Manage.c
+++ b/Manage.c
@@ -27,10 +27,6 @@
 #include "md_p.h"
 #include <ctype.h>
 
-#define REGISTER_DEV		_IO (MD_MAJOR, 1)
-#define START_MD		_IO (MD_MAJOR, 2)
-#define STOP_MD			_IO (MD_MAJOR, 3)
-
 int Manage_ro(char *devname, int fd, int readonly)
 {
 	/* switch to readonly or rw
-- 
2.10.2

