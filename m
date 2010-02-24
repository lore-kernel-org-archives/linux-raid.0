From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 3/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:43:14 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65BA@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 88bdb5e860bede6cbc09a52d56b502f0baf62925 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:25:21 +0100
Subject: [PATCH] OLCE: changes to meta update md_update_sb()

Changes to be committed:
        modified:   md.c

For external meta some actions should be the same as for native meta
except updating meta.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/md.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 83e6852..fce7d44 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1965,8 +1965,16 @@ static void md_update_sb(mddev_t * mddev, int force_change)
        int nospares = 0;

        mddev->utime = get_seconds();
-       if (mddev->external)
+
+       /* for reshape on external meta only */
+       if ((mddev->external) &&
+           !test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+               /* for external meta  md_allow_write() should proceed */
+               clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
+
                return;
+       }
+
 repeat:
        spin_lock_irq(&mddev->write_lock);

@@ -2030,11 +2038,23 @@ repeat:
        /*
         * do not write anything to disk if using
         * nonpersistent superblocks
+        * and
+        * for external meta and reshape
+        * we can get here also
         */
-       if (!mddev->persistent) {
+       if (!mddev->persistent ||
+           mddev->external) {
                if (!mddev->external)
                        clear_bit(MD_CHANGE_PENDING, &mddev->flags);

+               /* OLCE: reshape for external meta */
+               if (mddev->external &&
+                   test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+                       /* for external meta clean MD_CHANGE_PENDING flag
+                        * as changes will be made by user space code
+                        */
+                       clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+               }
                spin_unlock_irq(&mddev->write_lock);
                wake_up(&mddev->sb_wait);
                return;
--
1.6.0.2

