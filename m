From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] imsm: fix checking completion of RAID10 resync
Date: Tue, 30 Jul 2013 15:59:25 +0200
Message-ID: <20130730135925.30168.91570.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com
List-Id: linux-raid.ids

If one creates RAID10 with IMSM metadata the is_resync_complete
function returns '1' just when initial resync reaches 50%

IMSM version of the is_resync_complete function has been added
that handles the case of IMSM RAID10 correctly.


Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4df33f4..0371713 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1021,6 +1021,22 @@ static int is_failed(struct imsm_disk *disk)
 	return (disk->status & FAILED_DISK) == FAILED_DISK;
 }
 
+/* IMSM version of is_resync_complete helper routine
+ * to determine resync completion
+ * since MaxSector is a moving target
+ */
+static int imsm_is_resync_complete(struct mdinfo *array)
+{
+	if (array->array.level != 10) {
+		if (array->resync_start >= array->component_size)
+			return 1;
+	} else {
+		if (array->resync_start >= 2*array->component_size)
+			return 1;
+	}
+	return 0;
+}
+
 /* try to determine how much space is reserved for metadata from
  * the last get_extents() entry on the smallest active disk,
  * otherwise fallback to the default
@@ -7119,12 +7135,12 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		handle_missing(super, dev);
 
 	if (consistent == 2 &&
-	    (!is_resync_complete(&a->info) ||
+	    (!imsm_is_resync_complete(&a->info) ||
 	     map_state != IMSM_T_STATE_NORMAL ||
 	     dev->vol.migr_state))
 		consistent = 0;
 
-	if (is_resync_complete(&a->info)) {
+	if (imsm_is_resync_complete(&a->info)) {
 		/* complete intialization / resync,
 		 * recovery and interrupted recovery is completed in
 		 * ->set_disk

