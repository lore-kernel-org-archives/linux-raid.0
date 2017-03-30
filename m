From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCHv2] mdadm.c: fix compile error "switch condition has boolean value"
Date: Thu, 30 Mar 2017 18:58:13 +0200
Message-ID: <1490893093-4666-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jes.sorensen@gmail.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: linux-raid.ids

Remove a boolean expression in switch condition
to prevent compile error of some compilers,
for example, gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2).

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 mdadm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 0f32773..d6b5437 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1965,14 +1965,12 @@ static int misc_list(struct mddev_dev *devlist,
 			rv |= SetAction(dv->devname, c->action);
 			continue;
 		}
-		switch(dv->devname[0] == '/') {
-			case 0:
-				mdfd = open_dev(dv->devname);
-				if (mdfd >= 0)
-					break;
-			case 1:
-				mdfd = open_mddev(dv->devname, 1);  
-		}
+
+		if (dv->devname[0] != '/')
+			mdfd = open_dev(dv->devname);
+		if (dv->devname[0] == '/' || mdfd < 0)
+			mdfd = open_mddev(dv->devname, 1);
+
 		if (mdfd >= 0) {
 			switch(dv->disposition) {
 			case 'R':
-- 
2.5.0
