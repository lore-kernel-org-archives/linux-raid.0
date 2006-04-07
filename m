From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Make sure 64bit fields in version-1 metadata are 64-bit aligned.
Date: Fri, 7 Apr 2006 14:25:15 +1000
Message-ID: <1060407042515.22091@suse.de>
References: <20060407142239.19652.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This patch should go in 2.6.17-rc2 if at all possible.  If the problem
gets left much longer, a more ugly solution might be needed.

### Comments for Changeset

reshape_position is a 64bit field that was not 64bit aligned.
So swap with new_level.

NOTE: this is a user-visible change.  However:
  - The bad code has not appeared in a released kernel
  - This code is still marked 'experimental'
  - This only affects version-1 superblock, which are not in wide use
  - These field are only used (rather than simply reported) by user-space
    tools in extemely rare circumstances : after a reshape crashes in the
    first second of the reshape process.

So I believe that, at this stage, the change is safe.  Especially if
people heed the 'help' message on use mdadm-2.4.1.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/Kconfig        |   11 ++++++-----
 ./include/linux/raid/md_p.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff ./drivers/md/Kconfig~current~ ./drivers/md/Kconfig
--- ./drivers/md/Kconfig~current~	2006-04-07 14:15:42.000000000 +1000
+++ ./drivers/md/Kconfig	2006-04-07 14:16:35.000000000 +1000
@@ -139,11 +139,12 @@ config MD_RAID5_RESHAPE
 	  is online.  However it is still EXPERIMENTAL code.  It should
 	  work, but please be sure that you have backups.
 
-	  You will need a version of mdadm newer than 2.3.1.   During the
-	  early stage of reshape there is a critical section where live data
-	  is being over-written.  A crash during this time needs extra care
-	  for recovery.  The newer mdadm takes a copy of the data in the
-	  critical section and will restore it, if necessary, after a crash.
+	  You will need mdadm verion 2.4.1 or later to use this
+	  feature safely.  During the early stage of reshape there is
+	  a critical section where live data is being over-written.  A
+	  crash during this time needs extra care for recovery.  The
+	  newer mdadm takes a copy of the data in the critical section
+	  and will restore it, if necessary, after a crash.
 
 	  The mdadm usage is e.g.
 	       mdadm --grow /dev/md1 --raid-disks=6

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2006-04-07 14:11:53.000000000 +1000
+++ ./include/linux/raid/md_p.h	2006-04-07 14:14:48.000000000 +1000
@@ -227,8 +227,8 @@ struct mdp_superblock_1 {
 				 */
 
 	/* These are only valid with feature bit '4' */
-	__u64	reshape_position;	/* next address in array-space for reshape */
 	__u32	new_level;	/* new level we are reshaping to		*/
+	__u64	reshape_position;	/* next address in array-space for reshape */
 	__u32	delta_disks;	/* change in number of raid_disks		*/
 	__u32	new_layout;	/* new layout					*/
 	__u32	new_chunk;	/* new chunk size (bytes)			*/
