From: Blazej Kucman <blazej.kucman@intel.com>
Subject: [PATCH] imsm: Disable --dump/--restore options
Date: Fri, 10 Jan 2020 11:59:27 +0100
Message-ID: <20200110105927.5965-1-blazej.kucman@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

Currently --dump/--restore are not working correctly.
Temporarily disable this functionally for IMSM
to avoid unexpected behaviors and side effects.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 super-intel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 5c1f759f..b2a4528d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2130,6 +2130,13 @@ static void export_examine_super_imsm(struct supertype *st)
 
 static int copy_metadata_imsm(struct supertype *st, int from, int to)
 {
+	/*
+	 * Disable this functionality for IMSM,
+	 * since it is not working correctly.
+	 */
+	pr_err("--dump/--restore is not supported for IMSM metadata format.\n");
+	return 1;
+
 	/* The second last sector of the device contains
 	 * the "struct imsm_super" metadata.
 	 * This contains mpb_size which is the size in bytes of the
-- 
2.16.4
