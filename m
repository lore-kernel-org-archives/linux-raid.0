From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH 1/3] config.c: since dlist is initialized as NULL, remove the useless code
Date: Thu, 27 Aug 2015 15:34:55 +0800
Message-ID: <1440660897-7619-1-git-send-email-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 config.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/config.c b/config.c
index c58c8fe..bb5af86 100644
--- a/config.c
+++ b/config.c
@@ -941,13 +941,6 @@ struct mddev_dev *conf_get_devs()
 	static struct mddev_dev *dlist = NULL;
 	unsigned int i;
 
-	while (dlist) {
-		struct mddev_dev *t = dlist;
-		dlist = dlist->next;
-		free(t->devname);
-		free(t);
-	}
-
 	load_conffile();
 
 	if (cdevlist == NULL) {
-- 
1.8.1.4

