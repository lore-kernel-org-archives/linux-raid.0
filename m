From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 009/009]: mdadm: 1K chunks for raid0
Date: Tue, 19 May 2009 19:04:57 +0300
Message-ID: <1242749098.3293.56.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
Cc: ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids

fix mdadm to pass 1K*n chunks only in the case of raid0.
Commit is stacked on top mdadm.c
commit c8b4de0cccfba18818416f62687e4094a5b83922
Author: NeilBrown <neilb@suse.de>
Date:   Tue May 12 15:25:55 2009 +1000

 mdadm.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

Signed-off-by: raziebe@gmail.com
---
diff --git a/mdadm.c b/mdadm.c
index 166ea9d..b54e650 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -326,10 +326,25 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			chunk = strtol(optarg, &c, 10);
-			if (!optarg[0] || *c || chunk<4 || ((chunk-1)&chunk)) {
-				fprintf(stderr, Name ": invalid chunk/rounding value: %s\n",
-					optarg);
-				exit(2);
+			/* if level is parsed, chunk is probably ok */
+			if (level == 0) {
+				if ((chunk <= 0 || !optarg[0] || *c)) {
+					fprintf(stderr,
+						Name ": invalid chunk/rounding"
+						" value: %s %d\n",
+						optarg, chunk);
+					exit(2);
+				}
+				continue;
+			}
+			if (level != UnSet)
+				if (!optarg[0] || *c || chunk < 4 ||
+					((chunk-1)&chunk)) {
+					fprintf(stderr, Name
+						": invalid chunk"
+						"/rounding value: %s\n",
+						optarg);
+					exit(2);
 			}
 			continue;
 
@@ -411,6 +426,12 @@ int main(int argc, char *argv[])
 					optarg);
 				exit(2);
 			}
+			if (level != 0 && (chunk % 4)) {
+				fprintf(stderr, Name ": raid level %s must"
+					" have power 2 chunk size\n",
+					optarg);
+				exit(2);
+			}
 			ident.level = level;
 			continue;
 


