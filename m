From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] raid: md_p.h: drop duplicated word in a comment
Date: Fri, 17 Jul 2020 16:37:13 -0700
Message-ID: <d01bc32e-3b17-bd4d-faf6-29b4b931c9f6@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Randy Dunlap <rdunlap@infradead.org>

Drop the doubled word "the" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
---
 include/uapi/linux/raid/md_p.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/uapi/linux/raid/md_p.h
+++ linux-next-20200714/include/uapi/linux/raid/md_p.h
@@ -123,7 +123,7 @@ typedef struct mdp_device_descriptor_s {
 
 /*
  * Notes:
- * - if an array is being reshaped (restriped) in order to change the
+ * - if an array is being reshaped (restriped) in order to change
  *   the number of active devices in the array, 'raid_disks' will be
  *   the larger of the old and new numbers.  'delta_disks' will
  *   be the "new - old".  So if +ve, raid_disks is the new value, and
