From: mwilck@arcor.de
Subject: [PATCH 4/6] DDF: increase default value for safe_mode_delay to 4000ms
Date: Fri, 16 Aug 2013 20:21:58 +0200
Message-ID: <1376677320-12816-5-git-send-email-mwilck@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

That is the same value that IMSM uses. The current default of 200ms
seems to have been copied from the native MD meta data. That value
appears to be much too low for DDF, given that writing the DDF meta
data means that easily several MB worth of data need to be written to
disk.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index d8fa654..f03dd5b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -47,6 +47,10 @@ unsigned long crc32(
 #define DDF_NOTFOUND (~0U)
 #define DDF_CONTAINER (DDF_NOTFOUND-1)
 
+/* Default for safe_mode_delay. Same value as for IMSM.
+ */
+static const int DDF_SAFE_MODE_DELAY = 4000;
+
 /* The DDF metadata handling.
  * DDF metadata lives at the end of the device.
  * The last 512 byte block provides an 'anchor' which is used to locate
@@ -1976,7 +1980,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	sprintf(info->text_version, "/%s/%d",
 		st->container_devnm,
 		info->container_member);
-	info->safe_mode_delay = 200;
+	info->safe_mode_delay = DDF_SAFE_MODE_DELAY;
 
 	memcpy(info->name, ddf->virt->entries[info->container_member].name, 16);
 	info->name[16]=0;
@@ -3668,7 +3672,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		this->array.md_minor      = -1;
 		this->array.major_version = -1;
 		this->array.minor_version = -2;
-		this->safe_mode_delay = 200;
+		this->safe_mode_delay = DDF_SAFE_MODE_DELAY;
 		cptr = (__u32 *)(vc->conf.guid + 16);
 		this->array.ctime         = DECADE + __be32_to_cpu(*cptr);
 		this->array.utime	  = DECADE +
-- 
1.7.3.4
