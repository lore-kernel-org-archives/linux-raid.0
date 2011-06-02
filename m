From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 21/22] imsm: Remove user warning before reshape start
Date: Thu, 02 Jun 2011 16:51:06 +0200
Message-ID: <20110602145106.27355.19066.stgit@gklab-128-111.igk.intel.com>
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

imsm's arrays supports imsm native check-pointing now.
User warning is no longer required.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b6369c6..f615bb1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8411,30 +8411,6 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 	return 0;
 }
 
-static int warn_user_about_risk(void)
-{
-	int rv = 0;
-
-	fprintf(stderr,
-		"\nThis is an experimental feature. Data on the RAID volume(s) "
-		"can be lost!!!\n\n"
-		"To continue command execution please make sure that\n"
-		"the grow process will not be interrupted. Use safe power\n"
-		"supply to avoid unexpected system reboot. Make sure that\n"
-		"reshaped container is not assembled automatically during\n"
-		"system boot.\n"
-		"If reshape is interrupted, assemble array manually\n"
-		"using e.g. '-Ac' option and up to date mdadm.conf file.\n"
-		"Assembly in scan mode is not possible in such case.\n"
-		"Growing container with boot array is not possible.\n"
-		"If boot array reshape is interrupted, whole file system\n"
-		"can be lost.\n\n");
-	rv = ask("Do you want to continue? ");
-	fprintf(stderr, "\n");
-
-	return rv;
-}
-
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			      int layout, int chunksize, int raid_disks,
 			      int delta_disks, char *backup, char *dev,
@@ -8468,13 +8444,6 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		dprintf("imsm: info: Container operation\n");
 		int old_raid_disks = 0;
 
-		/* this warning will be removed when imsm checkpointing
-		 * will be implemented, and restoring from check-point
-		 * operation will be transparent for reboot process
-		 */
-		if (warn_user_about_risk() == 0)
-			return ret_val;
-
 		if (imsm_reshape_is_allowed_on_container(
 			    st, &geo, &old_raid_disks)) {
 			struct imsm_update_reshape *u = NULL;

