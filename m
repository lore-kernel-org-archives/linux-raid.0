From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 2] md: Fix formatting error in /proc/mdstat.
Date: Fri, 7 Mar 2008 16:00:47 +1100
Message-ID: <1080307050047.26113@suse.de>
References: <20080307155754.25976.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


If an md array is "auto-read-only", then this appears in /proc/mdstat
as

   /dev/md0: active(auto-read-only)

whereas if it is truely readonly, it appears as

   /dev/md0: active (read-only)

The difference being a space. 

One program known to parse this file expects the space and gets badly
confused.  It will be fixed, but it would be best if what the kernel
generates is more consistent too.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-03-07 15:51:24.000000000 +1100
+++ ./drivers/md/md.c	2008-03-07 15:52:21.000000000 +1100
@@ -5149,7 +5149,7 @@ static int md_seq_show(struct seq_file *
 			if (mddev->ro==1)
 				seq_printf(seq, " (read-only)");
 			if (mddev->ro==2)
-				seq_printf(seq, "(auto-read-only)");
+				seq_printf(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
