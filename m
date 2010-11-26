From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 40/53] mdadm: add backup methods to superswitch
Date: Fri, 26 Nov 2010 09:09:02 +0100
Message-ID: <20101126080902.5221.57139.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Add new methods to the superswitch for external metadata supporting its own critical reshape data backup mechanism.

The new methods are:
save_backup - save critical data to backup area discard_backup - critical data was successfully migrated, so
               the current backup may be discarded recover_backup - recover critical data after reshape crashed
               during array assembly

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 95f355e..726e0a4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -726,6 +726,15 @@ extern struct superswitch {
 			     enum state_of_reshape request_type,
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

