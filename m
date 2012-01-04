From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: correct calculation of UUID
Date: Wed, 04 Jan 2012 10:40:35 +0100
Message-ID: <20120104094035.14727.94117.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The UUID is calculated from two numbers and two strings stored in arrays.
Whole arrays of chars are taken to calculation (not only the used part).
This is wrong, because the unused part of arrays can be changed accidentally.
For example it can sometimes happen when degraded raid is being rebuilt in OROM.
Such accidental change of UUID causes that system installed on raid
does not boot due to not recognized booting device (raid with changed UUID).

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0e9269f..7f34542 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1820,6 +1820,7 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	struct sha1_ctx ctx;
 	struct imsm_dev *dev = NULL;
 	__u32 family_num;
+	size_t len;
 
 	/* some mdadm versions failed to set ->orig_family_num, in which
 	 * case fall back to ->family_num.  orig_family_num will be
@@ -1829,14 +1830,16 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	if (family_num == 0)
 		family_num = super->anchor->family_num;
 	sha1_init_ctx(&ctx);
-	sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ctx);
+	len = strnlen((const char *)super->anchor->sig, MPB_SIG_LEN);
+	sha1_process_bytes(super->anchor->sig, len, &ctx);
 	sha1_process_bytes(&family_num, sizeof(__u32), &ctx);
 	if (super->current_vol >= 0)
 		dev = get_imsm_dev(super, super->current_vol);
 	if (dev) {
 		__u32 vol = super->current_vol;
 		sha1_process_bytes(&vol, sizeof(vol), &ctx);
-		sha1_process_bytes(dev->volume, MAX_RAID_SERIAL_LEN, &ctx);
+		len = strnlen((const char *)dev->volume, MAX_RAID_SERIAL_LEN);
+		sha1_process_bytes(dev->volume, len, &ctx);
 	}
 	sha1_finish_ctx(&ctx, buf);
 	memcpy(uuid, buf, 4*4);

