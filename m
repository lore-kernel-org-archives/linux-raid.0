From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] imsm: Add metadata abort changes handler template
Date: Mon, 14 Mar 2011 15:09:47 +0100
Message-ID: <20110314140947.20478.79718.stgit@gklab-128-013.igk.intel.com>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Add metadata rollback function implementation/placeholder
for imsm metadata.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 44c100b..2c2bd1e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7364,6 +7364,20 @@ static int imsm_manage_reshape(
 		afd, sra, reshape, st, stripes,
 		fds, offsets, dests, destfd, destoffsets);
 }
+
+/* imsm metadata rollback handler, manage metadata for error scenario
+ */
+static int imsm_abort_metadata_changes(struct supertype *st)
+{
+	int ret_val = -1;
+
+	dprintf("imsm: imsm_abort_metadata_changes() called\n");
+
+	/* ToDo: when possible, prepare rollback metadata update
+	 */
+
+	return ret_val;
+}
 #endif /* MDASSEMBLE */
 
 struct superswitch super_imsm = {
@@ -7386,6 +7400,7 @@ struct superswitch super_imsm = {
 	.get_disk_controller_domain = imsm_get_disk_controller_domain,
 	.reshape_super  = imsm_reshape_super,
 	.manage_reshape = imsm_manage_reshape,
+	.abort_metadata_changes = imsm_abort_metadata_changes,
 #endif
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,

