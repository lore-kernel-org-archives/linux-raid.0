From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [mdadm PATCH] Fix small memory leak
Date: Sun, 02 Oct 2011 21:45:41 +0200
Message-ID: <4E88BF65.2010500@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Credit goes to cppcheck.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 policy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/policy.c b/policy.c
index 2bbbac8..4a6ef82 100644
--- a/policy.c
+++ b/policy.c
@@ -757,8 +757,10 @@ int policy_check_path(struct mdinfo *disk, struct map_ent *array)
 
 	snprintf(path, PATH_MAX, FAILED_SLOTS_DIR "/%s", id_path);
 	f = fopen(path, "r");
-	if (!f)
+	if (!f) {
+		free(id_path);
 		return 0;
+	}
 
 	rv = fscanf(f, " %s %x:%x:%x:%x\n",
 		    array->metadata,
@@ -767,6 +769,7 @@ int policy_check_path(struct mdinfo *disk, struct map_ent *array)
 		    array->uuid+2,
 		    array->uuid+3);
 	fclose(f);
+	free(id_path);
 	return rv == 5;
 }
 
-- 
1.7.4.4

