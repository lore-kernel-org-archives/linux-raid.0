From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/21] FIX: Allow for reshape without backup file
Date: Tue, 23 Nov 2010 13:40:17 +0100
Message-ID: <20101123124017.17770.44180.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When reshape process is guarded by metadata specific checkpointing,
backup file is no longer necessary.
Remove backup file requirement from mdadm command line when reshape_super
and manage reshape_super are defined for external metadata case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c
index 2cabb94..127e535 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -1586,6 +1586,11 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto release;
 		}
 		if (backup_file == NULL) {
+			int backup_file_required_for_external;
+
+			backup_file_required_for_external = st->ss->external &&
+				st->ss->reshape_super && st->ss->manage_reshape;
+
 			if (st->ss->external && !st->ss->manage_reshape) {
 				fprintf(stderr, Name ": %s Grow operation not supported by %s metadata\n",
 					devname, st->ss->name);
@@ -1593,10 +1598,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				break;
 			}
 			if (ndata <= odata) {
-				fprintf(stderr, Name ": %s: Cannot grow - need backup-file\n",
-					devname);
-				rv = 1;
-				break;
+				if (!backup_file_required_for_external) {
+					fprintf(stderr, Name ": %s: Cannot grow - need backup-file\n",
+						devname);
+					rv = 1;
+					break;
+				}
 			} else if (sra->array.spare_disks == 0) {
 				fprintf(stderr, Name ": %s: Cannot grow - need a spare or "
 					"backup-file to backup critical section\n",
@@ -1605,10 +1612,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				break;
 			}
 			if (d == array.raid_disks) {
-				fprintf(stderr, Name ": %s: No spare device for backup\n",
-					devname);
-				rv = 1;
-				break;
+				if (!backup_file_required_for_external) {
+					fprintf(stderr, Name ": %s: No spare device for backup\n",
+						devname);
+					rv = 1;
+					break;
+				}
 			}
 		} else {
 			/* need to check backup file is large enough */

