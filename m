From: Robert Buchholz <robert.buchholz@goodpoint.de>
Subject: [PATCH RESEND] Fix and extend raid6check repair
Date: Wed, 15 Aug 2012 14:55:43 +0200
Message-ID: <2586585.1GSuNNC3Ge@peanut>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2636717.dGg27Vs2rt"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nextPart2636717.dGg27Vs2rt
Content-Type: multipart/mixed; boundary="nextPart1582456.XmQuSP4jmf"
Content-Transfer-Encoding: 7Bit


--nextPart1582456.XmQuSP4jmf
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello,

this is a resend of my patches dated Jul 20th in the "Find mismatch in 
data blocks during raid6 repair" thread.

Currently, the raid6check tool does not compile (due to the xmalloc 
changes) and my initial set of repair patches are faulty.  Please merge 
and see my original emails for extended comments
http://thread.gmane.org/gmane.linux.raid/38922/focus=39454
http://thread.gmane.org/gmane.linux.raid/38922/focus=39460



Cheers

Robert

--nextPart1582456.XmQuSP4jmf
Content-Disposition: attachment; filename="0001-Move-xmalloc-et-al-into-their-own-file.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Move-xmalloc-et-al-into-their-own-file.patch"

From 30e1c452d39e3c2d95eb22e2cdd23feb1a8e2914 Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Mon, 16 Jul 2012 23:56:54 +0200
Subject: [PATCH 1/5] Move xmalloc et al into their own file

This avoid code duplication for utilities that do not link to
util.c and everything that comes with it, such as test_restripe and
raid6check
---
 Makefile   |   12 +++++-----
 restripe.c |   22 ------------------
 util.c     |   40 ---------------------------------
 xmalloc.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 68 deletions(-)
 create mode 100644 xmalloc.c

diff --git a/Makefile b/Makefile
index a3e4027..d99ea2b 100644
--- a/Makefile
+++ b/Makefile
@@ -109,10 +109,10 @@ OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o \
 	Incremental.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
 	super-mbr.o super-gpt.o \
-	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
+	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
 	platform-intel.o probe_roms.o
 
-CHECK_OBJS = restripe.o sysfs.o maps.o lib.o
+CHECK_OBJS = restripe.o sysfs.o maps.o lib.o xmalloc.o
 
 SRCS =  $(patsubst %.o,%.c,$(OBJS))
 
@@ -122,7 +122,7 @@ MON_OBJS = mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o \
 	config.o policy.o lib.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
 	super-mbr.o super-gpt.o \
-	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
+	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
 	platform-intel.o probe_roms.o
 
 MON_SRCS = $(patsubst %.o,%.c,$(MON_OBJS))
@@ -131,7 +131,7 @@ STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
 
 ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c policy.c dlink.c util.c \
-	maps.c lib.c \
+	maps.c lib.c xmalloc.c \
 	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
 	platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c
 ASSEMBLE_AUTO_SRCS := mdopen.c
@@ -180,8 +180,8 @@ mdmon : $(MON_OBJS)
 	$(CC) $(CFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -Wl,-z,now -o mdmon $(MON_OBJS) $(LDLIBS)
 msg.o: msg.c msg.h
 
-test_stripe : restripe.c mdadm.h
-	$(CC) $(CXFLAGS) $(LDFLAGS) -o test_stripe -DMAIN restripe.c
+test_stripe : restripe.c xmalloc.o mdadm.h
+	$(CC) $(CXFLAGS) $(LDFLAGS) -o test_stripe xmalloc.o  -DMAIN restripe.c
 
 raid6check : raid6check.o mdadm.h $(CHECK_OBJS)
 	$(CC) $(CXFLAGS) $(LDFLAGS) -o raid6check raid6check.o $(CHECK_OBJS)
diff --git a/restripe.c b/restripe.c
index 1d2da1a..90896c8 100644
--- a/restripe.c
+++ b/restripe.c
@@ -998,26 +998,4 @@ main(int argc, char *argv[])
 	exit(0);
 }
 
