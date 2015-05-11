From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: [PATCH] DDF: _write_super_to_disk: fix anchor header type
Date: Mon, 11 May 2015 16:09:44 +0200
Message-ID: <1431353384-8637-1-git-send-email-martin.wilck@ts.fujitsu.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>
List-Id: linux-raid.ids

Since commit 30bee0201, the anchor is updated from the active
DDF header. This requires fixing the header type before the
anchor is written.

The LSI Software RAID code will reject DDF meta data with wrong
anchor type and will erase all meta data when it encounters
such a broken anchor. Thus starting Linux md once on a system
with LSI RAID BIOS may cause the meta data to get destroyed.
---
 super-ddf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/super-ddf.c b/super-ddf.c
index d0b2ac7..faaf0a7 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3158,6 +3158,7 @@ static int _write_super_to_disk(struct ddf_super *ddf, struct dl *d)
 	memcpy(&ddf->primary, &ddf->anchor, 512);
 	memcpy(&ddf->secondary, &ddf->anchor, 512);
 
+	ddf->anchor.type = DDF_HEADER_ANCHOR;
 	ddf->anchor.openflag = 0xFF; /* 'open' means nothing */
 	ddf->anchor.seq = cpu_to_be32(0xFFFFFFFF); /* no sequencing in anchor */
 	ddf->anchor.crc = calc_crc(&ddf->anchor, 512);
-- 
2.1.0

