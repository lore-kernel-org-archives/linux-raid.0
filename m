From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 6/7] Zero write-cache superblock in --zero-super
Date: Wed, 13 May 2015 23:43:55 -0700
Message-ID: <1431585836-4103033-7-git-send-email-songliubraving@fb.com>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids


Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Kill.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Kill.c b/Kill.c
index f2fdb85..9dc566b 100644
--- a/Kill.c
+++ b/Kill.c
@@ -29,6 +29,18 @@
 #include	"md_u.h"
 #include	"md_p.h"
 
+int KillR5LSuper(struct supertype *st, int fd)
+{
+	memset(st->r5l_sb, 0, LOG_BLOCK_SIZE);
+
+	if (lseek64(fd, 512 * (st->data_offset), 0) < 0LL)
+		return 1;
+	if (write(fd, st->r5l_sb, LOG_BLOCK_SIZE))
+		return 1;
+	fsync(fd);
+	return 0;
+}
+
 int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 {
 	/*
@@ -60,8 +72,15 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 		return 2;
 	}
 	st->ignore_hw_compat = 1;
+	st->data_offset = INVALID_SECTORS;  /* load st->data_offset from sb for KillR5LSuper */
 	rv = st->ss->load_super(st, fd, dev);
 	if (rv == 0 || (force && rv >= 2)) {
+		if (st->r5l_sb) {
+			if (verbose > 0)
+				pr_err("zero write_cache superblock\n");
+			KillR5LSuper(st, fd);
+		}
+
 		st->ss->free_super(st);
 		st->ss->init_super(st, NULL, 0, "", NULL, NULL,
 				   INVALID_SECTORS);
-- 
1.8.1

