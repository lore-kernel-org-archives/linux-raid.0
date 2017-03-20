From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/Monitor:triggers core dump when stat2devnm return NULL
Date: Mon, 20 Mar 2017 13:21:41 +0800
Message-ID: <1489987301-22836-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Monitor: ensure that the device should be a block
device when uses --wait parameter, such as the 'f'
and 'd' type file would be triggered core dumped.
such as: ./mdadm --wait /dev/md/

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Monitor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index 802a9d9..f8850d3 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1002,7 +1002,12 @@ int Wait(char *dev)
 			strerror(errno));
 		return 2;
 	}
-	strcpy(devnm, stat2devnm(&stb));
+	char *tmp = stat2devnm(&stb);
+	if (!tmp) {
+		pr_err("%s is not a block device.\n", dev);
+		return 2;
+	}
+	strcpy(devnm, tmp);
 
 	while(1) {
 		struct mdstat_ent *ms = mdstat_read(1, 0);
-- 
2.6.6

