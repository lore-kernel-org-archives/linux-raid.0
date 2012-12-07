From: mwilck@arcor.de
Subject: [PATCH 3/3] DDF: increase seq number when writing meta data
Date: Fri,  7 Dec 2012 23:39:01 +0100
Message-ID: <1354919941-12070-4-git-send-email-mwilck@arcor.de>
References: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin.Wilck <mwilck@arcor.de>

Cleanly increase the seq number when the DDF structures are
written, instead of always setting it back to 1.
---
 super-ddf.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 7fe038e..2f284f3 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2445,7 +2445,14 @@ static int __write_init_super_ddf(struct supertype *st)
 			ddf->anchor.secondary_lba = d->secondary_lba;
 		else
 			ddf->anchor.secondary_lba = __cpu_to_be64(size - 32*1024*2);
-		ddf->anchor.seq = __cpu_to_be32(1);
+		if (ddf->primary.seq != 0xffffffff)
+			ddf->anchor.seq = __cpu_to_be32(
+				__be32_to_cpu(ddf->primary.seq)+1);
+		else if (ddf->secondary.seq != 0xffffffff)
+			ddf->anchor.seq = __cpu_to_be32(
+				__be32_to_cpu(ddf->secondary.seq)+1);
+		else
+			ddf->anchor.seq = __cpu_to_be32(1);
 		memcpy(&ddf->primary, &ddf->anchor, 512);
 		memcpy(&ddf->secondary, &ddf->anchor, 512);
 
-- 
1.7.1
