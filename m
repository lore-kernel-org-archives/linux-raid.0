From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - Fix bug in /proc/mdstat
Date: Wed, 18 Jun 2003 10:28:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19SQog-0000Vc-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[These 3 patches for 2.4.22-pre - thanks]

If /proc/mdstat is large, or reads are for a small size,
then the last line of /proc/mdstat is repeated nearly 65536 times.

This patch will fix it.


diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-06-18 10:02:57.000000000 +1000
+++ ./drivers/md/md.c	2003-06-18 10:02:57.000000000 +1000
@@ -3155,7 +3155,7 @@ static void *md_seq_start(struct seq_fil
 	loff_t l = *pos;
 	mddev_t *mddev;
 
-	if (l > 0x10000)
+	if (l >= 0x10000)
 		return NULL;
 	if (!l--)
 		/* header */
@@ -3166,7 +3166,9 @@ static void *md_seq_start(struct seq_fil
 			mddev = list_entry(tmp, mddev_t, all_mddevs);
 			return mddev;
 		}
-	return (void*)2;/* tail */
+	if (!l--)	
+		return (void*)2;/* tail */
+	return NULL;
 }
 
 static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
