From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 11/14] imsm: verify that component disks are attached to the
 same type of HBA
Date: Tue, 8 Mar 2011 15:21:22 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC94@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 73b912949a06e9ee9a75777216ff4f4d75c48194 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 15:40:34 +0100
Subject: [PATCH 11/14] imsm: verify that component disks are attached to the same type of HBA

compare_super_imsm verifies that the component disks use the same type of HBA
in platform dependent environment. Otherwise print-out error message and block
the action.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b9f8c9c..01f82ac 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2206,6 +2206,18 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
                 tst->sb = NULL;
                 return 0;
         }
+	/* in platform dependent environment test if the disks
+	 * use the same Intel hba
+	 */
+	if (!check_env("IMSM_NO_PLATFORM")) {
+		if (first->hba->type != sec->hba->type)  {
+			fprintf(stderr,
+				"HBAs of devices does not match %s != %s\n",
+				get_sys_dev_type(first->hba->type),
+				get_sys_dev_type(sec->hba->type));
+			return 3;
+		}
+	}
 
 	/* if an anchor does not have num_raid_devs set then it is a free
 	 * floating spare
-- 
1.6.4.2

