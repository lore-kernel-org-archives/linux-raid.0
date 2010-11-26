From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 46/53] FIX: Allow for reshape without backup file
Date: Fri, 26 Nov 2010 09:09:48 +0100
Message-ID: <20101126080948.5221.8930.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
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

 Grow.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7253e5a..fdc5bfd 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1659,6 +1659,11 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
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
@@ -1666,10 +1671,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
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
@@ -1678,10 +1685,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
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

