From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/3] imsm: Warn user about reboot risk
Date: Tue, 05 Apr 2011 15:46:09 +0200
Message-ID: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Current check-pointing implementation doesn't allow for interrupting reshape of boot arrays
due to checkpoint restore has to be done before system start.
There is problem with passing backup file name to array automatically mounted during boot time,
especially when scan mode is used.

Until IMSM check-pointing implementation will be introduced, warning about reboot risk
should be placed in mdadm.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 62ccd15..9c2caf7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7251,6 +7251,29 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 	return 0;
 }
 
+static int warn_user_about_risk(void)
+{
+	int rv = 0;
+
+	fprintf(stderr,
+		"\nThis is experimental feature. Data on the RAID volume(s) "
+		"can be lost!!!\n\n"
+		"To continue command execution please make sure that\n"
+		"grow process will not be interrupted. Use safe power\n"
+		"supply to avoid unexpected system reboot. Make sure that\n"
+		"reshaped container is not assembled automatically during\n"
+		"system boot.\n"
+		"If reshape is be interrupted, assemble array manually\n"
+		"using e.g. '-Ac' option and up to date mdadm.conf file.\n"
+		"Assembly in scan mode is not possible in such case.\n"
+		"Growing container with boot array is not possible.\n"
+		"If boot array reshape is interrupted, whole file system\n"
+		"can be lost.\n\n");
+	rv = ask("Do you want to continue? ");
+	fprintf(stderr, "\n");
+
+	return rv;
+}
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			      int layout, int chunksize, int raid_disks,
 			      int delta_disks, char *backup, char *dev,
@@ -7283,6 +7306,14 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		/* On container level we can only increase number of devices. */
 		dprintf("imsm: info: Container operation\n");
 		int old_raid_disks = 0;
+
+		/* this warning will be removed when imsm checkpointing
+		 * will be implemented, and restoring from check-point
+		 * operation will be transparent for reboot process
+		 */
+		if (warn_user_about_risk() == 0)
+			return ret_val;
+
 		if (imsm_reshape_is_allowed_on_container(
 			    st, &geo, &old_raid_disks)) {
 			struct imsm_update_reshape *u = NULL;

