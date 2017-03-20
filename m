From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/Monitor:dev should be a block file when use --waitclean
Date: Mon, 20 Mar 2017 13:21:57 +0800
Message-ID: <1489987317-22895-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Monitor: mdadm --wait-clean /dev/mdX, the dev should
be a block file, otherwise fd2devnm returns NULL and
then triggers core dumped.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Monitor.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Monitor.c b/Monitor.c
index f8850d3..5a2b5ca 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1065,7 +1065,17 @@ int WaitClean(char *dev, int sock, int verbose)
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

