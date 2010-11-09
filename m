From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 26/31] mdadm: add backup methods to superswitch
Date: Tue, 9 Nov 2010 17:01:25 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAAC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Add new methods to the superswitch for external metadata supporting its own critical reshape data backup mechanism.

The new methods are:
save_backup - save critical data to backup area discard_backup - critical data was successfully migrated, so
	       the current backup may be discarded recover_backup - recover critical data after reshape crashed
	       during array assembly

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/mdadm.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index 68df20b..b46b90e 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -727,6 +727,15 @@ extern struct superswitch {
 			     int request_type,
 			     struct metadata_update **updates);
 
+	/* for external backup area
+	 *
+	 */
+	int (*save_backup)(struct supertype *st, struct mdinfo *info,
+			    void *buf, unsigned long write_offset, int length);
+	void (*discard_backup)(struct supertype *st, struct mdinfo *info);
+	int (*recover_backup)(struct supertype *st, struct mdinfo *info,
+			      void *ptr, int length);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */

