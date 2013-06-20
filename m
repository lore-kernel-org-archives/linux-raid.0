From: mwilck@arcor.de
Subject: [PATCH 2/2] Detail: deterministic ordering in --brief --verbose
Date: Thu, 20 Jun 2013 22:21:05 +0200
Message-ID: <1371759665-5625-2-git-send-email-mwilck@arcor.de>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Have mdadm --Detail --brief --verbose print the list of devices in
alphabetical order.

This is useful for debugging purposes. E.g. the test script
10ddf-create compares the output of two mdadm -Dbv calls which
may be different if the order is not deterministic.

(I confess: I use a modified "test" script that always runs
"mdadm --verbose" rather than "mdadm --quiet", otherwise this
wouldn't happen in 10ddf-create).

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Detail.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/Detail.c b/Detail.c
index 33b3a18..031219a 100644
--- a/Detail.c
+++ b/Detail.c
@@ -27,6 +27,11 @@
 #include	"md_u.h"
 #include	<dirent.h>
 
+static int cmpstringp(const void *p1, const void *p2)
+{
+	return strcmp(* (char * const *) p1, * (char * const *) p2);
+}
+
 int Detail(char *dev, struct context *c)
 {
 	/*
@@ -42,7 +47,8 @@ int Detail(char *dev, struct context *c)
 	int d;
 	time_t atime;
 	char *str;
-	char *devices = NULL;
+	char **devices = NULL;
+	int max_devices = 0, n_devices = 0;
 	int spares = 0;
 	struct stat stb;
 	int is_26 = get_linux_version() >= 2006000;
@@ -636,12 +642,15 @@ This is pretty boring
 		dv=map_dev_preferred(disk.major, disk.minor, 0, c->prefer);
 		if (dv != NULL) {
 			if (c->brief) {
-				if (devices) {
-					devices = xrealloc(devices,
-							  strlen(devices)+1+strlen(dv)+1);
-					strcat(strcat(devices,","),dv);
-				} else
-					devices = xstrdup(dv);
+				if (n_devices + 1 >= max_devices) {
+					max_devices += 16;
+					devices = xrealloc(devices, max_devices
+							   *sizeof(*devices));
+					if (!devices)
+						goto out;
+				};
+				devices[n_devices] = xstrdup(dv);
+				n_devices++;
 			} else
 				printf("   %s", dv);
 		}
@@ -653,7 +662,12 @@ This is pretty boring
 	if (st)
 		st->ss->free_super(st);
 
-	if (c->brief && c->verbose > 0 && devices) printf("\n   devices=%s", devices);
+	if (c->brief && c->verbose > 0 && devices) {
+		qsort(devices, n_devices, sizeof(*devices), cmpstringp);
+		printf("\n   devices=%s", devices[0]);
+		for (d = 1; d < n_devices; d++)
+			printf(",%s", devices[d]);
+	}
 	if (c->brief)
 		printf("\n");
 	if (c->test &&
@@ -666,6 +680,9 @@ out:
 	close(fd);
 	free(subarray);
 	free(avail);
+	for (d = 0; d < n_devices; d++)
+		free(devices[d]);
+	free(devices);
 	sysfs_free(sra);
 	return rv;
 }
-- 
1.7.1
