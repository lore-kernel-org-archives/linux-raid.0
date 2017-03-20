From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:fixed some trivial typos in comments of mdadm.h
Date: Mon, 20 Mar 2017 13:20:06 +0800
Message-ID: <1489987206-22578-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm.h: fixed some trivial typos in comments

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 71b8afb..91fd9eb 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -552,7 +552,7 @@ struct mdstat_ent {
 	char		devnm[32];
 	int		active;
 	char		*level;
-	char		*pattern; /* U or up, _ for down */
+	char		*pattern; /* U for up, _ for down */
 	int		percent; /* -1 if no resync */
 	int		resync; /* 3 if check, 2 if reshape, 1 if resync, 0 if recovery */
 	int		devcnt;
@@ -742,7 +742,7 @@ struct reshape {
 	unsigned long long new_size; /* New size of array in sectors */
 };
 
-/* A superswitch provides entry point the a metadata handler.
+/* A superswitch provides entry point to a metadata handler.
  *
  * The superswitch primarily operates on some "metadata" that
  * is accessed via the 'supertype'.
-- 
2.6.6

