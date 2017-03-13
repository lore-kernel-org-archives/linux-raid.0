From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/4 v1] mdadm:triggers core dump when stat2devnm return NULL
Date: Mon, 13 Mar 2017 15:01:05 +0800
Message-ID: <1489388465-13407-1-git-send-email-zlliu@suse.com>
References: <8760jef6d4.fsf@notabene.neil.brown.name>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760jef6d4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, neilb@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

monitor: ensure that the device should be a block
device when uses --wait parameter, such as the 'f'
and 'd' type file would be triggered core dumped.
./mdadm --wait /dev/md/, happened core dump.

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

