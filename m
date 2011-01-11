From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: Subject: [PATCH 1/4] Grow_reshape: need text version of device name
 in mdinfo.
Date: Tue, 11 Jan 2011 15:24:11 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1A44B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 95c5df882c57b2be297c1e8a125ab337c984ce57 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 11 Jan 2011 15:05:37 +0100
Subject: [PATCH 1/4] Grow_reshape: need text version of device name in mdinfo.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Grow.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 29a78a6..41db6f2 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1406,8 +1406,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			array.spare_disks);
 		return 1;
 	}
-
-	sra = sysfs_read(fd, 0, GET_LEVEL | GET_DISKS | GET_DEVS | GET_STATE);
+	sra = sysfs_read(fd, 0, GET_LEVEL | GET_DISKS | GET_DEVS | GET_STATE | GET_VERSION);
 	if (sra) {
 		if (st->ss->external && subarray == NULL) {
 			array.level = LEVEL_CONTAINER;
-- 
1.6.4.2

