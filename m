From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] lib/raid6: fix preprocessor warning
Date: Thu, 5 Dec 2013 14:21:57 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1312051419130.8466@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch fixes the following preprocessor warning:
lib/raid6/recov_avx2.c:11:5: warning: "CONFIG_AS_AVX2" is not defined [-Wundef]

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org	# 3.8+

---
 lib/raid6/recov_avx2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.12.3/lib/raid6/recov_avx2.c
===================================================================
--- linux-3.12.3.orig/lib/raid6/recov_avx2.c	2013-12-05 19:54:41.000000000 +0100
+++ linux-3.12.3/lib/raid6/recov_avx2.c	2013-12-05 19:54:46.000000000 +0100
@@ -8,7 +8,7 @@
  * of the License.
  */
 
-#if CONFIG_AS_AVX2
+#ifdef CONFIG_AS_AVX2
 
 #include <linux/raid/pq.h>
 #include "x86.h"
