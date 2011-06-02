From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 13/22] Add reshape restart support for external metadata
Date: Thu, 02 Jun 2011 16:49:59 +0200
Message-ID: <20110602144959.27355.53964.stgit@gklab-128-111.igk.intel.com>
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

Patch introduces support for reshape process restart for external metadata
using metadata specific data handling methods.
It introduces recover_backup() function that restores array to stable state
It is equivalent to Grow_restart() functionality for native metadata.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Assemble.c |   10 ++++++++--
 mdadm.h    |    3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 8b05829..f085f7c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1192,7 +1192,10 @@ int Assemble(struct supertype *st, char *mddev,
 				fdlist[i] = -1;
 		}
 		if (!err) {
-			err = Grow_restart(st, content, fdlist, bestcnt,
+			if (st->ss->external && st->ss->recover_backup)
+				err = st->ss->recover_backup(st, content);
+			else
+				err = Grow_restart(st, content, fdlist, bestcnt,
 					   backup_file, verbose > 0);
 			if (err && invalid_backup) {
 				if (verbose > 0)
@@ -1573,7 +1576,10 @@ int assemble_container_content(struct supertype *st, int mdfd,
 				else
 					fdlist[spare++] = fd;
 			}
-			err = Grow_restart(st, content, fdlist, spare,
+			if (st->ss->external && st->ss->recover_backup)
+				err = st->ss->recover_backup(st, content);
+			else
+				err = Grow_restart(st, content, fdlist, spare,
 					   backup_file, verbose > 0);
 			while (spare > 0) {
 				spare--;
diff --git a/mdadm.h b/mdadm.h
index a1ae2b9..50042b0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -785,6 +785,9 @@ extern struct superswitch {
 	 */
 	const char *(*get_disk_controller_domain)(const char *path);
 
+	/* for external backup area */
+	int (*recover_backup)(struct supertype *st, struct mdinfo *info);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */

