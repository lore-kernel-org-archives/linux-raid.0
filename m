From: Dan McGee <dpmcgee@gmail.com>
Subject: [PATCH] lib/raid6: Fix filename emitted in generated code
Date: Mon, 17 Oct 2011 15:29:08 -0500
Message-ID: <1318883348-29961-1-git-send-email-dpmcgee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

The files were renamed in commit cc4589ebf; fix the name in the file
itself.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 lib/raid6/int.uc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
index d1e276a..5b50f8d 100644
--- a/lib/raid6/int.uc
+++ b/lib/raid6/int.uc
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * raid6int$#.c
+ * int$#.c
  *
  * $#-way unrolled portable integer math RAID-6 instruction set
  *
-- 
1.7.7
