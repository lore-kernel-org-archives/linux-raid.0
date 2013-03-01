From: mwilck@arcor.de
Subject: [PATCH 12/12] Detail.c: call load_container for container subarrays
Date: Fri,  1 Mar 2013 23:28:33 +0100
Message-ID: <1362176913-6804-13-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Without calling load_container at this point, the
info structure may be missing some important information.
In particular, information about secondary DDF RAID levels
may be wrong if information is only read from a single disk.

If this fails, fall back to the previous code.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Detail.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Detail.c b/Detail.c
index ab49803..9e52de8 100644
--- a/Detail.c
+++ b/Detail.c
@@ -103,13 +103,21 @@ int Detail(char *dev, struct context *c)
 		 * We want the name of the container, and the member
 		 */
 		int dn = st->container_dev;
+		int cfd, err;
 
 		member = subarray;
 		container = map_dev_preferred(dev2major(dn), dev2minor(dn), 1, c->prefer);
+		cfd = open_dev(st->container_dev);
+		if (cfd >= 0) {
+			err = st->ss->load_container(st, cfd, NULL);
+			close(cfd);
+			if (err == 0)
+				info = st->ss->container_content(st, subarray);
+		}
 	}
 
 	/* try to load a superblock */
-	if (st) for (d = 0; d < max_disks; d++) {
+	if (st && !info) for (d = 0; d < max_disks; d++) {
 		mdu_disk_info_t disk;
 		char *dv;
 		int fd2;
-- 
1.7.3.4
