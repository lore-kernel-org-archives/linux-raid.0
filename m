From: mwilck@arcor.de
Subject: [PATCH 23/27] DDF: guid_str: convenience function to print GUID for debugging
Date: Wed,  3 Jul 2013 22:28:03 +0200
Message-ID: <1372883287-8859-24-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

For debugging DDF structure changes, it is important to be able
to identify VCs by their GUIDs.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index cd6f298..bfb7f22 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1293,6 +1293,17 @@ static void print_guid(char *guid, int tstamp)
 	printf(")");
 }
 
+static const char *guid_str(const char *guid)
+{
+	static char buf[DDF_GUID_LEN*2+1];
+	int i;
+	char *p = buf;
+	for (i = 0; i < DDF_GUID_LEN; i++)
+		p += sprintf(p, "%02x", (unsigned char)guid[i]);
+	*p = '\0';
+	return (const char *) buf;
+}
+
 static void examine_vd(int n, struct ddf_super *sb, char *guid)
 {
 	int crl = sb->conf_rec_len;
@@ -2789,6 +2800,9 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 					&dummy);
 		}
 		if (c) {
+			dprintf("writing conf record %i on disk %08x for %s/%u\n",
+				i, d->disk.refnum, guid_str(vdc->guid),
+				vdc->sec_elmnt_seq);
 			vdc->seqnum = header->seq;
 			vdc->crc = calc_crc(vdc, conf_size);
 			if (write(fd, vdc, conf_size) < 0)
-- 
1.7.1
