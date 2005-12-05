From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 2] Change case of raid level reported in sys/mdX/md/level
Date: Mon, 5 Dec 2005 14:17:05 +1100
Message-ID: <1051205031705.21038@suse.de>
References: <20051205141310.20937.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I had thought that keeping the reported raid level clearly
different from the module name was a good idea, but I've changed
my mind.
'raid5' is better and probably less confusing than 'RAID-5'.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-05 10:22:30.000000000 +1100
+++ ./drivers/md/md.c	2005-12-05 10:23:51.000000000 +1100
@@ -1730,7 +1730,7 @@ level_show(mddev_t *mddev, char *page)
 	if (p == NULL && mddev->raid_disks == 0)
 		return 0;
 	if (mddev->level >= 0)
-		return sprintf(page, "RAID-%d\n", mddev->level);
+		return sprintf(page, "raid%d\n", mddev->level);
 	else
 		return sprintf(page, "%s\n", p->name);
 }
