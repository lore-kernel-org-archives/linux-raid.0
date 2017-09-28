From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 09/12] imsm: Write empty PPL header if assembling regular clean array.
Date: Thu, 28 Sep 2017 14:41:15 +0200
Message-ID: <20170928124118.23361-10-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

If array was initially assembled with kernel without PPL support -
initial header was never written to the drive.
If initial resync was completed and system is rebooted to kernel with
PPL support - mdadm prevents from assembling normal clean array
due to lack of valid PPL.
Write empty header when assemble normal clean array, so the
its assamble is no longer blocked.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 016a6028..2e8eb0d4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6225,7 +6225,9 @@ out:
 	}
 
 	if (ret == 1) {
-		if (map->map_state == IMSM_T_STATE_UNINITIALIZED)
+		if (map->map_state == IMSM_T_STATE_UNINITIALIZED ||
+		   (map->map_state == IMSM_T_STATE_NORMAL &&
+		   !(dev->vol.dirty & RAIDVOL_DIRTY)))
 			ret = st->ss->write_init_ppl(st, info, d->fd);
 		else
 			info->mismatch_cnt++;
-- 
2.13.5

