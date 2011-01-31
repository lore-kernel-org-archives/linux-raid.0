From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/2] Assemble: allow to assemble container with uuid=0:0:0:0
Date: Mon, 31 Jan 2011 16:31:58 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010EBB6C13@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From d51b0cfdf904bf67adc84725875cd353a0173b75 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 31 Jan 2011 16:11:23 +0100
Subject: [PATCH 2/2] Assemble: allow to assemble container with uuid=0:0:0:0
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

When there are any arrays in config file the spares with
domain not matching any array are not assembled because
auto assembly is not attempted.
Addition of ARRAY line with uuid=0:0:0:0 in config will work
with modified condition for gathering spares.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Assemble.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 532335e..36fd4b7 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -564,7 +564,10 @@ int Assemble(struct supertype *st, char *mddev,
 	}
 
 	/* Check if we found some imsm spares but no members */
-	if (auto_assem && (!st || !st->sb))
+	if ((auto_assem ||
+	     (ident->uuid_set &&
+	      memcmp(uuid_zero, ident->uuid,sizeof(uuid_zero)) == 0)) &&
+	    (!st || !st->sb))
 		for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
 			if (tmpdev->used != 3)
 				continue;
-- 
1.7.1

