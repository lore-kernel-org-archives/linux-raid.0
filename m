From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 1/3] md: fix raid10 takeover: use new_layout for setup_conf
Date: Wed, 16 Jun 2010 11:46:29 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E873EE6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Use mddev->new_layout in setup_conf.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid10.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c index 9f65dc5..7b47639 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2169,14 +2169,14 @@ static conf_t *setup_conf(mddev_t *mddev)
 		goto out;
 	}
 
-	nc = mddev->layout & 255;
-	fc = (mddev->layout >> 8) & 255;
-	fo = mddev->layout & (1<<16);
+	nc = mddev->new_layout & 255;
+	fc = (mddev->new_layout >> 8) & 255;
+	fo = mddev->new_layout & (1<<16);
 
 	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
-	    (mddev->layout >> 17)) {
+	    (mddev->new_layout >> 17)) {
 		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
-		       mdname(mddev), mddev->layout);
+		       mdname(mddev), mddev->new_layout);
 		goto out;
 	}

