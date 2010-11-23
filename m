From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/21] imsm: FIX: imsm_check_reshape_conditions change ret_val
Date: Tue, 23 Nov 2010 13:40:02 +0100
Message-ID: <20101123124001.17770.35323.stgit@gklab-170-024.igk.intel.com>
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

Put information to return variable (ret_val) in more clear way.
manage_reshape will always unfreeze container
and this will not base on return value as it has to be always unfrozen,
on success and on error.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index f628c2c..b58eb5f 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -7969,7 +7969,7 @@ exit_imsm_check_reshape_conditions:
 
 int imsm_manage_container_reshape(struct supertype *st)
 {
-	int ret_val = 0;
+	int ret_val = 1;
 	char buf[PATH_MAX];
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
@@ -8028,12 +8028,10 @@ int imsm_manage_container_reshape(struct supertype *st)
 	find_array_minor(info2.name, 1, &current_array);
 	if (current_array < 0) {
 		dprintf("imsm. Error.Cannot get first array.\n");
-		ret_val = 1;
 		goto imsm_manage_container_reshape_exit;
 	}
 	if (imsm_check_reshape_conditions(fd, st, current_array)) {
 		dprintf("imsm. Error. Wrong reshape conditions.\n");
-		ret_val = 1;
 		goto imsm_manage_container_reshape_exit;
 	}
 	raid_disks = info2.array.raid_disks;
@@ -8128,6 +8126,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 			close(fd2);
 			if (ret_val) {
 				dprintf("Reshape is broken (cannot reshape)\n");
+				ret_val = 1;
 				goto imsm_manage_container_reshape_exit;
 			}
 			current_array = -1;
@@ -8156,6 +8155,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 
 						if (imsm_check_reshape_conditions(fd, st, current_array)) {
 							dprintf("imsm. Error. Wrong reshape conditions.\n");
+							ret_val = 1;
 							current_array = -1;
 						}
 					} else
@@ -8205,8 +8205,10 @@ int imsm_manage_reshape(struct supertype *st, char *backup)
 		return ret_val;
 	}
 	ret_val = imsm_manage_container_reshape(st);
-	if (ret_val)
-		unfreeze_container(st);
+	/* unfreeze on error and success
+	 * for any result this is end of work
+	 */
+	unfreeze_container(st);
 
 	return ret_val;
 }

