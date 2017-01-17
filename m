From: Wols Lists <antlists@youngman.org.uk>
Subject: [PATCH] Fix oddity where mdadm did not recognise a relative path
Date: Tue, 17 Jan 2017 19:07:02 +0000
Message-ID: <587E6B56.8090704@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090404000605080905040009"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090404000605080905040009
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


--------------090404000605080905040009
Content-Type: text/x-patch;
 name="0001-Fix-oddity-where-mdadm-did-not-recognise-a-relative-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-oddity-where-mdadm-did-not-recognise-a-relative-.pa";
 filename*1="tch"

From 4ce784307a9004124392ce48432960d7ca94d0bf Mon Sep 17 00:00:00 2001
From: Wol <anthony@youngman.org.uk>
Date: Tue, 17 Jan 2017 17:47:05 +0000
Subject: [PATCH] Fix oddity where mdadm did not recognise a relative path

mdadm assumed that a pathname started with a "/", while an array
name didn't. This alters the logic so that if the first character
is not a "/" it tries to open an array, and if that fails it drops
through to the pathname code rather than terminating immediately
with an error.

Signed-off-by: Wol <anthony@youngman.org.uk>
---
 mdadm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index c3a265b..b5d89e4 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1899,12 +1899,12 @@ static int misc_list(struct mddev_dev *devlist,
 			rv |= SetAction(dv->devname, c->action);
 			continue;
 		}
-		if (dv->devname[0] == '/')
-			mdfd = open_mddev(dv->devname, 1);
-		else {
-			mdfd = open_dev(dv->devname);
-			if (mdfd < 0)
-				pr_err("Cannot open %s\n", dv->devname);
+		switch(dv->devname[0] == '/') {
+			case 0:
+				mdfd = open_dev(dv->devname);
+				if (mdfd >= 0) break;
+			case 1:
+				mdfd = open_mddev(dv->devname, 1);  
 		}
 		if (mdfd>=0) {
 			switch(dv->disposition) {
-- 
2.7.3


--------------090404000605080905040009--
