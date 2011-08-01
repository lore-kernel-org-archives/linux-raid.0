From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] fix: segfault when killing subarray of non-existent
 container
Date: Mon, 1 Aug 2011 16:33:06 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F013DDEDC1B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

From 9c3c974e1e047caf3434f98e183e58ed3b222396 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 1 Aug 2011 17:23:33 +0200
Subject: [PATCH] fix: segfault when killing subarray of non-existent container

Negative value must be returned to indicate error in open_subarray

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index 55d171a..2dec9d5 100644
--- a/util.c
+++ b/util.c
@@ -1369,7 +1369,7 @@ int open_subarray(char *dev, char *subarray, struct supertype *st, int quiet)
 		if (!quiet)
 			fprintf(stderr, Name ": Couldn't open %s, aborting\n",
 				dev);
-		return 2;
+		return -1;
 	}
 
 	st->devnum = fd2devnum(fd);
-- 
1.7.4

