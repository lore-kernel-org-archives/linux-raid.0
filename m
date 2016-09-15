From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: do not activate spares for uninitialized member arrays
Date: Thu, 15 Sep 2016 09:53:58 +0200
Message-ID: <20160915075358.16948-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This fixes some issues when a member array is created with "missing"
devices in a container that has more devices than used in the member
array.

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 92817e9..032ef00 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7789,6 +7789,11 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 			IMSM_T_STATE_DEGRADED)
 		return NULL;
 
+	if (get_imsm_map(dev, MAP_0)->map_state == IMSM_T_STATE_UNINITIALIZED) {
+		dprintf("imsm: No spare activation allowed. Volume is not initialized.\n");
+		return NULL;
+	}
+
 	/*
 	 * If there are any failed disks check state of the other volume.
 	 * Block rebuild if the another one is failed until failed disks
-- 
2.10.0

