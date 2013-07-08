From: mwilck@arcor.de
Subject: [PATCH 37/39] DDF: guid_str: more readable output
Date: Mon,  8 Jul 2013 23:50:46 +0200
Message-ID: <1373320248-7520-11-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Print ASCII characters as ASCII
---
 super-ddf.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 1cb0a9f..428e8f3 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1301,8 +1301,13 @@ static const char *guid_str(const char *guid)
 	static char buf[DDF_GUID_LEN*2+1];
 	int i;
 	char *p = buf;
-	for (i = 0; i < DDF_GUID_LEN; i++)
-		p += sprintf(p, "%02x", (unsigned char)guid[i]);
+	for (i = 0; i < DDF_GUID_LEN; i++) {
+		unsigned char c = guid[i];
+		if (c >= 32 && c < 127)
+			p += sprintf(p, "%c", c);
+		else
+			p += sprintf(p, "%02x", c);
+	}
 	*p = '\0';
 	return (const char *) buf;
 }
-- 
1.7.1
