From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 12/23] imsm: Finalize reshape after adding disks to array
Date: Wed, 9 Jun 2010 15:33:13 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8D0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
When mdmon finalizes reshape it calls set_array_state() function. For imsm metadata
imsm_set_array_state() is called. It detects general migration finish and finalizes reshape by setting imsm disks.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c index 34ddb65..9d1afe3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4662,6 +4662,8 @@ static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	memmove(&disk->serial[0], &disk->serial[1], MAX_RAID_SERIAL_LEN - 1);  }
 
+static void imsm_set_disk(struct active_array *a, int n, int state);
+
 /* Handle dirty -> clean transititions and resync.  Degraded and rebuild
  * states are handled in imsm_set_disk() with one exception, when a
  * resync is stopped due to a new failure this routine will set the @@ -4746,6 +4748,16 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			dev->vol.dirty = 1;
 		super->updates_pending++;
 	}
+
+	/* finalize online capacity expansion/reshape */
+	if ((a->curr_action != reshape) &&
+	    (a->prev_action == reshape)) {
+		struct mdinfo *mdi;
+
+		for (mdi = a->info.devs; mdi; mdi = mdi->next)
+			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
+	}
+
 	return consistent;
 }
 

