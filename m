From: mwilck@arcor.de
Subject: [PATCH 30/39] DDF: write_init_super_ddf: don't zero superblocks for subarrays
Date: Mon,  8 Jul 2013 23:50:39 +0200
Message-ID: <1373320248-7520-4-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

commit d682f344 inserted this call to "Kill" in write_init_super_ddf:

    "Matching the functionality already in super0 and super1, when
    we first create a container, remove any other recognisable metadata to
    ensure it doesn't cause confusion."

But we should do this only at first container creation, not when
subarrays are created later.
---
 super-ddf.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8f60b72..87584fa 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2964,8 +2964,9 @@ static int write_init_super_ddf(struct supertype *st)
 		return 0;
 	} else {
 		struct dl *d;
-		for (d = ddf->dlist; d; d=d->next)
-			while (Kill(d->devname, NULL, 0, -1, 1) == 0);
+		if (!currentconf)
+			for (d = ddf->dlist; d; d=d->next)
+				while (Kill(d->devname, NULL, 0, -1, 1) == 0);
 		return __write_init_super_ddf(st);
 	}
 }
-- 
1.7.1
