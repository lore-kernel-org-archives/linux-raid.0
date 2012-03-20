From: Jes.Sorensen@redhat.com
Subject: [PATCH 10/11] super-intel.c: Use ROUND_UP() instead of manually coding it
Date: Tue, 20 Mar 2012 17:54:15 +0100
Message-ID: <1332262456-5109-11-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 958edb5..a351b60 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -318,7 +318,7 @@ static void set_migr_type(struct imsm_dev *dev, __u8 migr_type)
 
 static unsigned int sector_count(__u32 bytes)
 {
-	return ((bytes + (512-1)) & (~(512-1))) / 512;
+	return ROUND_UP(bytes, 512) / 512;
 }
 
 static unsigned int mpb_sectors(struct imsm_super *mpb)
-- 
1.7.7.6

