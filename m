From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/14] Add possibility to restart reshape for native metadata
Date: Fri, 16 Sep 2011 13:55:10 +0200
Message-ID: <20110916115510.5201.47643.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When mdadm services native metadata, check-pointing functions
can lost file system context in the same way as for external metadata.

This patch adds native metadata continuation support.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index da8b72d..fa22382 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3646,6 +3646,7 @@ int Grow_continue_command(char *devname, int fd,
 	int ret_val = 0;
 	struct supertype *st = NULL;
 	struct mdinfo *content = NULL;
+	struct mdinfo array;
 	char *subarray = NULL;
 	struct mdinfo *cc = NULL;
 	struct mdstat_ent *mdstat = NULL;
@@ -3669,12 +3670,14 @@ int Grow_continue_command(char *devname, int fd,
 	dprintf("Grow continue is run for ");
 	if (st->ss->external == 0) {
 		dprintf("native array (%s)\n", devname);
-		/* FIXME : temporary just exit
-		 * for native metadata case
-		 */
-		st->ss->free_super(st);
-		free(subarray);
-		exit(0);
+		if (ioctl(fd, GET_ARRAY_INFO, &array) < 0) {
+			fprintf(stderr, Name ": %s is not an active md array -"
+				" aborting\n", devname);
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+		content = &array;
+		sysfs_init(content, fd, st->devnum);
 	} else {
 		int container_dev;
 

