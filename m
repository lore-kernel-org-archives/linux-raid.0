From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 6] md: Remove 'experimental' classification from raid5 reshape.
Date: Fri, 29 Sep 2006 12:53:10 +1000
Message-ID: <1060929025310.15229@suse.de>
References: <20060929125047.14064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


I have had enough success reports not to believe that this 
is safe for 2.6.19.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff .prev/drivers/md/Kconfig ./drivers/md/Kconfig
--- .prev/drivers/md/Kconfig	2006-09-29 11:38:03.000000000 +1000
+++ ./drivers/md/Kconfig	2006-09-29 11:49:16.000000000 +1000
@@ -138,16 +138,16 @@ config MD_RAID456
 	  If unsure, say Y.
 
 config MD_RAID5_RESHAPE
-	bool "Support adding drives to a raid-5 array (experimental)"
-	depends on MD_RAID456 && EXPERIMENTAL
+	bool "Support adding drives to a raid-5 array"
+	depends on MD_RAID456
+	default y
 	---help---
 	  A RAID-5 set can be expanded by adding extra drives. This
 	  requires "restriping" the array which means (almost) every
 	  block must be written to a different place.
 
           This option allows such restriping to be done while the array
-	  is online.  However it is still EXPERIMENTAL code.  It should
-	  work, but please be sure that you have backups.
+	  is online.
 
 	  You will need mdadm version 2.4.1 or later to use this
 	  feature safely.  During the early stage of reshape there is
@@ -164,6 +164,8 @@ config MD_RAID5_RESHAPE
 	  There should be enough spares already present to make the new
 	  array workable.
 
+	  In unsure, say Y.
+
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
 	depends on BLK_DEV_MD
