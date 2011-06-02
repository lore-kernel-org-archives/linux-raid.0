From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 09/22] imsm: Check if array degradation has been changed
Date: Thu, 02 Jun 2011 16:49:26 +0200
Message-ID: <20110602144926.27355.45518.stgit@gklab-128-111.igk.intel.com>
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

Before reshaping every "migration unit", check if array is still usable.
In failed disks number is greater than allowed degradation level, reshape
has to be aborted.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b4038d3..d2393c2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8310,6 +8310,53 @@ int wait_for_reshape_imsm(struct mdinfo *sra, unsigned long long to_complete,
 }
 
 /*******************************************************************************
+ * Function:	check_degradation_change
+ * Description:	Check that array hasn't become failed.
+ * Parameters:
+ *	info	: for sysfs access
+ *	sources	: source disks descriptors
+ *	degraded: previous degradation level
+ * Returns:
+ *	degradation level
+ ******************************************************************************/
+int check_degradation_change(struct mdinfo *info,
+			     int *sources,
+			     int degraded)
+{
+	unsigned long long new_degraded;
+	sysfs_get_ll(info, NULL, "degraded", &new_degraded);
+	if (new_degraded != (unsigned long long)degraded) {
+		/* check each device to ensure it is still working */
+		struct mdinfo *sd;
+		new_degraded = 0;
+		for (sd = info->devs ; sd ; sd = sd->next) {
+			if (sd->disk.state & (1<<MD_DISK_FAULTY))
+				continue;
+			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
+				char sbuf[20];
+				if (sysfs_get_str(info,
+					sd, "state", sbuf, 20) < 0 ||
+					strstr(sbuf, "faulty") ||
+					strstr(sbuf, "in_sync") == NULL) {
+					/* this device is dead */
+					sd->disk.state = (1<<MD_DISK_FAULTY);
+					if (sd->disk.raid_disk >= 0 &&
+					    sources[sd->disk.raid_disk] >= 0) {
+						close(sources[
+							sd->disk.raid_disk]);
+						sources[sd->disk.raid_disk] =
+							-1;
+					}
+					new_degraded++;
+				}
+			}
+		}
+	}
+
+	return new_degraded;
+}
+
+/*******************************************************************************
  * Function:	imsm_manage_reshape
  * Description:	Function finds array under reshape and it manages reshape
  *		process. It creates stripes backups (if required) and sets
@@ -8353,6 +8400,7 @@ static int imsm_manage_reshape(
 	unsigned long long start_src; /* [bytes] */
 	unsigned long long start; /* [bytes] */
 	unsigned long long start_buf_shift; /* [bytes] */
+	int degraded = 0;
 
 	if (!fds || !offsets || !destfd || !destoffsets || !sra)
 		goto abort;
@@ -8419,6 +8467,15 @@ static int imsm_manage_reshape(
 			* __le32_to_cpu(migr_rec->curr_migr_unit);
 		unsigned long long border;
 
+		/* Check that array hasn't become failed.
+		 */
+		degraded = check_degradation_change(sra, fds, degraded);
+		if (degraded > 1) {
+			dprintf("imsm: Abort reshape due to degradation"
+				" level (%i)\n", degraded);
+			goto abort;
+		}
+
 		next_step = __le32_to_cpu(migr_rec->blocks_per_unit);
 
 		if ((current_position + next_step) > max_position)

