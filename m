From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] remove unused variable
Date: Mon, 26 Sep 2011 12:37:22 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B902FEE1@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

From ccbe8fd4b762d88184c0fea61abb966cf8c99cc9 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 26 Sep 2011 11:54:04 +0200
Subject: [PATCH] remove unused variable

reservation is calculated below in imsm_min_reserved_sectors()
so this variable is not needed

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 07d47b5..75b432d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -988,9 +988,8 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 	struct dl *dl;
 	struct extent *e;
 	int i;
 	unsigned long long rv = 0;
-	__u32 reservation;
 
 	if (!super)
 		return rv;
 	/* find first active disk in array */
@@ -1006,9 +1005,8 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 	for (i = 0; e[i].size; i++)
 		continue;
 	if (i > 0)
 		rv = e[i-1].start + e[i-1].size;
-	reservation = __le32_to_cpu(dl->disk.total_blocks) - e[i].start;
 	free(e);
 
 	/* add the amount of space needed for metadata */
 	rv = rv + imsm_min_reserved_sectors(super);
-- 
1.7.4

