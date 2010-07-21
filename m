From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 06/10] mdadm: support restore_stripes() from the given buffer
Date: Wed, 21 Jul 2010 12:20:29 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49C4@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Currently restore_stripes() function is able to restore data only from the given backup file handles and it is used only for assembling partially reshaped arrays.
As this function will be very helpful for external metadata backup mechanism, add the support for restoring data from the given source buffer.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Grow.c     |    4 ++--
 mdadm.h    |    3 ++-
 restripe.c |   17 ++++++++++++-----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4146a05..cd09d6d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2587,7 +2587,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    info->new_layout,
 				    fd, __le64_to_cpu(bsb.devstart)*512,
 				    __le64_to_cpu(bsb.arraystart)*512,
-				    __le64_to_cpu(bsb.length)*512)) {
+				    __le64_to_cpu(bsb.length)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring backup from %s\n", @@ -2604,7 +2604,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    fd, __le64_to_cpu(bsb.devstart)*512 +
 				    __le64_to_cpu(bsb.devstart2)*512,
 				    __le64_to_cpu(bsb.arraystart2)*512,
-				    __le64_to_cpu(bsb.length2)*512)) {
+				    __le64_to_cpu(bsb.length2)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring second backup from %s\n", diff --git a/mdadm.h b/mdadm.h index baee86c..8dd8fcf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -442,7 +442,8 @@ extern int save_stripes(int *source, unsigned long long *offsets,  extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   int raid_disks, int chunk_size, int level, int layout,
 			   int source, unsigned long long read_offset,
-			   unsigned long long start, unsigned long long length);
+			   unsigned long long start, unsigned long long length,
+			   char *src_buf);
 
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
diff --git a/restripe.c b/restripe.c
index 0f226e3..4849871 100644
--- a/restripe.c
+++ b/restripe.c
@@ -556,7 +556,8 @@ int save_stripes(int *source, unsigned long long *offsets,  int restore_stripes(int *dest, unsigned long long *offsets,
 		    int raid_disks, int chunk_size, int level, int layout,
 		    int source, unsigned long long read_offset,
-		    unsigned long long start, unsigned long long length)
+		    unsigned long long start, unsigned long long length,
+		    char *src_buf)
 {
 	char *stripe_buf;
 	char **stripes = malloc(raid_disks * sizeof(char*)); @@ -592,10 +593,16 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 		for (i=0; i < data_disks; i++) {
 			int disk = geo_map(i, start/chunk_size/data_disks,
 					   raid_disks, level, layout);
-			if (lseek64(source, read_offset, 0) != read_offset)
-				return -1;
-			if (read(source, stripes[disk], chunk_size) != chunk_size)
-				return -1;
+			if (src_buf == NULL) {
+				/* read from file */
+				if (lseek64(source, read_offset, 0) != read_offset)
+					return -1;
+				if (read(source, stripes[disk], chunk_size) != chunk_size)
+					return -1;
+			} else {
+				/* read from input buffer */
+				memcpy(stripes[disk], src_buf + read_offset, chunk_size);
+			}
 			read_offset += chunk_size;
 		}
 		/* We have the data, now do the parity */

