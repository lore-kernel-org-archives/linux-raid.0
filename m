From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/16] Allow for reshape without backup file
Date: Mon, 13 Dec 2010 15:47:10 +0100
Message-ID: <20101213144710.4384.3460.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape process is guarded by metadata specific check pointing,
backup file is no longer necessary.
Remove backup file requirement from mdadm command line when reshape_super
and manage reshape_super are defined for external metadata case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   33 +++++++++++++++++++++++++--------
 super-intel.c |   15 +--------------
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/Grow.c b/Grow.c
index 02193a9..66b5ff3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1741,6 +1741,15 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto release;
 		}
 		if (backup_file == NULL) {
+			int backup_file_required_for_external;
+
+			backup_file_required_for_external = st->ss->external &&
+				st->ss->reshape_super &&
+				st->ss->manage_reshape &&
+				st->ss->save_backup &&
+				st->ss->discard_backup &&
+				st->ss->recover_backup;
+
 			if (st->ss->external && !st->ss->manage_reshape) {
 				fprintf(stderr, Name ": %s Grow operation not supported by %s metadata\n",
 					devname, st->ss->name);
@@ -1748,10 +1757,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				break;
 			}
 			if (ndata <= odata) {
-				fprintf(stderr, Name ": %s: Cannot grow - need backup-file\n",
-					devname);
-				rv = 1;
-				break;
+				if (!backup_file_required_for_external) {
+					fprintf(stderr,
+						Name": %s: Cannot grow - "\
+						"need backup-file\n",
+						devname);
+					rv = 1;
+					break;
+				}
 			} else if (sra->array.spare_disks == 0) {
 				fprintf(stderr, Name ": %s: Cannot grow - need a spare or "
 					"backup-file to backup critical section\n",
@@ -1760,10 +1773,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				break;
 			}
 			if (d == array.raid_disks) {
-				fprintf(stderr, Name ": %s: No spare device for backup\n",
-					devname);
-				rv = 1;
-				break;
+				if (!backup_file_required_for_external) {
+					fprintf(stderr,
+						Name ": %s: No spare device"\
+						"for backup\n",
+						devname);
+					rv = 1;
+					break;
+				}
 			}
 		} else {
 			if (!reshape_open_backup_file(backup_file, fd, devname,
diff --git a/super-intel.c b/super-intel.c
index 351fbbc..626ecb6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8513,16 +8513,6 @@ int imsm_child_grow(struct supertype *st,
 		return ret_val;
 	}
 
-	if (reshape_open_backup_file(backup, fd_in, "imsm",
-				     (signed)blocks,
-				     fdlist, offsets) == 0) {
-		free(fdlist);
-		free(offsets);
-		ret_val = 1;
-		return ret_val;
-	}
-	d++;
-
 	mlockall(MCL_FUTURE);
 	if (ret_val == 0) {
 		if (check_env("MDADM_GROW_VERIFY"))
@@ -8540,14 +8530,11 @@ int imsm_child_grow(struct supertype *st,
 			fdlist, offsets,
 			odisks, sra->array.chunk_size,
 			sra->array.level, sra->array.layout, odata,
-			d - odisks, fdlist + odisks, offsets + odisks);
+			d - odisks, NULL, offsets + odisks);
 		imsm_grow_manage_size(st, sra, current_vol);
 	}
 	reshape_free_fdlist(fdlist, offsets, d);
 
-	if (backup)
-		unlink(backup);
-
 	return ret_val;
 }
 

