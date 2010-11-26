From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/4] Monitor: reset dev when size too small
Date: Fri, 26 Nov 2010 18:25:54 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C009E3E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From ce42a88d45e1d901460dd476b8eea46031060570 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 26 Nov 2010 12:51:59 +0100
Subject: [PATCH 2/4] Monitor: reset dev when size too small
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

Otherwise spare will be considered good anyway.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index beaaa55..cacd2fe 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -844,9 +844,10 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 			
 			if (min_size &&
 			    dev_size_from_id(dev,  &dev_size) &&
-			    dev_size < min_size)
+			    dev_size < min_size) {
+				dev = 0;
 				continue;
-
+			}
 			pol = devnum_policy(dev);
 			if (from->spare_group)
 				pol_add(&pol, pol_domain,
-- 
1.7.1

