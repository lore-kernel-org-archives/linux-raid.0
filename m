From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] Monitor: dev should be a block file in waitclean
Date: Tue, 14 Feb 2017 15:50:25 +0800
Message-ID: <1487058625-28852-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

    mdadm --wait-clean /dev/mdX, the dev should
    be a block file, otherwise fd2devnm returns
    NULL and triggers core dumped.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/Monitor.c b/Monitor.c
index 802a9d9..d16ac49 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1060,7 +1060,17 @@ int WaitClean(char *dev, int sock, int verbose)
 	struct mdinfo *mdi;
 	int rv = 1;
 	char devnm[32];
+	struct stat stb;
 
+	if (stat(dev, &stb) != 0) {
+		pr_err("Cannot find %s: %s\n", dev,
+			strerror(errno));
+		return 2;
+	}
+	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
+		pr_err("%s is not a block device.\n", dev);
+		return 2;
+	}
 	fd = open(dev, O_RDONLY);
 	if (fd < 0) {
 		if (verbose)
-- 
2.6.6

