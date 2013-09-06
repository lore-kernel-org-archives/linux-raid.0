From: mwilck@arcor.de
Subject: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Fri,  6 Sep 2013 23:26:20 +0200
Message-ID: <1378502781-849-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Print an array name in brief output. Do this even if no name is set,
faking a simple pseudo name (may happen for some BIOS RAIDs).
This makes DDF and IMSM behave equally.

SUSE's YaST2 needs this in order to detect MD arrays during
installation.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8bba70a..72a8351 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -30,6 +30,7 @@
 #include "mdmon.h"
 #include "sha1.h"
 #include <values.h>
+#include <ctype.h>
 
 /* a non-official T10 name for creation GUIDs */
 static char T10[] = "Linux-MD";
@@ -1577,14 +1578,22 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 		struct virtual_entry *ve = &ddf->virt->entries[i];
 		struct vcl vcl;
 		char nbuf1[64];
+		char namebuf[sizeof(ve->name)+1], *c;
 		if (all_ff(ve->guid))
 			continue;
 		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
 		ddf->currentconf =&vcl;
 		uuid_from_super_ddf(st, info.uuid);
 		fname_from_uuid(st, &info, nbuf1, ':');
-		printf("ARRAY container=%s member=%d UUID=%s\n",
-		       nbuf+5, i, nbuf1+5);
+		memcpy(namebuf, ve->name, sizeof(ve->name));
+		namebuf[sizeof(ve->name)] = '\0';
+		if (namebuf[0] == '\0')
+			sprintf(namebuf, "ddf_%d", i);
+		for (c = namebuf; c < namebuf + sizeof(ve->name); c++)
+			if (isspace(*c))
+				*c = '-';
+		printf("ARRAY /dev/md/%s container=%s member=%d UUID=%s\n",
+		       namebuf, nbuf+5, i, nbuf1+5);
 	}
 }
 
-- 
1.7.3.4
