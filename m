From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 2/2] md bitmap bug fixes
Date: Wed, 09 Mar 2005 17:19:54 -0500
Message-ID: <422F768A.8010109@steeleye.com>
References: <422F7621.8090602@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060006010702010203070006"
In-Reply-To: <422F7621.8090602@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060006010702010203070006
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here's the mdadm patch...

Paul Clements wrote:
> Neil,
> 
> here are a couple of patches -- this one for the kernel, the next for 
> mdadm. They fix a few issues that I found while testing the new bitmap 
> intent logging code.
> 
> Briefly, the issues were:
> 
> kernel:
> 
> added call to bitmap_daemon_work() from raid1d so that the bitmap would 
> actually get cleared
> 
> fixed the marking of pages with BITMAP_CLEAN so that the bitmap would 
> get cleared correctly after resync and normal write I/O
> 
> pass back errors from write_page() since it now does actual writes itself
> 
> sync_size changed to sectors (was array_size which was KB) -- some 
> divisions by 2 were needed
> 
> mdadm:
> 
> avoid setting of sb->events_lo = 1 when creating a 0.90 superblock -- it 
> doesn't seem to be necessary and it was causing the event counters to 
> start at 4 billion+ (events_lo is actually the high part of the events 
> counter, on little endian machines anyway)
> 
> some sync_size changes, as in the kernel
> 
> if'ed out super1 definition which is now in the kernel headers
> 
> included sys/time.h to avoid compile error
> 
> 
> Thanks,
> Paul

--------------060006010702010203070006
Content-Type: text/plain;
 name="mdadm_2_0_devel_1_bitmap_bug_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm_2_0_devel_1_bitmap_bug_fix.diff"

diff -purN --exclude makepkg --exclude rpm --exclude *.DIST --exclude md_u.h --exclude md_p.h --exclude bitmap.h --exclude mdadm.steeleye.spec --exclude-from /export/public/clemep/tmp/dontdiff mdadm-2.0-devel-1-PRISTINE/bitmap.c mdadm-2.0-devel-1-bitmap-bug-fix/bitmap.c
--- mdadm-2.0-devel-1-PRISTINE/bitmap.c	Sun Feb 13 22:00:00 2005
+++ mdadm-2.0-devel-1-bitmap-bug-fix/bitmap.c	Mon Mar  7 12:15:38 2005
@@ -168,7 +168,8 @@ bitmap_info_t *bitmap_fd_read(int fd, in
 
 	if (read_bits < total_bits) { /* file truncated... */
 		fprintf(stderr, Name ": WARNING: bitmap file is not large "
-			"enough for array size %llu!\n\n", info->sb.sync_size);
+			"enough for array size %lluKB (%llu/%llu)!\n\n",
+			info->sb.sync_size / 2, read_bits, total_bits);
 		total_bits = read_bits;
 	}
 out:
@@ -226,13 +227,16 @@ int ExamineBitmap(char *filename, int br
 					*(__u32 *)(sb->uuid+4),
 					*(__u32 *)(sb->uuid+8),
 					*(__u32 *)(sb->uuid+12));
-	printf("          Events : %llu\n", sb->events);
-	printf("  Events Cleared : %llu\n", sb->events_cleared);
+	printf("          Events : %llu (%d.%llu)\n", sb->events,
+					(__u32)sb->events, sb->events >> 32);
+	printf("  Events Cleared : %llu (%d.%llu)\n", sb->events_cleared,
+					(__u32)sb->events_cleared,
+					sb->events_cleared >> 32);
 	printf("           State : %s\n", bitmap_state(sb->state));
 	printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
 	printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
-	printf("       Sync Size : %llu%s\n", sb->sync_size,
-					human_size(sb->sync_size * 1024));
+	printf("       Sync Size : %lluKB%s\n", sb->sync_size / 2,
+					human_size(sb->sync_size * 512));
 	if (brief)
 		goto free_info;
 	printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
diff -purN --exclude makepkg --exclude rpm --exclude *.DIST --exclude md_u.h --exclude md_p.h --exclude bitmap.h --exclude mdadm.steeleye.spec --exclude-from /export/public/clemep/tmp/dontdiff mdadm-2.0-devel-1-PRISTINE/mdstat.c mdadm-2.0-devel-1-bitmap-bug-fix/mdstat.c
--- mdadm-2.0-devel-1-PRISTINE/mdstat.c	Tue Aug 10 21:28:50 2004
+++ mdadm-2.0-devel-1-bitmap-bug-fix/mdstat.c	Mon Mar  7 11:09:29 2005
@@ -86,6 +86,7 @@
 #include	"mdadm.h"
 #include	"dlink.h"
 #include	<sys/select.h>
+#include	<sys/time.h>
 
 void free_mdstat(struct mdstat_ent *ms)
 {
diff -purN --exclude makepkg --exclude rpm --exclude *.DIST --exclude md_u.h --exclude md_p.h --exclude bitmap.h --exclude mdadm.steeleye.spec --exclude-from /export/public/clemep/tmp/dontdiff mdadm-2.0-devel-1-PRISTINE/super0.c mdadm-2.0-devel-1-bitmap-bug-fix/super0.c
--- mdadm-2.0-devel-1-PRISTINE/super0.c	Sun Feb 13 21:59:45 2005
+++ mdadm-2.0-devel-1-bitmap-bug-fix/super0.c	Mon Mar  7 13:27:38 2005
@@ -364,7 +364,8 @@ static int init_super0(void **sbp, mdu_a
 	sb->failed_disks = info->failed_disks;
 	sb->spare_disks = info->spare_disks;
 	sb->events_hi = 0;
-	sb->events_lo = 1;
+	// PRC: why? sb->events_lo = 1;
+	sb->events_lo = 0;
 
 	sb->layout = info->layout;
 	sb->chunk_size = info->chunk_size;
diff -purN --exclude makepkg --exclude rpm --exclude *.DIST --exclude md_u.h --exclude md_p.h --exclude bitmap.h --exclude mdadm.steeleye.spec --exclude-from /export/public/clemep/tmp/dontdiff mdadm-2.0-devel-1-PRISTINE/super1.c mdadm-2.0-devel-1-bitmap-bug-fix/super1.c
--- mdadm-2.0-devel-1-PRISTINE/super1.c	Sun Feb 13 22:00:44 2005
+++ mdadm-2.0-devel-1-bitmap-bug-fix/super1.c	Mon Mar  7 11:34:16 2005
@@ -37,6 +37,7 @@
  * total size: 256 bytes plus 2 per device.
  *  1K allows 384 devices.
  */
+#if 0 // already in kernel headers:
 struct mdp_superblock_1 {
 	/* constant array information - 128 bytes */
 	__u32	magic;		/* MD_SB_MAGIC: 0xa92b4efc - little endian */
@@ -82,6 +83,8 @@ struct mdp_superblock_1 {
 	 */
 	__u16	dev_roles[0];	/* role in array, or 0xffff for a spare, or 0xfffe for faulty */
 };
+
+#endif
 
 #ifndef offsetof
 #define offsetof(t,f) ((int)&(((t*)0)->f))

--------------060006010702010203070006--
