From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 18/27] Change manage_reshape() placement
Date: Mon, 06 Dec 2010 14:23:07 +0100
Message-ID: <20101206132307.21125.6065.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

After reshape_super() call manage_reshape() should do the same things
as grow_reshape() for native metadata case (for execution on array).
The difference is on reshape finish only, when md finishes his work.
For external metadata size is managed externally from md point of view,
so specific to metadata action is required there.
This causes moving manage_reshape() placement to add necessary actions only
to common flow and not duplicate current code.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/Grow.c b/Grow.c
index f03dcc9..b51c4d0 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1783,14 +1783,6 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			break;
 		}
 
-		if (st->ss->external) {
-			/* metadata handler takes it from here */
-			ping_manager(container);
-			st->ss->manage_reshape(st, backup_file);
-			frozen = 0;
-			break;
-		}
-
 		/* set up the backup-super-block.  This requires the
 		 * uuid from the array.
 		 */
@@ -1854,6 +1846,15 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 						       d - odisks, fdlist+odisks, offsets+odisks);
 			if (backup_file && done)
 				unlink(backup_file);
+
+			/* manage/finalize reshape in metadata specific way
+			 */
+			close(fd);
+			if (st->ss->external && st->ss->manage_reshape) {
+				st->ss->manage_reshape(st, backup_file);
+				break;
+			}
+
 			if (level != UnSet && level != array.level) {
 				/* We need to wait for the reshape to finish
 				 * (which will have happened unless odata < ndata)
@@ -1864,8 +1865,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				if (c == NULL)
 					exit(0);/* not possible */
 
-				if (odata < ndata)
-					wait_reshape(sra);
+				/* child process has always wait for reshape finish
+				 * to perform unfreeze
+				 */
+				wait_reshape(sra);
 				err = sysfs_set_str(sra, NULL, "level", c);
 				if (err)
 					fprintf(stderr, Name ": %s: could not set level to %s\n",

