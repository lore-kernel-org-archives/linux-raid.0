From: mwilck@arcor.de
Subject: [PATCH 2/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Wed, 11 Sep 2013 21:55:35 +0200
Message-ID: <1378929335-12606-2-git-send-email-mwilck@arcor.de>
References: <5230C98B.7030902@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230C98B.7030902@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Print an array name in brief output, like IMSM does.

SUSE's YaST2 (libstorage) needs this in order to detect MD arrays
during installation.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index c2ac88b..00a5c8b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1518,6 +1518,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 
 static void uuid_from_ddf_guid(const char *guid, int uuid[4]);
 static void uuid_from_super_ddf(struct supertype *st, int uuid[4]);
+static void _ddf_array_name(char *name, const struct ddf_super *ddf, int i);
 
 static unsigned int get_vd_num_of_subarray(struct supertype *st)
 {
@@ -1577,6 +1578,7 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 		struct virtual_entry *ve = &ddf->virt->entries[i];
 		struct vcl vcl;
 		char nbuf1[64];
+		char namebuf[17];
 		if (all_ff(ve->guid))
 			continue;
 		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
@@ -1584,7 +1586,9 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 		vcl.vcnum = i;
 		uuid_from_super_ddf(st, info.uuid);
 		fname_from_uuid(st, &info, nbuf1, ':');
-		printf("ARRAY container=%s member=%d UUID=%s\n",
+		_ddf_array_name(namebuf, ddf, i);
+		printf("ARRAY%s%s container=%s member=%d UUID=%s\n",
+		       namebuf[0] == '\0' ? "" : " /dev/md/", namebuf,
 		       nbuf+5, i, nbuf1+5);
 	}
 }
-- 
1.7.3.4
