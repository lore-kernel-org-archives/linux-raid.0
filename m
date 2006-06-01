From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 10] md: Fix Kconfig error
Date: Thu, 1 Jun 2006 15:13:27 +1000
Message-ID: <1060601051327.27557@suse.de>
References: <20060601150955.27444.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


RAID5 recently changed to RAID456

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/Kconfig~current~ ./drivers/md/Kconfig
--- ./drivers/md/Kconfig~current~	2006-06-01 15:04:25.000000000 +1000
+++ ./drivers/md/Kconfig	2006-06-01 15:05:17.000000000 +1000
@@ -137,7 +137,7 @@ config MD_RAID456
 
 config MD_RAID5_RESHAPE
 	bool "Support adding drives to a raid-5 array (experimental)"
-	depends on MD_RAID5 && EXPERIMENTAL
+	depends on MD_RAID456 && EXPERIMENTAL
 	---help---
 	  A RAID-5 set can be expanded by adding extra drives. This
 	  requires "restriping" the array which means (almost) every
