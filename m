From: Jes.Sorensen@redhat.com
Subject: [PATCH 08/11] Generalize ROUND_UP() macro and introduce matching ROUND_UP_PTR()
Date: Tue, 20 Mar 2012 17:54:13 +0100
Message-ID: <1332262456-5109-9-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdadm.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 45198bb..314f3ac 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1252,10 +1252,10 @@ static inline int dev2minor(int d)
 	return (-1-d) << MdpMinorShift;
 }
 
-static inline int ROUND_UP(int a, int base)
-{
-	return ((a+base-1)/base)*base;
-}
+#define _ROUND_UP(val, base)	(((val) + (base)) & ~(base - 1))
+#define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
+#define ROUND_UP_PTR(ptr, base)	((typeof(ptr)) \
+				 (ROUND_UP((unsigned long)(ptr), base)))
 
 static inline int is_subarray(char *vers)
 {
-- 
1.7.7.6

