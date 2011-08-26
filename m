From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [mdadm PATCH] Fix small memory leak
Date: Fri, 26 Aug 2011 07:33:37 +0200
Message-ID: <4E573031.9080007@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Found by cppcheck

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 config.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.c b/config.c
index ad75411..c0a6baa 100644
--- a/config.c
+++ b/config.c
@@ -707,6 +707,8 @@ void autoline(char *line)
 	for (i = 0; i < super_cnt; i++)
 		if (!seen[i])
 			policy_add(rule_policy, pol_auto, dflt, pol_metadata, superlist[i]->name, NULL);
+
+	free(seen);
 }
 
 int loaded = 0;
-- 
1.7.4.4

