From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Mon, 20 Mar 2017 13:20:29 +0800
Message-ID: <1489987229-22631-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

it would be stuck at the beginning of reshape progress
when grows array from raid1 to raid5, correct the name
of mdadm-grow-continue@.service in continue_via_systemd.

reproduce steps:
./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Grow.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 455c5f9..10c02a1 100755
--- a/Grow.c
+++ b/Grow.c
@@ -2808,13 +2808,11 @@ static int continue_via_systemd(char *devnm)
 		 */
 		close(2);
 		open("/dev/null", O_WRONLY);
-		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@%s.service",
-			 devnm);
+		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@.service");
 		status = execl("/usr/bin/systemctl", "systemctl",
 			       "start",
 			       pathbuf, NULL);
-		status = execl("/bin/systemctl", "systemctl", "start",
-			       pathbuf, NULL);
+		pr_err("/usr/bin/systemctl %s got failure\n", pathbuf);
 		exit(1);
 	case -1: /* Just do it ourselves. */
 		break;
-- 
2.6.6

