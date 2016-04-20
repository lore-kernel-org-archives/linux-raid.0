From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] raid6check: Fix if-else indentation
Date: Wed, 20 Apr 2016 16:41:17 +0000
Message-ID: <1461170477-13929-1-git-send-email-raj.khem@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
List-Id: linux-raid.ids

gcc 6 warns about ambiguity due to this indentation
| raid6check.c: In function 'manual_repair':
| raid6check.c:267:4: error: this 'else' clause does not guard... [-Werror=misleading-indentation]
|     else
|     ^~~~
| raid6check.c:269:5: note: ...this statement, but the latter is misleadingly indented as if it is guarded by the 'else'
|      printf("Repairing D(%d) and P\n", failed_data);
|      ^~~~~~

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 raid6check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/raid6check.c b/raid6check.c
index ad7ffe7..409b1b6 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -266,7 +266,7 @@ int manual_repair(int chunk_size, int syndrome_disks,
 				failed_data = failed_slot2;
 			else
 				failed_data = failed_slot1;
-				printf("Repairing D(%d) and P\n", failed_data);
+			printf("Repairing D(%d) and P\n", failed_data);
 			raid6_datap_recov(syndrome_disks+2, chunk_size,
 					  failed_data, (uint8_t**)blocks, 1);
 		} else {
-- 
1.9.1

