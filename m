From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/34] Manage reshape process in manage_reshape vector.
Date: Tue, 04 Jan 2011 15:35:26 +0100
Message-ID: <20110104143526.6697.86905.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>

The manage_reshape vector is intended to be be used as
reshape process supervisor for external metadata types.
This patch introduces dummy function and necessary definitions.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 Grow.c        |    7 ++++---
 super-intel.c |   12 ++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8fdb597..9e0a51d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1941,9 +1941,10 @@ static int reshape_array(char *container, int fd, char *devname,
 	if (st->ss->external) {
 		/* metadata handler takes it from here */
 		ping_manager(container);
-		st->ss->manage_reshape(st, backup_file);
-		frozen = 0;
-		goto release;
+		if (st->ss->manage_reshape(st, backup_file) != 1) {
+			frozen = 0;
+			goto release;
+		}
 	}
 
 	/* set up the backup-super-block.  This requires the
diff --git a/super-intel.c b/super-intel.c
index c4100ef..17737cf 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6432,6 +6432,17 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 	return ret_val;
 }
 
+/* function: manage_reshape_imsm
+* Parameters: supertype structure, backup file
+* Returms:	0 on success,
+* 		-1 if failed,
+* 		1 - management of process not supported
+*/
+int manage_reshape_imsm(struct supertype *st, char *backup)
+{
+	return 1;
+}
+
 struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
@@ -6469,6 +6480,7 @@ struct superswitch super_imsm = {
 	.default_geometry = default_geometry_imsm,
 	.get_disk_controller_domain = imsm_get_disk_controller_domain,
 	.reshape_super  = imsm_reshape_super,
+	.manage_reshape	= manage_reshape_imsm,
 
 	.external	= 1,
 	.name = "imsm",

