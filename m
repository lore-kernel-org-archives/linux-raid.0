From: Mike Lovell <mlovell@bluehost.com>
Subject: [PATCH 2/2] Change behavior in find_free_devnm when wrapping around.
Date: Wed, 18 May 2016 12:23:14 -0600
Message-ID: <1463595794-17045-3-git-send-email-mlovell@bluehost.com>
References: <1463595794-17045-1-git-send-email-mlovell@bluehost.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1463595794-17045-1-git-send-email-mlovell@bluehost.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mike Lovell <mlovell@bluehost.com>
List-Id: linux-raid.ids

Newer kernels don't allow for specifying an array larger than 511. This
makes it so find_free_devnm wraps to 511 instead of 2^20 - 1.

Signed-off-by: Mike Lovell <mlovell@bluehost.com>
---
 mdopen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index e71d758..f818fdf 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -439,7 +439,7 @@ char *find_free_devnm(int use_partitions)
 	static char devnm[32];
 	int devnum;
 	for (devnum = 127; devnum != 128;
-	     devnum = devnum ? devnum-1 : (1<<20)-1) {
+	     devnum = devnum ? devnum-1 : (1<<9)-1) {
 
 		if (use_partitions)
 			sprintf(devnm, "md_d%d", devnum);
-- 
1.9.1

