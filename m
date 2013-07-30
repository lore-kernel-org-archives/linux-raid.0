From: mwilck@arcor.de
Subject: [PATCH 04/10] DDF: load_ddf_header: more error logging
Date: Tue, 30 Jul 2013 23:18:28 +0200
Message-ID: <1375219114-5626-5-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

Try to determine problem if load_ddf_header fails. May be useful
for determining compatibility problems with Fake RAID BIOSes.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index b639f07..f55cc11 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -754,18 +754,24 @@ static int load_ddf_header(int fd, unsigned long long lba,
 	if (read(fd, hdr, 512) != 512)
 		return 0;
 
-	if (!be32_eq(hdr->magic, DDF_HEADER_MAGIC))
+	if (!be32_eq(hdr->magic, DDF_HEADER_MAGIC)) {
+		pr_err("%s: bad header magic\n", __func__);
 		return 0;
-	if (!be32_eq(calc_crc(hdr, 512), hdr->crc))
+	}
+	if (!be32_eq(calc_crc(hdr, 512), hdr->crc)) {
+		pr_err("%s: bad CRC\n", __func__);
 		return 0;
+	}
 	if (memcmp(anchor->guid, hdr->guid, DDF_GUID_LEN) != 0 ||
 	    memcmp(anchor->revision, hdr->revision, 8) != 0 ||
 	    !be64_eq(anchor->primary_lba, hdr->primary_lba) ||
 	    !be64_eq(anchor->secondary_lba, hdr->secondary_lba) ||
 	    hdr->type != type ||
 	    memcmp(anchor->pad2, hdr->pad2, 512 -
-		   offsetof(struct ddf_header, pad2)) != 0)
+		   offsetof(struct ddf_header, pad2)) != 0) {
+		pr_err("%s: header mismatch\n", __func__);
 		return 0;
+	}
 
 	/* Looks good enough to me... */
 	return 1;
-- 
1.7.1
