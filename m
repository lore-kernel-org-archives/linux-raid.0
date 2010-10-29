From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 10/17] Monitor: include containers in scan mode
Date: Fri, 29 Oct 2010 15:23:51 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FCA@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From d9088196c88cd7ef1d61874cd8b4659623da08f3 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 22 Oct 2010 15:18:34 +0200
Subject: [PATCH 10/17] Monitor: include containers in scan mode

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Monitor.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index d915d7d..0f8a6b9 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -473,15 +473,15 @@ int Monitor(mddev_dev_t devlist,
 			}
 
 		}
+
 		/* now check if there are any new devices found in mdstat */
 		if (scan) {
 			struct mdstat_ent *mse;
 			for (mse=mdstat; mse; mse=mse->next)
 				if (mse->devnum != INT_MAX &&
-				    mse->level &&
-				    (strcmp(mse->level, "raid0")!=0 &&
-				     strcmp(mse->level, "linear")!=0)
-					) {
+				   (!mse->level  || /* retrieve containers */
+				    (strcmp(mse->level, "raid0") != 0 &&
+				     strcmp(mse->level, "linear") != 0))) {
 					struct state *st = malloc(sizeof *st);
 					mdu_array_info_t array;
 					int fd;
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

