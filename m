From: mwilck@arcor.de
Subject: [PATCH 2/8] DDF: __write_init_super_ddf: just use seq number of active header
Date: Mon, 25 Mar 2013 23:11:07 +0000 (UTC)
Message-ID: <1382695659-6231-3-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:33 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

It's not necessary to check for 0xffffffff, which is a valid
sequential number.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 32dd023..85af345 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2483,12 +2483,7 @@ static int __write_init_super_ddf(struct supertype *st)
 	}
 	memset(null_aligned, 0xff, NULL_CONF_SZ);
 
-	if (ddf->primary.seq != 0xffffffff)
-		seq = __cpu_to_be32(__be32_to_cpu(ddf->primary.seq)+1);
-	else if (ddf->secondary.seq != 0xffffffff)
-		seq = __cpu_to_be32(__be32_to_cpu(ddf->secondary.seq)+1);
-	else
-		seq = __cpu_to_be32(1);
+	seq = ddf->active->seq + 1;
 
 	/* try to write updated metadata,
 	 * if we catch a failure move on to the next disk
-- 
1.7.1
