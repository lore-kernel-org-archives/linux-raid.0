From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] policy.c: Avoid to take spare without defined domain by imsm
Date: Thu, 11 Jan 2018 12:39:49 +0100
Message-ID: <1515670789-30835-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

Only Imsm get_disk_controller_domain returns disk controller domain for
each disk. It causes that mdadm automatically creates disk controller
domain policy for imsm metadata, and imsm containers in the same disk
controller domain can take spare for recovery.

Ignore spares if only one imsm domain is matched.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 policy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/policy.c b/policy.c
index b17585a..4f1ca8b 100644
--- a/policy.c
+++ b/policy.c
@@ -661,6 +661,7 @@ int domain_test(struct domainlist *dom, struct dev_policy *pol,
 	 *  1:  has domains, all match
 	 */
 	int found_any = -1;
+	int has_one_domain = 1;
 	struct dev_policy *p;
 
 	pol = pol_find(pol, pol_domain);
@@ -670,6 +671,9 @@ int domain_test(struct domainlist *dom, struct dev_policy *pol,
 			dom = dom->next;
 		if (!dom || strcmp(dom->dom, p->value) != 0)
 			return 0;
+		if (has_one_domain && metadata && strcmp(metadata, "imsm") == 0)
+			found_any = -1;
+		has_one_domain = 0;
 	}
 	return found_any;
 }
-- 
1.8.3.1

