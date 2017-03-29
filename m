From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCH 2/2] mdadm.c: fix compile error "switch condition has boolean value"
Date: Wed, 29 Mar 2017 11:40:34 +0200
Message-ID: <1490780434-8720-2-git-send-email-gi-oh.kim@profitbricks.com>
References: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: linux-raid.ids

Remove a boolean expression in switch condition
to prevent compile error of some compilers.

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 mdadm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 08ddcab..a98a051 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1905,11 +1905,11 @@ static int misc_list(struct mddev_dev *devlist,
 			rv |= SetAction(dv->devname, c->action);
 			continue;
 		}
-		switch(dv->devname[0] == '/') {
-			case 0:
+		switch(dv->devname[0]) {
+			default:
 				mdfd = open_dev(dv->devname);
 				if (mdfd >= 0) break;
-			case 1:
+			case '/':
 				mdfd = open_mddev(dv->devname, 1);  
 		}
 		if (mdfd>=0) {
-- 
2.5.0

