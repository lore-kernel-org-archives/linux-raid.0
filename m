From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] fix: Monitor: min_size must be set to 0
Date: Thu, 13 Jan 2011 15:03:14 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E8FDFF2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From ac2d3550f2bd4fafb6497b881cac3c02d147c21a Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 13 Jan 2011 15:58:39 +0100
Subject: [PATCH] fix: Monitor: min_size must be set to 0

Otherwise a random value will be used for comparison later
for native and ddf metadata (until min_acceptable_spare_size is defined).

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index ab1ae26..9e2a478 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -707,8 +707,10 @@ static int get_min_spare_size_required(struct state *st, unsigned long long *siz
 	int fd;
 
 	if (!st->metadata ||
-	    !st->metadata->ss->min_acceptable_spare_size)
+	    !st->metadata->ss->min_acceptable_spare_size) {
+		*sizep = 0;
 		return 0;
+	}
 
 	fd = open(st->devname, O_RDONLY);
 	if (fd < 0)
-- 
1.7.1

