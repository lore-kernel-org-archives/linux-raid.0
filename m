From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 05/10] mdadm: add backup methods to superswitch
Date: Wed, 21 Jul 2010 12:19:48 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49C3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Add new methods to the superswitch for external metadata supporting
its own critical reshape data backup mechanism.

The new methods are:
save_backup - save critical data to backup area
discard_backup - critical data was successfully migrated, so
	       the current backup may be discarded
recover_backup - recover critical data after reshape crashed
	       during array assembly

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 mdadm.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index e5e56fe..baee86c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -671,6 +671,15 @@ extern struct superswitch {
 
 	int (*grow_array)(struct active_array *a, int new_raid_disks);
 
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