-
-void *xmalloc(size_t len)
-{
-	void *rv = malloc(len);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	write(2, msg, strlen(msg));
-	exit(4);
-}
-
-void *xcalloc(size_t num, size_t size)
-{
-	void *rv = calloc(num, size);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	write(2, msg, strlen(msg));
-	exit(4);
-}
 #endif /* MAIN */
diff --git a/util.c b/util.c
index eb46650..353d523 100644
--- a/util.c
+++ b/util.c
@@ -1803,43 +1803,3 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 	}
 	return disks;
 }
-
-void *xmalloc(size_t len)
-{
-	void *rv = malloc(len);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
-
-void *xrealloc(void *ptr, size_t len)
-{
-	void *rv = realloc(ptr, len);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
-
-void *xcalloc(size_t num, size_t size)
-{
-	void *rv = calloc(num, size);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
-
-char *xstrdup(const char *str)
-{
-	char *rv = strdup(str);
-	char *msg;
-	if (rv)
-		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
-	exit(4+!!write(2, msg, strlen(msg)));
-}
diff --git a/xmalloc.c b/xmalloc.c
new file mode 100644
index 0000000..8d42a7c
--- /dev/null
+++ b/xmalloc.c
@@ -0,0 +1,72 @@
+/* mdadm - manage Linux "md" devices aka RAID arrays.
+ *
+ * Copyright (C) 2001-2009 Neil Brown <neilb@suse.de>
+ *
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *    Author: Neil Brown
+ *    Email: <neilb@suse.de>
+ */
+
+#include	"mdadm.h"
+/*#include	<sys/socket.h>
+#include	<sys/utsname.h>
+#include	<sys/wait.h>
+#include	<sys/un.h>
+#include	<ctype.h>
+#include	<dirent.h>
+#include	<signal.h>
+*/
+
+void *xmalloc(size_t len)
+{
+	void *rv = malloc(len);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
+
+void *xrealloc(void *ptr, size_t len)
+{
+	void *rv = realloc(ptr, len);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
+
+void *xcalloc(size_t num, size_t size)
+{
+	void *rv = calloc(num, size);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
+
+char *xstrdup(const char *str)
+{
+	char *rv = strdup(str);
+	char *msg;
+	if (rv)
+		return rv;
+	msg = Name ": memory allocation failure - aborting\n";
+	exit(4+!!write(2, msg, strlen(msg)));
+}
-- 
1.7.3.4


--nextPart1582456.XmQuSP4jmf
Content-Disposition: attachment; filename="0002-raid6check-Fix-off-by-one-in-argument-check.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-raid6check-Fix-off-by-one-in-argument-check.patch"

From e89053ac2f7bf025ff2ae4eb9e4f742c439cd88b Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Thu, 19 Jul 2012 17:14:47 +0200
Subject: [PATCH 2/5] raid6check: Fix off-by-one in argument check

In repair mode, specifying a failed slot that is equal to the number of
devices in the raid could cause a segfault.
---
 raid6check.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index aba8160..dffadbe 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -416,12 +416,12 @@ int main(int argc, char *argv[])
 		failed_disk1 = getnum(argv[4], &err);
 		failed_disk2 = getnum(argv[5], &err);
 
-		if(failed_disk1 > info->array.raid_disks) {
+		if(failed_disk1 >= info->array.raid_disks) {
 			fprintf(stderr, "%s: failed_slot_1 index is higher than number of devices in raid\n", prg);
 			exit_err = 4;
 			goto exitHere;
 		}
-		if(failed_disk2 > info->array.raid_disks) {
+		if(failed_disk2 >= info->array.raid_disks) {
 			fprintf(stderr, "%s: failed_slot_2 index is higher than number of devices in raid\n", prg);
 			exit_err = 4;
 			goto exitHere;
-- 
1.7.3.4


--nextPart1582456.XmQuSP4jmf
Content-Disposition: attachment; filename="0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch"

From 84f06a6c216ed41e008ef94b8adbcb3b028f77b8 Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Thu, 19 Jul 2012 19:33:22 +0200
Subject: [PATCH 3/5] raid6check: Repair mode used geo_map incorrectly

In repair mode, the data block indices to be repaired were calculated
using geo_map() which returns the disk slot for a data block index
and not the reverse. Now we simply store the reverse of that calculation
when we do it anyway.
---
 raid6check.c                    |   24 +++++++++++++-----------
 tests/19repair-does-not-destroy |   30 ++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 11 deletions(-)
 create mode 100644 tests/19repair-does-not-destroy

diff --git a/raid6check.c b/raid6check.c
index dffadbe..51e7cca 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -116,6 +116,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 	char *stripe_buf = xmalloc(raid_disks * chunk_size);
 	char **stripes = xmalloc(raid_disks * sizeof(char*));
 	char **blocks = xmalloc(raid_disks * sizeof(char*));
+	int *block_index_for_slot = xmalloc(raid_disks * sizeof(int));
 	uint8_t *p = xmalloc(chunk_size);
 	uint8_t *q = xmalloc(chunk_size);
 	int *results = xmalloc(chunk_size * sizeof(int));
@@ -172,6 +173,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start, raid_disks, level, layout);
 			blocks[i] = stripes[disk];
+			block_index_for_slot[disk] = i;
 			printf("%d->%d\n", i, disk);
 		}
 
@@ -179,7 +181,9 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		diskP = geo_map(-1, start, raid_disks, level, layout);
 		diskQ = geo_map(-2, start, raid_disks, level, layout);
 		blocks[data_disks] = stripes[diskP];
+		block_index_for_slot[diskP] = data_disks;
 		blocks[data_disks+1] = stripes[diskQ];
+		block_index_for_slot[diskQ] = data_disks+1;
 
 		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
 			printf("P(%d) wrong at %llu\n", diskP, start);
@@ -208,23 +212,21 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 
 			if (failed_disk1 == diskQ || failed_disk2 == diskQ) {
 				char *all_but_failed_blocks[data_disks];
-				int failed_data;
+				int failed_data_or_p;
 				int failed_block_index;
 
 				if (failed_disk1 == diskQ)
-					failed_data = failed_disk2;
+					failed_data_or_p = failed_disk2;
 				else
-					failed_data = failed_disk1;
-				printf("Repairing D/P(%d) and Q\n", failed_data);
-				failed_block_index = geo_map(
-					failed_data, start, raid_disks,
-					level, layout);
+					failed_data_or_p = failed_disk1;
+				printf("Repairing D/P(%d) and Q\n", failed_data_or_p);
+				failed_block_index = block_index_for_slot[failed_data_or_p];
 				for (i=0; i < data_disks; i++)
 					if (failed_block_index == i)
 						all_but_failed_blocks[i] = stripes[diskP];
 					else
 						all_but_failed_blocks[i] = blocks[i];
-				xor_blocks(stripes[failed_data],
+				xor_blocks(stripes[failed_data_or_p],
 					all_but_failed_blocks, data_disks, chunk_size);
 				qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
 			} else {
@@ -235,13 +237,13 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 						failed_data = failed_disk2;
 					else
 						failed_data = failed_disk1;
-					failed_block_index = geo_map(failed_data, start, raid_disks, level, layout);
+					failed_block_index = block_index_for_slot[failed_data];
 					printf("Repairing D(%d) and P\n", failed_data);
 					raid6_datap_recov(raid_disks, chunk_size, failed_block_index, (uint8_t**)blocks);
 				} else {
 					printf("Repairing D and D\n");
-					int failed_block_index1 = geo_map(failed_disk1, start, raid_disks, level, layout);
-					int failed_block_index2 = geo_map(failed_disk2, start, raid_disks, level, layout);
+					int failed_block_index1 = block_index_for_slot[failed_disk1];
+					int failed_block_index2 = block_index_for_slot[failed_disk2];
 					if (failed_block_index1 > failed_block_index2) {
 						int t = failed_block_index1;
 						failed_block_index1 = failed_block_index2;
diff --git a/tests/19repair-does-not-destroy b/tests/19repair-does-not-destroy
new file mode 100644
index 0000000..d355e0c
--- /dev/null
+++ b/tests/19repair-does-not-destroy
@@ -0,0 +1,30 @@
+number_of_disks=7
+chunksize_in_kib=512
+array_data_size_in_kib=$[chunksize_in_kib*(number_of_disks-2)*number_of_disks]
+array_data_size_in_b=$[array_data_size_in_kib*1024]
+devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5 $dev6"
+
+dd if=/dev/urandom of=/tmp/RandFile bs=1024 count=$array_data_size_in_kib
+mdadm -CR $md0 -l6 -n$number_of_disks -c $chunksize_in_kib $devs
+dd if=/tmp/RandFile of=$md0 bs=1024 count=$array_data_size_in_kib
+blockdev --flushbufs $md0; sync
+check wait
+blockdev --flushbufs $devs; sync
+echo 3 > /proc/sys/vm/drop_caches
+$dir/raid6check $md0 repair  1 2 3 > /dev/null # D D
+$dir/raid6check $md0 repair  8 2 5 > /dev/null # D P
+$dir/raid6check $md0 repair 15 4 6 > /dev/null # D Q
+$dir/raid6check $md0 repair 22 5 6 > /dev/null # P Q
+$dir/raid6check $md0 repair  3 4 0 > /dev/null # Q D
+$dir/raid6check $md0 repair  3 3 1 > /dev/null # P D
+$dir/raid6check $md0 repair  6 4 5 > /dev/null # D<D
+$dir/raid6check $md0 repair 13 5 4 > /dev/null # D>D
+blockdev --flushbufs $devs; sync
+echo 3 > /proc/sys/vm/drop_caches
+$dir/raid6check $md0 0 0 2>&1 | grep -qs "Error" && { echo errors detected; exit 2; }
+cmp -s -n $array_data_size_in_b $md0 /tmp/RandFile || { echo should not mess up correct stripe ; exit 2; }
+
+mdadm -S $md0
+udevadm settle
+blockdev --flushbufs $md0 $devs; sync
+
-- 
1.7.3.4


--nextPart1582456.XmQuSP4jmf
Content-Disposition: attachment; filename="0004-raid6check-Extract-un-locking-into-functions.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0004-raid6check-Extract-un-locking-into-functions.patch"

From b5f457753f2888444f5cd40690d2bd250e53f0dd Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Fri, 20 Jul 2012 16:00:14 +0200
Subject: [PATCH 4/5] raid6check: Extract (un)locking into functions

---
 raid6check.c |   90 ++++++++++++++++++++++++++++++---------------------------
 1 files changed, 47 insertions(+), 43 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index 51e7cca..4aeafad 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -107,6 +107,38 @@ int raid6_stats(int *results, int raid_disks, int chunk_size)
 	return curr_broken_disk;
 }
 
+int lock_stripe(struct mdinfo *info, unsigned long long start,
+		int chunk_size, int data_disks, sighandler_t *sig) {
+	int rv;
+	if(mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
+		return 2;
+	}
+
+	sig[0] = signal(SIGTERM, SIG_IGN);
+	sig[1] = signal(SIGINT, SIG_IGN);
+	sig[2] = signal(SIGQUIT, SIG_IGN);
+
+	rv = sysfs_set_num(info, NULL, "suspend_lo", start * chunk_size * data_disks);
+	rv |= sysfs_set_num(info, NULL, "suspend_hi", (start + 1) * chunk_size * data_disks);
+	return rv * 256;
+}
+
+int unlock_all_stripes(struct mdinfo *info, sighandler_t *sig) {
+	int rv;
+	rv = sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+	rv |= sysfs_set_num(info, NULL, "suspend_hi", 0);
+	rv |= sysfs_set_num(info, NULL, "suspend_lo", 0);
+
+	signal(SIGQUIT, sig[2]);
+	signal(SIGINT, sig[1]);
+	signal(SIGTERM, sig[0]);
+
+	if(munlockall() != 0)
+		return 3;
+	return rv * 256;
+}
+
+
 int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		  int raid_disks, int chunk_size, int level, int layout,
 		  unsigned long long start, unsigned long long length, char *name[],
@@ -120,13 +152,12 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 	uint8_t *p = xmalloc(chunk_size);
 	uint8_t *q = xmalloc(chunk_size);
 	int *results = xmalloc(chunk_size * sizeof(int));
+	sighandler_t *sig = xmalloc(3 * sizeof(sighandler_t));
 
 	int i;
 	int diskP, diskQ;
 	int data_disks = raid_disks - 2;
 	int err = 0;
-	sighandler_t sig[3];
-	int rv;
 
 	extern int tables_ready;
 
@@ -141,34 +172,19 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 
 		printf("pos --> %llu\n", start);
 
-		if(mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
-			err = 2;
+		err = lock_stripe(info, start, chunk_size, data_disks, sig);
+		if(err != 0) {
+			if (err != 2)
+				unlock_all_stripes(info, sig);
 			goto exitCheck;
 		}
-		sig[0] = signal(SIGTERM, SIG_IGN);
-		sig[1] = signal(SIGINT, SIG_IGN);
-		sig[2] = signal(SIGQUIT, SIG_IGN);
-		rv = sysfs_set_num(info, NULL, "suspend_lo", start * chunk_size * data_disks);
-		rv |= sysfs_set_num(info, NULL, "suspend_hi", (start + 1) * chunk_size * data_disks);
 		for (i = 0 ; i < raid_disks ; i++) {
 			lseek64(source[i], offsets[i] + start * chunk_size, 0);
 			read(source[i], stripes[i], chunk_size);
 		}
-		rv |= sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
-		rv |= sysfs_set_num(info, NULL, "suspend_hi", 0);
-		rv |= sysfs_set_num(info, NULL, "suspend_lo", 0);
-		signal(SIGQUIT, sig[2]);
-		signal(SIGINT, sig[1]);
-		signal(SIGTERM, sig[0]);
-		if(munlockall() != 0) {
-			err = 3;
-			goto exitCheck;
-		}
-
-		if(rv != 0) {
-			err = rv * 256;
+		err = unlock_all_stripes(info, sig);
+		if(err != 0)
 			goto exitCheck;
-		}
 
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start, raid_disks, level, layout);
@@ -252,34 +268,22 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 					raid6_2data_recov(raid_disks, chunk_size, failed_block_index1, failed_block_index2, (uint8_t**)blocks);
 				}
 			}
-			if(mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
-				err = 2;
+
+			err = lock_stripe(info, start, chunk_size, data_disks, sig);
+			if(err != 0) {
+				if (err != 2)
+					unlock_all_stripes(info, sig);
 				goto exitCheck;
 			}
-			sig[0] = signal(SIGTERM, SIG_IGN);
-			sig[1] = signal(SIGINT, SIG_IGN);
-			sig[2] = signal(SIGQUIT, SIG_IGN);
-			rv = sysfs_set_num(info, NULL, "suspend_lo", start * chunk_size * data_disks);
-			rv |= sysfs_set_num(info, NULL, "suspend_hi", (start + 1) * chunk_size * data_disks);
+
 			lseek64(source[failed_disk1], offsets[failed_disk1] + start * chunk_size, 0);
 			write(source[failed_disk1], stripes[failed_disk1], chunk_size);
 			lseek64(source[failed_disk2], offsets[failed_disk2] + start * chunk_size, 0);
 			write(source[failed_disk2], stripes[failed_disk2], chunk_size);
-			rv |= sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
-			rv |= sysfs_set_num(info, NULL, "suspend_hi", 0);
-			rv |= sysfs_set_num(info, NULL, "suspend_lo", 0);
-			signal(SIGQUIT, sig[2]);
-			signal(SIGINT, sig[1]);
-			signal(SIGTERM, sig[0]);
-			if(munlockall() != 0) {
-				err = 3;
-				goto exitCheck;
-			}
 
-			if(rv != 0) {
-				err = rv * 256;
+			err = unlock_all_stripes(info, sig);
+			if(err != 0)
 				goto exitCheck;
-			}
 		}
 
 
-- 
1.7.3.4


--nextPart1582456.XmQuSP4jmf
Content-Disposition: attachment; filename="0005-raid6check-Auto-repair-mode.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0005-raid6check-Auto-repair-mode.patch"

From f49a80c54716114375511fdc3609209275269afa Mon Sep 17 00:00:00 2001
From: Robert Buchholz <rbu@goodpoint.de>
Date: Fri, 20 Jul 2012 16:01:53 +0200
Subject: [PATCH 5/5] raid6check: Auto-repair mode

When calling raid6check in regular scanning mode, specifiying
"autorepair" as the last positional parameter will cause it
to automatically repair any single slot failes it identifies.
---
 raid6check.c             |   33 ++++++++++++++++++++++++++++++++-
 tests/19raid6auto-repair |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 1 deletions(-)
 create mode 100644 tests/19raid6auto-repair

diff --git a/raid6check.c b/raid6check.c
index 4aeafad..e9a17a7 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -284,6 +284,35 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 			err = unlock_all_stripes(info, sig);
 			if(err != 0)
 				goto exitCheck;
+		} else if (disk >= 0 && repair == 2) {
+			printf("Auto-repairing slot %d (%s)\n", disk, name[disk]);
+			if (disk == diskQ) {
+				qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
+			} else {
+				char *all_but_failed_blocks[data_disks];
+				int failed_block_index = block_index_for_slot[disk];
+				for (i=0; i < data_disks; i++)
+					if (failed_block_index == i)
+						all_but_failed_blocks[i] = stripes[diskP];
+					else
+						all_but_failed_blocks[i] = blocks[i];
+				xor_blocks(stripes[disk],
+					all_but_failed_blocks, data_disks, chunk_size);
+			}
+
+			err = lock_stripe(info, start, chunk_size, data_disks, sig);
+			if(err != 0) {
+				if (err != 2)
+					unlock_all_stripes(info, sig);
+				goto exitCheck;
+			}
+
+			lseek64(source[disk], offsets[disk] + start * chunk_size, 0);
+			write(source[disk], stripes[disk], chunk_size);
+
+			err = unlock_all_stripes(info, sig);
+			if(err != 0)
+				goto exitCheck;
 		}
 
 
@@ -343,7 +372,7 @@ int main(int argc, char *argv[])
 		prg++;
 
 	if (argc < 4) {
-		fprintf(stderr, "Usage: %s md_device start_stripe length_stripes\n", prg);
+		fprintf(stderr, "Usage: %s md_device start_stripe length_stripes [autorepair]\n", prg);
 		fprintf(stderr, "   or: %s md_device repair stripe failed_slot_1 failed_slot_2\n", prg);
 		exit_err = 1;
 		goto exitHere;
@@ -441,6 +470,8 @@ int main(int argc, char *argv[])
 	else {
 		start = getnum(argv[2], &err);
 		length = getnum(argv[3], &err);
+		if (argc >= 5 && strcmp(argv[4], "autorepair")==0)
+			repair = 2;
 	}
 
 	if (err) {
diff --git a/tests/19raid6auto-repair b/tests/19raid6auto-repair
new file mode 100644
index 0000000..6665458
--- /dev/null
+++ b/tests/19raid6auto-repair
@@ -0,0 +1,43 @@
+number_of_disks=5
+chunksize_in_kib=512
+chunksize_in_b=$[chunksize_in_kib*1024]
+array_data_size_in_kib=$[chunksize_in_kib*(number_of_disks-2)*number_of_disks]
+array_data_size_in_b=$[array_data_size_in_kib*1024]
+devs="$dev0 $dev1 $dev2 $dev3 $dev4"
+
+# default 32 sectors
+data_offset_in_kib=$[32/2]
+
+# make a raid5 from a file
+dd if=/dev/urandom of=/tmp/RandFile bs=1024 count=$array_data_size_in_kib
+mdadm -CR $md0 -l6 -n$number_of_disks -c $chunksize_in_kib $devs
+dd if=/tmp/RandFile of=$md0 bs=1024 count=$array_data_size_in_kib
+blockdev --flushbufs $md0; sync
+check wait
+blockdev --flushbufs $devs; sync
+echo 3 > /proc/sys/vm/drop_caches
+cmp -s -n $array_data_size_in_b $md0 /tmp/RandFile || { echo sanity cmp failed ; exit 2; }
+
+# wipe out 5 chunks on each device
+dd if=/dev/urandom of=$dev0 bs=1024 count=$[5*chunksize_in_kib] seek=$[data_offset_in_kib+chunksize_in_kib*0]
+dd if=/dev/urandom of=$dev1 bs=1024 count=$[5*chunksize_in_kib] seek=$[data_offset_in_kib+chunksize_in_kib*5]
+dd if=/dev/urandom of=$dev2 bs=1024 count=$[5*chunksize_in_kib] seek=$[data_offset_in_kib+chunksize_in_kib*10]
+dd if=/dev/urandom of=$dev3 bs=1024 count=$[5*chunksize_in_kib] seek=$[data_offset_in_kib+chunksize_in_kib*15]
+dd if=/dev/urandom of=$dev4 bs=1024 count=$[5*chunksize_in_kib] seek=$[data_offset_in_kib+chunksize_in_kib*20]
+
+blockdev --flushbufs $devs; sync
+echo 3 > /proc/sys/vm/drop_caches
+
+$dir/raid6check $md0 0 0 2>&1 | grep -qs "Error" || { echo should detect errors; exit 2; }
+
+$dir/raid6check $md0 0 0 autorepair > /dev/null || { echo repair failed; exit 2; }
+blockdev --flushbufs $md0 $devs; sync
+echo 3 > /proc/sys/vm/drop_caches
+
+$dir/raid6check $md0 0 0 2>&1 | grep -qs "Error" && { echo errors detected; exit 2; }
+cmp -s -n $array_data_size_in_b $md0 /tmp/RandFile || { echo cmp failed ; exit 2; }
+
+mdadm -S $md0
+udevadm settle
+blockdev --flushbufs $md0 $devs; sync
+echo 3 > /proc/sys/vm/drop_caches
-- 
1.7.3.4


--nextPart1582456.XmQuSP4jmf--

--nextPart2636717.dGg27Vs2rt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABCgAGBQJQK5xQAAoJECaaHo/OfoM5zHcP/R2xVNtV8O+M436uQPHY8O+O
LmGXGufoMGKnUHIH0thKWQczoQHvqUrdRQEof+FrqElJx5k9GEKzMQEEWbwRItUX
NKf4Sin8CZontgKGsExKyA+S7VvkwVCbYLd7ULNUjfwcAJNeWCF3cT8I/STksTLR
PTUS5UwMSTLdou1F37Oxg0MIoaMbQkmivibNQeHyfTodD2F6TjBRCDYdt0pQIhxm
YGZyAZwij+ovumTOcrekBwev0HpXdJE7srtwmnVVGy7m+WOkdtmmUIOXWXYqKP7l
PAb1BoMytd2bxhEWuAekGvPqPA0wiM6FC2ToJw9pQ6JWxm/N7fXczJSXzW5a/7+a
7clpJyCEaA61kEnLhyqtjlKf2HDeai79SPAdh1KhEOC1TgsDpBBz3Q3kwcMR/0XF
/dxl5jPEz0lznfV97PwD/VhcViSd277YHexxGeKH3lSi4pd7WGga89UmkYm1FBuR
nTFBbtC9FHIZ70ZZ+s7JYPWE9FLsdw3u54Gtd8UVF7EtTgZUTcnOJd7dsI0UAgWE
3Ds1Mp06/TNAogWmWmGnGe3lIl7MIBGgbqRX/8sAcS84B1gAZGG6S27pv3vg/K8D
doCprnG2lF5VP1LEt0+yzSmfPeeRzFi1IYYcSSSdNA9MCykkxLRzvqZYBmoDKHL8
8uFovKqyYcxjsyigzMYD
=nLNT
-----END PGP SIGNATURE-----

--nextPart2636717.dGg27Vs2rt--

