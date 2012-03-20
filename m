From: Jes.Sorensen@redhat.com
Subject: [PATCH 11/11] __write_init_super_ddf(): Use posix_memalign() instead of static aligned buffer
Date: Tue, 20 Mar 2012 17:54:16 +0100
Message-ID: <1332262456-5109-12-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-ddf.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index abd6793..5e51c4c 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2326,8 +2326,7 @@ static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
  * called when creating a container or adding another device to a
  * container.
  */
-
-static unsigned char null_conf[4096+512];
+#define NULL_CONF_SZ	4096
 
 static int __write_init_super_ddf(struct supertype *st)
 {
@@ -2340,6 +2339,12 @@ static int __write_init_super_ddf(struct supertype *st)
 	int attempts = 0;
 	int successes = 0;
 	unsigned long long size, sector;
+	char *null_aligned;
+
+	if (posix_memalign((void**)&null_aligned, 4096, NULL_CONF_SZ) != 0) {
+		return -ENOMEM;
+	}
+	memset(null_aligned, 0xff, NULL_CONF_SZ);
 
 	/* try to write updated metadata,
 	 * if we catch a failure move on to the next disk
@@ -2409,14 +2414,11 @@ static int __write_init_super_ddf(struct supertype *st)
 				if (write(fd, &c->conf, conf_size) < 0)
 					break;
 			} else {
-				char *null_aligned = (char*)((((unsigned long)null_conf)+511)&~511UL);
-				if (null_conf[0] != 0xff)
-					memset(null_conf, 0xff, sizeof(null_conf));
 				unsigned int togo = conf_size;
-				while (togo > sizeof(null_conf)-512) {
-					if (write(fd, null_aligned, sizeof(null_conf)-512) < 0)
+				while (togo > NULL_CONF_SZ) {
+					if (write(fd, null_aligned, NULL_CONF_SZ) < 0)
 						break;
-					togo -= sizeof(null_conf)-512;
+					togo -= NULL_CONF_SZ;
 				}
 				if (write(fd, null_aligned, togo) < 0)
 					break;
@@ -2435,6 +2437,7 @@ static int __write_init_super_ddf(struct supertype *st)
 			continue;
 		successes++;
 	}
+	free(null_aligned);
 
 	return attempts != successes;
 }
-- 
1.7.7.6

