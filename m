From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 20/22] Do not use backup file for external metadata
Date: Thu, 02 Jun 2011 16:50:58 +0200
Message-ID: <20110602145058.27355.14785.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

When external metatdata handler supports manage_reshape()
and recover_backup() functions in super switch backup file is not required
and can be omitted. For backup purposes metadata specific mechanisms
are used.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/Grow.c b/Grow.c
index 25be587..8e67be2 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2038,25 +2038,29 @@ started:
 	if (d < 0) {
 		goto release;
 	}
-	if (backup_file == NULL) {
-		if (reshape.after.data_disks <= reshape.before.data_disks) {
-			fprintf(stderr,
-				Name ": %s: Cannot grow - need backup-file\n", 
-				devname);
-			goto release;
-		} else if (sra->array.spare_disks == 0) {
-			fprintf(stderr, Name ": %s: Cannot grow - need a spare or "
-				"backup-file to backup critical section\n",
-				devname);
-			goto release;
-		}
-	} else {
-		if (!reshape_open_backup_file(backup_file, fd, devname,
-					      (signed)blocks,
-					      fdlist+d, offsets+d, restart)) {
-			goto release;
+	if ((st->ss->manage_reshape == NULL) ||
+	    (st->ss->recover_backup == NULL)) {
+		if (backup_file == NULL) {
+			if (reshape.after.data_disks <=
+			    reshape.before.data_disks) {
+				fprintf(stderr, Name ": %s: Cannot grow - "
+					"need backup-file\n", devname);
+				goto release;
+			} else if (sra->array.spare_disks == 0) {
+				fprintf(stderr, Name ": %s: Cannot grow - "
+					"need a spare or backup-file to backup "
+					"critical section\n", devname);
+				goto release;
+			}
+		} else {
+			if (!reshape_open_backup_file(backup_file, fd, devname,
+						      (signed)blocks,
+						      fdlist+d, offsets+d,
+						      restart)) {
+				goto release;
+			}
+			d++;
 		}
-		d++;
 	}
 
 	/* lastly, check that the internal stripe cache is

