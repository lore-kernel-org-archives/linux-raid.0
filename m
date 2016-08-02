From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:add 'clustered' in typo prompt when specify wrong param for bitmap
Date: Tue,  2 Aug 2016 05:18:40 -0400
Message-ID: <1470129520-17502-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

  mdadm: 'clustered' bitmap has already supported, thus add the
         prompt if users specify wrong value for bitmap param.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/mdadm.c b/mdadm.c
index 58ac32a..cca0933 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1142,7 +1142,7 @@ int main(int argc, char *argv[])
 				continue;
 			}
 			/* probable typo */
-			pr_err("bitmap file must contain a '/', or be 'internal', or 'none'\n"
+			pr_err("bitmap file must contain a '/', or be 'internal', or be 'clustered', or 'none'\n"
 				"       not '%s'\n", optarg);
 			exit(2);
 
-- 
2.6.6

