From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 7 of 7 - Make sure md devices appear in /proc/partitions
Date: Fri, 23 Jan 2004 11:14:25 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxt-0000kB-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As they are not partitionable, they don't (how wierd).

 ----------- Diffstat output ------------
 ./drivers/block/genhd.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff ./drivers/block/genhd.c~current~ ./drivers/block/genhd.c
--- ./drivers/block/genhd.c~current~	2004-01-23 10:30:07.000000000 +1100
+++ ./drivers/block/genhd.c	2004-01-23 10:48:23.000000000 +1100
@@ -261,8 +261,14 @@ static int show_partition(struct seq_fil
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	/* Don't show non-partitionable devices or empty devices */
-	if (!get_capacity(sgp) || sgp->minors == 1)
-		return 0;
+	/* ... but do show 'md' devices.  As it isn't clear *why*
+	 * non-partitionable devices are excluded, and as I definately
+	 * want md device to be included, the follow ugly code is
+	 * needed - neilb Jan2004
+	 */
+	if (sgp->disk_name[0] != 'm' || sgp->disk_name[1] != 'd')
+		if (!get_capacity(sgp) || sgp->minors == 1)
+			return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
 	seq_printf(part, "%4d  %4d %10llu %s\n",
