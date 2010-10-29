From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 14/17] Monitor: Respect policy in auto-rebuild in mdadm
 monitoring.
Date: Fri, 29 Oct 2010 15:25:37 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 98a5e08b9845b1039495f55bea95deb404609203 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 28 Oct 2010 13:14:41 +0200
Subject: [PATCH 14/17] Monitor: Respect policy in auto-rebuild in mdadm monitoring.

Respect policy definition from mdadm.conf.
For each degraded (sub)array, its policy is retrieved. In next steps
potential donor array/container is searched for a spare disk.
When found, we check if the domain matches and verify action.
*spare* action is minimum to let spare sharing in the same policy domain.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Monitor.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index a122040..aa2856e 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -793,6 +793,44 @@ static struct supertype *get_super(struct state *st)
 	return super;
 }
 
+/* checks if domains of potential spare disk and
+ * a array/container domain under rebuild match
+ */
+static int check_domain_match(struct domainlist *dl,
+			      unsigned devid,
+			      struct supertype *super)
+{
+	struct dev_policy *policy = NULL;
+	struct mdinfo dinfo;
+	enum policy_action action;
+
+	dinfo.disk.major = major(devid);
+	dinfo.disk.minor = minor(devid);
+	policy = disk_policy(&dinfo);
+	/* Can only add a spare if device has at least one domains */
+	if (pol_find(policy, pol_domain) == NULL) {
+		dev_policy_free(policy);
+		return 0;
+	}
+	if (!domain_test(dl, policy, super->ss->name)) {
+		dprintf("domain test fails: %s"
+			"(name: %s value: %s metadata: %s)\n",
+			dl->dom,
+			(policy) ? policy->name : "NULL",
+			(policy) ? policy->value : "NULL",
+			super->ss->name);
+		/* domain test fails */
+		dev_policy_free(policy);
+		return 0;
+	}
+	/* check if spare sharing allowed */
+	action = policy_action(policy, super->ss->name);
+	dev_policy_free(policy);
+	if ((action < act_spare) || (action == act_err))
+		return 0;
+	return 1;
+}
+
 /* check if donating array/container:
  * - has the same metadata
  * - has no error reported
@@ -831,6 +869,7 @@ static void spare_sharing(struct state *statelist, char *mailaddr,
 	struct state *st, *stp, *st2 = NULL;
 	int i, found;
 	struct mdinfo *sra = NULL;
+	struct domainlist *dl = NULL;
 	struct supertype *super = NULL;
 	unsigned long long min_size;
 
@@ -853,7 +892,6 @@ static void spare_sharing(struct state *statelist, char *mailaddr,
 			dprintf("no sra for device: %s\n", stp->devname);
 			continue;
 		}
-		sysfs_free(sra);
 		min_size = min_active_disk_size_in_array(st);
 		if (min_size == 0)
 			continue;
@@ -861,12 +899,24 @@ static void spare_sharing(struct state *statelist, char *mailaddr,
 			if (dev_suitable(stp->devid[i], stp->devstate[i],
 					 min_size))
 				break;
-		if (i < stp->total)
+		if (i < stp->total) {
 			/* there is a spare in array/parent container,
 			 * it was probably just added
 			 * but mdmon has not started recovery yet
 			 * we will not add any more spares for now */
+			sysfs_free(sra);
 			continue;
+		}
+
+		/* get the array domain */
+		dl = domain_from_array(sra, super->ss->name);
+		sysfs_free(sra);
+		if (!dl) {
+			dprintf("domain: %p name: %s dev: %s meta: %s\n",
+				dl, (dl) ? dl->dom : "NULL", stp->devname,
+				super->ss->name);
+			continue;
+		}
 
 		/* search for an array/container with unused spare */
 		for (st2 = statelist; st2; st2 = st2->next) {
@@ -886,7 +936,10 @@ static void spare_sharing(struct state *statelist, char *mailaddr,
 						  st2->devstate[i],
 						  min_size))
 					continue;
-				/* domain comparison to be added here */
+				if (!check_domain_match(dl,
+							st2->devid[i],
+							super))
+					continue;
 				if (move_spare(st2, stp, &st2->devid[i],
 					       mailaddr, mailfrom, alert_cmd,
 					       dosyslog)) {
@@ -898,6 +951,7 @@ static void spare_sharing(struct state *statelist, char *mailaddr,
 			if (found)
 				break; /* stop searching arrays */
 		}
+		domain_free(dl);
 	}
 	return;
 }
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

