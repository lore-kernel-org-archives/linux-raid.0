From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 5] Report spare drives in /proc/mdstat
Date: Fri, 02 Sep 2005 16:12:54 +1000
Message-ID: <E1EB4nG-0008NM-38@notabene.cse.unsw.edu.au>
References: <20050902161106.32018.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Just like failed drives have (F), so spare drives now have (S).


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-09-02 15:59:50.000000000 +1000
+++ ./drivers/md/md.c	2005-09-02 16:00:04.000000000 +1000
@@ -3334,7 +3334,8 @@ static int md_seq_show(struct seq_file *
 			if (rdev->faulty) {
 				seq_printf(seq, "(F)");
 				continue;
-			}
+			} else if (rdev->raid_disk < 0)
+				seq_printf(seq, "(S)"); /* spare */
 			size += rdev->size;
 		}
 
