From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 4 - Fix bug in /proc/mdstat
Date: Thu, 05 Jun 2003 11:51:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19Njun-0005Fx-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

If /proc/mdstat is large, or reads are for a small size,
then the last line of /proc/mdstat is repeated infinitely.

This patch will fix it.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-06-05 11:33:56.000000000 +1000
+++ ./drivers/md/md.c	2003-06-05 11:34:19.000000000 +1000
@@ -2860,7 +2860,7 @@ static void *md_seq_start(struct seq_fil
 	loff_t l = *pos;
 	mddev_t *mddev;
 
-	if (l > 0x10000)
+	if (l >= 0x10000)
 		return NULL;
 	if (!l--)
 		/* header */
@@ -2875,7 +2875,9 @@ static void *md_seq_start(struct seq_fil
 			return mddev;
 		}
 	spin_unlock(&all_mddevs_lock);
-	return (void*)2;/* tail */
+	if (!l--)
+		return (void*)2;/* tail */
+	return NULL;
 }
 
 static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
