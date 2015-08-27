From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH 2/3] policy.c: make it easily understood when comparing the string
Date: Thu, 27 Aug 2015 15:34:56 +0800
Message-ID: <1440660897-7619-2-git-send-email-lzhong@suse.com>
References: <1440660897-7619-1-git-send-email-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440660897-7619-1-git-send-email-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/policy.c b/policy.c
index 064d349..5231ae6 100644
--- a/policy.c
+++ b/policy.c
@@ -253,13 +253,13 @@ static int pol_match(struct rule *rule, char *path, char *type)
 	int typeok = 0;
 
 	while (rule) {
-		if (rule->name == rule_path) {
+		if (!strcmp(rule->name, rule_path)) {
 			if (pathok == 0)
 				pathok = -1;
 			if (path && fnmatch(rule->value, path, 0) == 0)
 				pathok = 1;
 		}
-		if (rule->name == rule_type) {
+		if (!strcmp(rule->name, rule_type)) {
 			if (typeok == 0)
 				typeok = -1;
 			if (type && strcmp(rule->value, type) == 0)
-- 
1.8.1.4

