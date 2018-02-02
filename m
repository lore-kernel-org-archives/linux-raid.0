From: John Pittman <jpittman@redhat.com>
Subject: [PATCH] mdadm: Expose Kill() return codes to user
Date: Fri,  2 Feb 2018 11:06:57 -0500
Message-ID: <1517587617-2978-1-git-send-email-jpittman@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, John Pittman <jpittman@redhat.com>
List-Id: linux-raid.ids

In misc_list(), case KillOpt, the return values from the Kill()
function are saved, but soon after cleared with a bitwise OR 
assignment.  Expose these return values to the user, indicating 
success of the zeroing operation or an error value to accompany 
the error message printed to the console.

Before:

   # mdadm -C /dev/md0 -l 1 -n 2 -e 1.2 /dev/sda /dev/sdb
   mdadm: array /dev/md0 started.
   # mdadm --zero-superblock /dev/sdb
   mdadm: Couldn't open /dev/sdb for write - not zeroing
   # echo $?
   0

After:

   # mdadm -C /dev/md0 -l 1 -n 2 -e 1.2 /dev/sda /dev/sdb
   mdadm: array /dev/md0 started.
   # mdadm --zero-superblock /dev/sdb
   mdadm: Couldn't open /dev/sdb for write - not zeroing
   # echo $?
   2

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 mdadm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index afc3015..77b80fa 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1937,7 +1937,6 @@ static int misc_list(struct mddev_dev *devlist,
 					rv |= Kill(dv->devname, NULL, c->force, v, 0);
 					v = -1;
 				} while (rv == 0);
-				rv &= ~2;
 			}
 			continue;
 		case 'Q':
-- 
2.7.5

