From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 7/9] FIX: Set 'new' geometry when assembling reshaped array
Date: Wed, 02 Mar 2011 14:29:51 +0100
Message-ID: <20110302132951.24771.398.stgit@gklab-128-013.igk.intel.com>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For proper array configuration the following steps has to be taken:
1. set 'old' geometry and reshape position (done in sysfs_set_array())
2. set 'new' geometry (currently new raid_disks only)
3. add disks
4. start array readonly

Added code addressed p.2

In the one of last email, Neil points that sysfs_set_array()
should do this. Comment in sysfs_set_array() doesn't allow for this
due to required analysis for 'new' geometry parameters.
Currently external metadata supports raid disks increase only,
so for now proposed in patch code should enough.
when more migrations for external metadata will be supported this code
will have to support other cases also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index e31462d..e65022c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1527,10 +1527,24 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	sysfs_init(content, mdfd, 0);
 
 	sra = sysfs_read(mdfd, 0, GET_VERSION);
-	if (sra == NULL || strcmp(sra->text_version, content->text_version) != 0)
+	if (sra == NULL || strcmp(sra->text_version,
+				  content->text_version) != 0) {
 		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
 			return 1;
-
+		if (content->reshape_active) {
+			/* set 'new' array geometry parameters
+			 * to restart reshape
+			 * ToDo:
+			 * Temporary this is a "simple way".
+			 * analyse_change() has to be used
+			 * for array setup during reshape,
+			 * when more array migrations will be supported
+			 */
+			sysfs_set_num(content, NULL, "raid_disks",
+				      content->array.raid_disks +
+					      content->delta_disks);
+		}
+	}
 	if (sra)
 		sysfs_free(sra);
 

