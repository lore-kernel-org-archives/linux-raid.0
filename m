From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm: Send version text to stdout rather than stderr
Date: Tue,  6 Jun 2017 15:59:47 +0800
Message-ID: <1496735987-10653-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

This helps with piping to a paper.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index 70b16f2..0f736d7 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -139,7 +139,7 @@ int main(int argc, char *argv[])
 			continue;
 
 		case 'V':
-			fputs(Version, stderr);
+			fputs(Version, stdout);
 			exit(0);
 
 		case 'v': c.verbose++;
-- 
2.6.6

