From: Robert Buchholz <robert.buchholz@goodpoint.de>
Subject: Re: [PATCH] Re: Find mismatch in data blocks during raid6 repair
Date: Fri, 20 Jul 2012 16:14:48 +0200
Message-ID: <3729302.tDQWQuMiBv@peanut>
References: <10900468.MPSjVn2C3J@peanut> <20120709134308.0ea5b18d@notabene.brown> <2060628.pGJ05f4kvM@peanut>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1927305.LO2TWtfWQK"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2060628.pGJ05f4kvM@peanut>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nextPart1927305.LO2TWtfWQK
Content-Type: multipart/mixed; boundary="nextPart1940949.spPzW1NZVk"
Content-Transfer-Encoding: 7Bit


--nextPart1940949.spPzW1NZVk
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, July 20, 2012 12:40:04 PM Robert Buchholz wrote:
> I have attached three patches against your latest HEAD.
> The first fixes compilation of the raid6check tool after the xmalloc
> refactoring. The other two are bugfixes in the repair code. The latter
> bug is somewhat embarrassing, I used geo_map in the wrong direction,
> yielding incorrect data block indices to repair. This will lead to a
> data corruption on the stripe in most cases (interestingly, not in my
> test case due to the way the raid size and stripe index were chosen).

Please find attached a revised version of patch 3 in my previous email 
(0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch). The 
original version did not handle the the P/Q repair case correctly, this 
patch replaces the previous file.

In addition, autorepair mode is added by the other two patches in this 
email. To fix all slots that are detected faulty, one can run
  # raid6check /dev/mdX 0 0 autorepair
The same considerations regarding caching apply, i.e. the array should 
not be in use and caches flushed before any usage.

We should probably update the tool's man page for this.


Cheers,

Robert

--nextPart1940949.spPzW1NZVk
Content-Disposition: attachment; filename="0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0003-raid6check-Repair-mode-used-geo_map-incorrectly.patch"

From 812c1feae3540a3671492cb4a32b1903aa17dece Mon Sep 17 00:00:00 2001
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


--nextPart1940949.spPzW1NZVk
Content-Disposition: attachment; filename="0004-raid6check-Extract-un-locking-into-functions.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0004-raid6check-Extract-un-locking-into-functions.patch"

From 2fabd1507a0bcf9ae0f2af888e6dcd0fac580027 Mon Sep 17 00:00:00 2001
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


--nextPart1940949.spPzW1NZVk
Content-Disposition: attachment; filename="0005-raid6check-Auto-repair-mode.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0005-raid6check-Auto-repair-mode.patch"

From 530bf005a45cd79f77c2a726874a1a7da84064d5 Mon Sep 17 00:00:00 2001
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


--nextPart1940949.spPzW1NZVk--

--nextPart1927305.LO2TWtfWQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABCgAGBQJQCWfYAAoJECaaHo/OfoM5GaQP/A9AsbyuZYPWkwIXeoJBkjQ5
xna6TJngUIT412cWFafR4W5iiBNeXVyJ/Sa1F47NUR+XahNh7vwYYJHTYlaxz+Py
eLQ9zz5mm4PrLa9FEwJmrhyOeZRsCIkpCgoOKnZrevj4q3FUqydpE76Fm/tUattE
7M8/FNxQF/HZ+sjJdA6wEaEnH79IHVTe3Y3jqmaqY8tPX6tZCXlT47JmvqJpT69i
vhIo7z4pR4PCyW6VxLdYDld7t0Kjg1gJHe9JOvMOdrF5s+hgCXtgybugX9c0bYV8
RBMIfHgZtQF0qYdlS1MKEtnPKgSUl5a7v4p5ZC6dmhjT7KcMnEpEL9hLY/DABfmb
iK8fcgkcwOZf0TqnubN+xa/MMNy2kOpREm+A15clU4CR+xK6NyEt1g3xYKR+TuhU
9j65UQiiM0vDlCdVvCft4tqv73SQZTgI83HH4CO6HLF6haps2DuoMnHS8pap+q0l
LkoQtdJ7rKu/Vd8RSsA2wyMsx0iOU1YpNyzsk8bC2aYUrNrEgJ+r6MSog1H6Yi9W
B2ZLw71AH3Siy1+LQL+Dv3AdCgof2wweZ7TyrO3MjMa2bpX46Hh6VrPHDebaaaKH
hcJu+0sQNqPDXAD8B2KiEnlSX6Zi1upmGIXjoHvnu8qoyieFTS8h3MYL07VXyCIg
DJXTV6j7WZNmHy3GLrdr
=E+BK
-----END PGP SIGNATURE-----

--nextPart1927305.LO2TWtfWQK--

