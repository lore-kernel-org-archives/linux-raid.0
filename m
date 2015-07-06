From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/3] mdadm: fix wrong condition for go to abort
Date: Mon,  6 Jul 2015 16:52:10 +0800
Message-ID: <1436172732-21021-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When parse_cluster_confirm_arg return 0, it means the
arg are parsed successfully, so change !rv to rv.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
Against cluster branch, it could be squashed with commit 4de9091
"Add a new clustered disk", sorry for inconvenience.  

 Manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index e3bdfb3..377df32 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1302,7 +1302,7 @@ int Manage_subdevs(char *devname, int fd,
 			rv = parse_cluster_confirm_arg(dv->devname,
 						       &dv->devname,
 						       &raid_slot);
-			if (!rv) {
+			if (rv) {
 				pr_err("Could not get the devname of cluster\n");
 				goto abort;
 			}
-- 
1.7.12.4

