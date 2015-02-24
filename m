From: Jes.Sorensen@redhat.com
Subject: [PATCH 5/5] write_super_imsm_spares(): C statements are terminated by ;
Date: Tue, 24 Feb 2015 16:00:40 -0500
Message-ID: <1424811640-26569-6-git-send-email-Jes.Sorensen@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 819e0da..7f75b53 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5115,13 +5115,13 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 	__u32 sum;
 	struct dl *d;
 
-	spare->mpb_size = __cpu_to_le32(sizeof(struct imsm_super)),
-	spare->generation_num = __cpu_to_le32(1UL),
+	spare->mpb_size = __cpu_to_le32(sizeof(struct imsm_super));
+	spare->generation_num = __cpu_to_le32(1UL);
 	spare->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
-	spare->num_disks = 1,
-	spare->num_raid_devs = 0,
-	spare->cache_size = mpb->cache_size,
-	spare->pwr_cycle_count = __cpu_to_le32(1),
+	spare->num_disks = 1;
+	spare->num_raid_devs = 0;
+	spare->cache_size = mpb->cache_size;
+	spare->pwr_cycle_count = __cpu_to_le32(1);
 
 	snprintf((char *) spare->sig, MAX_SIGNATURE_LENGTH,
 		 MPB_SIGNATURE MPB_VERSION_RAID0);
-- 
2.1.0

