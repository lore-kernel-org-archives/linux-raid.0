From: mwilck@arcor.de
Subject: [PATCH 5/6] in_initrd: fix gcc compiler error
Date: Fri, 16 Aug 2013 20:21:59 +0200
Message-ID: <1376677320-12816-6-git-send-email-mwilck@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

On some systems, this code caused a "comparison between signed
and unsigned" error.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 util.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/util.c b/util.c
index 8096e29..491a107 100644
--- a/util.c
+++ b/util.c
@@ -1949,6 +1949,6 @@ int in_initrd(void)
 	/* This is based on similar function in systemd. */
 	struct statfs s;
 	return  statfs("/", &s) >= 0 &&
-		(s.f_type == TMPFS_MAGIC ||
-		 s.f_type == RAMFS_MAGIC);
+		((unsigned long)s.f_type == TMPFS_MAGIC ||
+		 (unsigned long)s.f_type == RAMFS_MAGIC);
 }
-- 
1.7.3.4
