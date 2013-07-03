From: mwilck@arcor.de
Subject: [PATCH 05/27] DDF: Implement store_super_ddf
Date: Wed,  3 Jul 2013 22:27:45 +0200
Message-ID: <1372883287-8859-6-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This patch implements the previously unsupported case where
store_super_ddf is called with a non-empty superblock.

For DDF, writing meta data to just one disk makes no sense.
We would run the risk of writing inconsistent meta data
to the devices. So just call __write_init_super_ddf and
write to all devices, including the one passed by the caller.

This patch assumes that the device to store the superblock on
has already been added to the DDF structure. Otherwise, an
error message will be emitted.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index b806949..b3c846d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3471,15 +3471,44 @@ static int store_super_ddf(struct supertype *st, int fd)
 	if (!ddf)
 		return 1;
 
-	/* ->dlist and ->conflist will be set for updates, currently not
-	 * supported
-	 */
-	if (ddf->dlist || ddf->conflist)
-		return 1;
-
 	if (!get_dev_size(fd, NULL, &dsize))
 		return 1;
 
+	if (ddf->dlist || ddf->conflist) {
+		struct stat sta;
+		struct dl *dl;
+		int ofd, ret;
+
+		if (fstat(fd, &sta) == -1 || !S_ISBLK(sta.st_mode)) {
+			pr_err("%s: file descriptor for invalid device\n",
+			       __func__);
+			return 1;
+		}
+		for (dl = ddf->dlist; dl; dl = dl->next)
+			if (dl->major == (int)major(sta.st_rdev) &&
+			    dl->minor == (int)minor(sta.st_rdev))
+				break;
+		if (!dl) {
+			pr_err("%s: couldn't find disk %d/%d\n", __func__,
+			       (int)major(sta.st_rdev),
+			       (int)minor(sta.st_rdev));
+			return 1;
+		}
+		/*
+		   For DDF, writing to just one disk makes no sense.
+		   We would run the risk of writing inconsistent meta data
+		   to the devices. So just call __write_init_super_ddf and
+		   write to all devices, including this one.
+		   Use the fd passed to this function, just in case dl->fd
+		   is invalid.
+		 */
+		ofd = dl->fd;
+		dl->fd = fd;
+		ret =  __write_init_super_ddf(st);
+		dl->fd = ofd;
+		return ret;
+	}
+
 	if (posix_memalign(&buf, 512, 512) != 0)
 		return 1;
 	memset(buf, 0, 512);
-- 
1.7.1
