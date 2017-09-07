From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Grow: stop previous reshape process first
Date: Thu,  7 Sep 2017 13:01:16 +0200
Message-ID: <1504782076-1664-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If array is stopped during reshape and assembled again straight away,
reshape process in a background might still be running. systemd doesn't
start a new service if one already exists. If there is a race, previous
process might terminate and new one is not created. Reshape doesn't
continue after assemble.

Tell systemd to restart the service rather than just start it. It will
assure previous service is stopped first. If it's not running, stopping
has no effect and only new process is started.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Grow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 534ba80..267b06f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3003,9 +3003,9 @@ static int continue_via_systemd(char *devnm)
 		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@%s.service",
 			 devnm);
 		status = execl("/usr/bin/systemctl", "systemctl",
-			       "start",
+			       "restart",
 			       pathbuf, NULL);
-		status = execl("/bin/systemctl", "systemctl", "start",
+		status = execl("/bin/systemctl", "systemctl", "restart",
 			       pathbuf, NULL);
 		exit(1);
 	case -1: /* Just do it ourselves. */
-- 
1.8.3.1

