From: Prarit Bhargava <prarit@sgi.com>
Subject: [PATCH 1/2] Fix RAID5 components
Date: Fri, 28 Jul 2006 09:52:08 -0400
Message-ID: <20060728135208.29357.90091.sendpatchset@prarit.boston.redhat.com>
References: <20060728135203.29357.64980.sendpatchset@prarit.boston.redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060728135203.29357.64980.sendpatchset@prarit.boston.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Prarit Bhargava <prarit@sgi.com>
List-Id: linux-raid.ids

Patch to fix export issue with RAID5 + IA64.

	-adds new MD_RAID5_IA64 option (default to "y")
	 that builds IA64 RAID5 components.

This patch should be committed by the MD maintainers.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff -urNp linux-2.6.17.ia64.orig/drivers/md/Kconfig linux-2.6.17.ia64/drivers/md/Kconfig
--- linux-2.6.17.ia64.orig/drivers/md/Kconfig	2006-07-27 09:20:03.000000000 -0400
+++ linux-2.6.17.ia64/drivers/md/Kconfig	2006-07-27 14:55:15.000000000 -0400
@@ -135,6 +135,13 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
+config MD_RAID5_IA64
+	bool "RAID 5 support for IA64"
+	depends on MD_RAID456 && IA64
+	default y
+	---help---
+	Say "Y" if you plan on using RAID5 in IA64
+
 config MD_RAID5_RESHAPE
 	bool "Support adding drives to a raid-5 array (experimental)"
 	depends on MD_RAID456 && EXPERIMENTAL
