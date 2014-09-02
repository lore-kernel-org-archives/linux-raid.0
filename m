From: Phil Kauffman <kauffman@cs.uchicago.edu>
Subject: [PATCH] Monitor.c (trivial) Remove bedside manner in email text.
Date: Tue,  2 Sep 2014 14:27:48 -0500
Message-ID: <1409686068-9888-1-git-send-email-kauffman@cs.uchicago.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Phil Kauffman <kauffman@cs.uchicago.edu>
List-Id: linux-raid.ids

The words removed are superfluous and add no value to the message.
In addition, they imply that the message is from a person,
which is obviously not the case.
---
 Monitor.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 5cb24fa..74a88e1 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -402,14 +402,12 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
 			if (disc && disc[0] == ' ')
 				fprintf(mp, "Extra information:%s.\n\n", disc);
 
-			fprintf(mp, "Faithfully yours, etc.\n");
-
 			mdstat = fopen("/proc/mdstat", "r");
 			if (mdstat) {
 				char buf[8192];
 				int n;
 				fprintf(mp,
-					"\nP.S. The /proc/mdstat file"
+					"\nThe /proc/mdstat file"
 					" currently contains the following:\n\n");
 				while ( (n=fread(buf, 1, sizeof(buf), mdstat)) > 0)
 					n=fwrite(buf, 1, n, mp);
-- 
1.7.9.5

