From: mwilck@arcor.de
Subject: [PATCH 1/8] DDF: __write_ddf_structure: Fix wrong reference to ddf->primary
Date: Mon, 25 Mar 2013 23:11:01 +0000 (UTC)
Message-ID: <1382695659-6231-2-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:32 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Should reference "header" instead here.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index c5f6f5c..32dd023 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2443,7 +2443,7 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 					&dummy);
 		}
 		if (c) {
-			vdc->seqnum = ddf->primary.seq;
+			vdc->seqnum = header->seq;
 			vdc->crc = calc_crc(vdc, conf_size);
 			if (write(fd, vdc, conf_size) < 0)
 				break;
-- 
1.7.1
