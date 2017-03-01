From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:fix typo in comment
Date: Wed,  1 Mar 2017 16:44:33 +0800
Message-ID: <1488357873-19495-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/mdadm.c b/mdadm.c
index b5d89e4..16fd49a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1268,7 +1268,7 @@ int main(int argc, char *argv[])
 	 * hopefully it's mostly right but there might be some stuff
 	 * missing
 	 *
-	 * That is mosty checked in the per-mode stuff but...
+	 * That is mostly checked in the per-mode stuff but...
 	 *
 	 * For @,B,C and A without -s, the first device listed must be
 	 * an md device.  We check that here and open it.
-- 
2.6.6

