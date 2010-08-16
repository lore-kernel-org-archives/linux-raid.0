From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 01/35] [hotunplug] we are testing mdstat, not ent which is
 undefined at this
Date: Mon, 16 Aug 2010 10:41:07 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9B3@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 056dc24440bb54a7e107fbae368915b3173c333d Mon Sep 17 00:00:00 2001
From: Doug Ledford <dledford@redhat.com>
Date: Tue, 13 Apr 2010 13:12:59 -0400
Subject: [PATCH 01/35] [hotunplug] we are testing mdstat, not ent which is undefined at this
 point

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 mdstat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index 58d349d..3bb74fa 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -348,9 +348,9 @@ struct mdstat_ent *mdstat_by_component(char *name)
 	while (mdstat) {
 		struct dev_member *m;
 		struct mdstat_ent *ent;
-		if (ent->metadata_version &&
-		    strncmp(ent->metadata_version, "external:", 9) == 0	 &&
-		    is_subarray(ent->metadata_version+9))
+		if (mdstat->metadata_version &&
+		    strncmp(mdstat->metadata_version, "external:", 9) == 0 &&
+		    is_subarray(mdstat->metadata_version+9))
 			/* don't return subarrays, only containers */
 			;
 		else for (m = mdstat->members; m; m = m->next) {
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

