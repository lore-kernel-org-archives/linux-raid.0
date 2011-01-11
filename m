From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 9/9] imsm: Proceed with second array reshape only for frozen
	container
Date: Tue, 11 Jan 2011 15:04:59 +0100
Message-ID: <20110111140459.13862.63761.stgit@gklab-128-013.igk.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

In IMSM case container operation is set of array operations.
We have 2 cases:
1. reshape initiated by mdadm grow
2. continue reshape from checkpoint after i.e. reboot.

In first case we have continue reshape for next array.
In second case we cannot be sure that assembly procedure will assembly
arrays in required order, and can potentially have parallel reshapes.

Monitor cannot keep information for this because for raid0 it will not be started.
Difference between 2 cases is that. In first case we have frozen container,
so only for frozen container 2nd array reshape is allowed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c465288..d3da6f9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5076,10 +5076,22 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		struct active_array *aa = a->container->arrays;
 		int arrays_under_reshape = 0;
 		int array_counter = 0;
+		int frozen = 0;
+		char buf[PATH_MAX];
 
+		/* do not process next volume if container is not frozen.
+		 * 'not frozen' case can occure,
+		 * when array in migration state  is assembled
+		 */			/* do not process next volume if container is not frozen
+			 */
+
+		if (sysfs_get_str(&a->info, NULL, "metadata_version", buf, sizeof(buf)) > 0)
+			frozen = buf[9] == '-';
+		if (frozen == 0)
+			arrays_under_reshape = -1;
 		/* check if no other arrays is under reshape
 		 */
-		while (aa) {
+		while (aa && frozen) {
 			array_counter++;
 			/* when we have takeovered array even single array
 			 * can be initialized for reshape, if mdadm didn't

