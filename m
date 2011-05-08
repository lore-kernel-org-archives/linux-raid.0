From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] RAID-6 check standalone suspend array
Date: Sun, 8 May 2011 20:54:08 +0200
Message-ID: <20110508185408.GA25378@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
 <20110321104007.GA15379@lazy.lzy>
 <20110321220457.29d52f5c@notabene.brown>
 <20110321115440.GA15635@lazy.lzy>
 <20110322095905.737fb1d5@notabene.brown>
 <20110404175242.GA3411@lazy.lzy>
 <20110405091242.3427e0b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405091242.3427e0b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

please find below a small patch which should suspend the
array while reading the stripes in order to perform the
check of the RAID-6.

This should complete the "check" part of the SW.
Please let me know what else could be needed (docs,
test or else).

Please have a careful look at it, since I did not know
how to test it.

Thanks.

--- cut here ---


diff -uNr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2011-05-07 20:35:18.693370007 +0200
+++ b/raid6check.c	2011-05-07 21:00:07.713865939 +0200
@@ -24,6 +24,7 @@
 
 #include "mdadm.h"
 #include <stdint.h>
+#include <signal.h>
 
 int geo_map(int block, unsigned long long stripe, int raid_disks,
 	    int level, int layout);
@@ -99,7 +100,7 @@
 	return curr_broken_disk;
 }
 
-int check_stripes(int *source, unsigned long long *offsets,
+int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		  int raid_disks, int chunk_size, int level, int layout,
 		  unsigned long long start, unsigned long long length, char *name[])
 {
@@ -139,10 +140,22 @@
 
 		printf("pos --> %llu\n", start);
 
+		signal(SIGTERM, SIG_IGN);
+		signal(SIGINT, SIG_IGN);
+		signal(SIGQUIT, SIG_IGN);
+		sysfs_set_num(info, NULL, "suspend_lo", start * data_disks);
+		sysfs_set_num(info, NULL, "suspend_hi", (start + chunk_size) * data_disks);
 		for (i = 0 ; i < raid_disks ; i++) {
 			lseek64(source[i], offsets[i] + start * chunk_size, 0);
 			read(source[i], stripes[i], chunk_size);
 		}
+		sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+		sysfs_set_num(info, NULL, "suspend_hi", 0);
+		sysfs_set_num(info, NULL, "suspend_lo", 0);
+		signal(SIGQUIT, SIG_DFL);
+		signal(SIGINT, SIG_DFL);
+		signal(SIGTERM, SIG_DFL);
+
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start, raid_disks, level, layout);
 			blocks[i] = stripes[disk];
@@ -343,7 +356,7 @@
 		comp = comp->next;
 	}
 
-	int rv = check_stripes(fds, offsets,
+	int rv = check_stripes(info, fds, offsets,
 			       raid_disks, chunk_size, level, layout,
 			       start, length, disk_name);
 	if (rv != 0) {

--- cut here ---

bye,

-- 

piergiorgio
