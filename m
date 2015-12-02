From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 16/17] Clear MBR in when Kill superblock
Date: Tue, 1 Dec 2015 16:25:32 -0800
Message-ID: <1449015933-255689-17-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

When killing the superblock, also clear MBR.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Kill.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Kill.c b/Kill.c
index f2fdb85..06ced78 100644
--- a/Kill.c
+++ b/Kill.c
@@ -28,6 +28,23 @@
 #include	"mdadm.h"
 #include	"md_u.h"
 #include	"md_p.h"
+#include	"part.h"
+
+int KillMBR(int fd)
+{
+	struct MBR *null_mbr;
+
+	null_mbr = xmalloc(sizeof(*null_mbr));
+	memset(null_mbr, 0, sizeof(*null_mbr));
+	lseek(fd, 0, 0);
+	if (write(fd, null_mbr, sizeof(*null_mbr)) != sizeof(*null_mbr)) {
+		free(null_mbr);
+		return 1;
+	}
+	free(null_mbr);
+	fsync(fd);
+	return 0;
+}
 
 int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 {
@@ -76,6 +93,11 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 			rv = 0;
 		}
 	}
+
+	if (KillMBR(fd))
+		if (verbose >=0)
+			pr_err("Cannot clear MBR on %s\n", dev);
+
 	close(fd);
 	return rv;
 }
-- 
2.4.6

