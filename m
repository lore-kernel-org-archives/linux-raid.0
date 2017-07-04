From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 1/1] Array size is wrong when run mdadm -E
Date: Tue,  4 Jul 2017 14:50:06 +0800
Message-ID: <1499151006-7924-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

The size of array shows wrongly. It shifs wrong number.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 86ec850..f3b864d 100644
--- a/super1.c
+++ b/super1.c
@@ -366,7 +366,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 		}
 		if (ddsks) {
 			long long asize = __le64_to_cpu(sb->size);
-			asize = (asize << 9) * ddsks / ddsks_denom;
+			asize = (asize << 10) * ddsks / ddsks_denom;
 			printf("     Array Size : %llu%s\n",
 			       asize >> 10,  human_size(asize));
 		}
-- 
2.7.4

