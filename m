From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] FIX: mdmon doesn't start
Date: Thu, 03 Nov 2011 17:55:33 +0100
Message-ID: <20111103165532.8864.80753.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When array is not clean dismounted directory /dev/.mdadm is not cleaned up.
On array re-assembly read pid is not valid and it is not possible
to connect to monitor. This causes mdmon to exit and array remains
not monitored.
Problem is introduced by fix:
   mdmon(): Error out if failing to connect to victim monitor
   819c158866f466075a1c719f0dc496deb2fb3814

This is critical for container reshape when mdmon is should finish reshape.
when reshape is not finished, array is reshaped again by mdadm.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdmon.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index bdcda0e..5ac7cd6 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -458,11 +458,16 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
 
 	victim = mdmon_pid(container->devnum);
 	if (victim >= 0) {
-		victim_sock = connect_monitor(container->devname);
-		if (victim_sock < 0) {
-			fprintf(stderr, "mdmon: %s unable to connect monitor\n",
-				container->devname);
-			exit(3);
+		/* It is possible that mdmon that wrote pid file was killed.
+		 * check if read pid is valid/mdmon is running
+		 */
+		if (mdmon_running(victim)) {
+			victim_sock = connect_monitor(container->devname);
+			if (victim_sock < 0) {
+				fprintf(stderr, "mdmon: %s unable to connect "
+					"monitor\n", container->devname);
+				exit(3);
+			}
 		}
 	}
 

