From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 11/12] md: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:23 +0900
Message-ID: <1268903124-10237-11-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for raid5.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 70ffbd0..a711ba3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4659,7 +4659,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 			kfree(percpu->scribble);
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_DEAD:
-- 
1.6.0.6

