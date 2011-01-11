From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: Subject: [PATCH 2/4] Grow_reshape: need text_version for sub-array
 processing.
Date: Tue, 11 Jan 2011 15:24:17 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1A44C@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From bffebd79d2f18176727d2c6d9dd111470969cf7a Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 11 Jan 2011 14:13:10 +0100
Subject: [PATCH 2/4] Grow_reshape: need text_version for sub-array processing.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 41db6f2..1998750 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1497,6 +1497,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 	info.array = array;
 	sysfs_init(&info, fd, NoMdDev);
+	strcpy(info.text_version, sra->text_version);
 	info.component_size = size*2;
 	info.new_level = level;
 	info.new_chunk = chunksize * 1024;
-- 
1.6.4.2

