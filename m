From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 06/14] imsm: remove unused parameters in function
 attach_hba_to_super
Date: Tue, 8 Mar 2011 15:20:56 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC8F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 2e7fe1553a3ce71f0347aafbf8b4143ac5d47317 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 14:37:45 +0100
Subject: [PATCH 06/14] imsm: remove unused parameters in function attach_hba_to_super

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 90faf27..9f78aff 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -408,8 +408,7 @@ static struct intel_hba * find_intel_hba(struct intel_hba *hba, struct sys_dev *
 }
 
 
-static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device,
-			       const char *devname)
+static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device)
 {
 	struct intel_hba *hba;
 
@@ -3695,7 +3694,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 				devname ? : "disk");
 			return 1;
 		}
-		rv = attach_hba_to_super(super, hba_name, devname);
+		rv = attach_hba_to_super(super, hba_name);
 		switch (rv) {
 		case 2:
 			fprintf(stderr, Name ": %s is attached to Intel(R) %s RAID "
-- 
1.6.4.2

