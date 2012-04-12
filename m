From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH 1/4] lib/raid6: fix test program build
Date: Thu, 12 Apr 2012 13:04:30 -0700
Message-ID: <1334261073-14781-2-git-send-email-james.t.kukunas@linux.intel.com>
References: <20120412161805.133c4ad0@notabene.brown>
 <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
List-Id: linux-raid.ids

<linux/module.h> drags in headers which are not visible to userspace,
thus breaking the build for the test program.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/algos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 8b02f60..f6a0f78 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -17,11 +17,11 @@
  */
 
 #include <linux/raid/pq.h>
-#include <linux/module.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
 #else
+#include <linux/module.h>
 #include <linux/gfp.h>
 #if !RAID6_USE_EMPTY_ZERO_PAGE
 /* In .bss so it's zeroed */
-- 
1.7.8.5
