From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 03/17] 'act_spare' should be the minimum requirement for dynamic domains
Date: Tue, 1 Dec 2015 16:25:19 -0800
Message-ID: <1449015933-255689-4-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

Let bare devices that fit the domain become raid members.  Rather than
require the tracking of 'failed slots', simply define a group of slots
for the domain and let any bare devices attached in those domains join
a compatible array.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 policy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/policy.c b/policy.c
index 960a37e..6afafad 100644
--- a/policy.c
+++ b/policy.c
@@ -874,7 +874,7 @@ int write_rule(struct rule *rule, int fd, int force_part)
 
 /* Generate single entry in udev rule basing on POLICY line found in config
  * file. Take only those with paths, only first occurrence if paths are equal
- * and if actions supports handling of spares (>=act_spare_same_slot)
+ * and if actions supports handling of spares (>=act_spare)
  */
 int generate_entries(int fd)
 {
@@ -891,7 +891,7 @@ int generate_entries(int fd)
 		/* only policies with paths and with actions supporting
 		 * bare disks are considered */
 		loop_value = find_rule(loop->rule, pol_act);
-		if (!loop_value || map_act(loop_value) < act_spare_same_slot)
+		if (!loop_value || map_act(loop_value) < act_spare)
 			continue;
 		rule = find_path_rule(loop->rule);
 		if (!rule)
@@ -901,7 +901,7 @@ int generate_entries(int fd)
 			if (dup->type != rule_policy && loop->type != rule_part)
 				continue;
 			dup_value = find_rule(dup->rule, pol_act);
-			if (!dup_value || map_act(dup_value) < act_spare_same_slot)
+			if (!dup_value || map_act(dup_value) < act_spare)
 				continue;
 			rule = find_path_rule(dup->rule);
 			if (!rule)
-- 
2.4.6

