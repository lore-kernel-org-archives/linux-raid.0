From: Andrew Burgess <aab@cichlid.com>
Subject: [PATCH] mdadm --detail was incorrect for shrinking reshapes
Date: Mon, 20 Jun 2011 09:06:55 -0700
Message-ID: <1308586015.10185.11@hogo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Since info->delta_disks is signed it doesn't need to be special-cased.

This allowed my 9->8 reshape to display correctly instead of as 8->7

(the "This is pretty boring" context is apparently the universe's
opinion of my first patch!)


mdadm> git diff
diff --git a/Detail.c b/Detail.c
index 375189d..40806cf 100644
--- a/Detail.c
+++ b/Detail.c
@@ -430,12 +430,9 @@ This is pretty boring
  			printf("  Reshape pos'n : %llu%s\n", (unsigned  
long long) info->reshape_progress<<9,
  			       human_size((unsigned long  
long)info->reshape_progress<<9));
  #endif
-			if (info->delta_disks > 0)
+			if (info->delta_disks != 0)
  				printf("  Delta Devices : %d,  
(%d->%d)\n",
  				       info->delta_disks,  
array.raid_disks - info->delta_disks, array.raid_disks);
-			if (info->delta_disks < 0)
-				printf("  Delta Devices : %d,  
(%d->%d)\n",
-				       info->delta_disks,  
array.raid_disks, array.raid_disks + info->delta_disks);
  			if (info->new_level != array.level) {
  				char *c = map_num(pers,  
info->new_level);
  				printf("      New Level : %s\n",  
c?c:"-unknown-");
