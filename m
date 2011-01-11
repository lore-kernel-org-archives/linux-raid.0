From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: Subject: [PATCH 3/4] Grow_reshape: need sub-array component size in
 data migration.
Date: Tue, 11 Jan 2011 15:24:49 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1A451@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From a187f2281d4053b02b1e0e3e99cdd8f406db38e3 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 5 Jan 2011 17:38:00 +0100
Subject: [PATCH 3/4] Grow_reshape: need sub-array component size in data migration.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1998750..9db4594 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1406,7 +1406,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			array.spare_disks);
 		return 1;
 	}
-	sra = sysfs_read(fd, 0, GET_LEVEL | GET_DISKS | GET_DEVS | GET_STATE | GET_VERSION);
+	sra = sysfs_read(fd, 0, GET_LEVEL | GET_DISKS | GET_DEVS | GET_STATE | GET_VERSION | GET_COMPONENT);
 	if (sra) {
 		if (st->ss->external && subarray == NULL) {
 			array.level = LEVEL_CONTAINER;
-- 
1.6.4.2

