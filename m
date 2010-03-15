From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: [mdadm PATCH] Cli options check added- check for disk duplicates
Date: Mon, 15 Mar 2010 10:58:00 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408001A28646@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

From aace200890a17805ffc556d729e494eb1b2bf2bf Mon Sep 17 00:00:00 2001
From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Date: Thu, 11 Mar 2010 10:30:56 +0100
Subject: [PATCH] Cli options check added- check for disk duplicates

This fix does not allow to create array with duplicated disk.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 mdadm.c |    4 ++++
 mdadm.h |    1 +
 util.c  |   16 ++++++++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index d5e34c0..87588ae 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -980,6 +980,10 @@ int main(int argc, char *argv[])
 			fprintf(stderr, Name ": an md device must be given in this mode\n");
 			exit(2);
 		}
+        if (check_duplicates(devlist)) {
+            fprintf(stderr, Name ": There are duplicated disks in command line options\n");
+            exit(2);
+        }
 		if ((int)ident.super_minor == -2 && autof) {
 			fprintf(stderr, Name ": --super-minor=dev is incompatible with --auto\n");
 			exit(2);
diff --git a/mdadm.h b/mdadm.h
index 362b66b..ad43a53 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -888,6 +888,7 @@ unsigned long long min_recovery_start(struct mdinfo *array);
 extern char *human_size(long long bytes);
 extern char *human_size_brief(long long bytes);
 extern void print_r10_layout(int layout);
+extern int check_duplicates(mddev_dev_t dlist);
 
 #define NoMdDev (1<<23)
 extern int find_free_devnum(int use_partitions);
diff --git a/util.c b/util.c
index d292a66..8a03c12 100644
--- a/util.c
+++ b/util.c
@@ -1645,3 +1645,19 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 unsigned int __invalid_size_argument_for_IOC = 0;
 #endif
 
+/* Check is there no duplicated disks in command line options */
+int check_duplicates(mddev_dev_t dlist) {
+    mddev_dev_t dev1, dev2;
+    /* Skip first element because this is array name */
+    dev1 = dlist->next;
+    while (dev1) {
+        dev2 = dev1->next;
+        while (dev2) {
+            if (strcmp(dev1->devname, dev2->devname) == 0) 
+                return 1;
+            dev2 = dev2->next;
+        }
+        dev1 = dev1->next;
+    }
+    return 0; 
+}
-- 
1.6.3.3

