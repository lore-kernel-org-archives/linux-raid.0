From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 1/2] fix: adding spare via incremental do not trigger recovery
Date: Fri, 17 Dec 2010 15:17:31 +0100
Message-ID: <20101217141731.4219.97937.stgit@gklab-170-211.igk.intel.com>
References: <20101217141641.4219.88151.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101217141641.4219.88151.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

After incremental has added spare, monitor should be woken up in order
to see if anything has changed. If mdmon is not waken up, recovery do not
start.
---
 Incremental.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index bc4531a..abd7b81 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -443,6 +443,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	/* 7/ Is there enough devices to possibly start the array? */
 	/* 7a/ if not, finish with success. */
 	if (info.array.level == LEVEL_CONTAINER) {
+		char *devname = NULL;
 		/* Try to assemble within the container */
 		map_unlock(&map);
 		sysfs_uevent(&info, "change");
@@ -451,6 +452,8 @@ int Incremental(char *devname, int verbose, int runstop,
 				": container %s now has %d devices\n",
 				chosen_name, info.array.working_disks);
 		wait_for(chosen_name, mdfd);
+		if (st->ss->external)
+				 devname = devnum2devname(fd2devnum(mdfd));
 		close(mdfd);
 		sysfs_free(sra);
 		rv = Incremental(chosen_name, verbose, runstop,
@@ -460,6 +463,12 @@ int Incremental(char *devname, int verbose, int runstop,
 			 * have enough devices to start yet
 			 */
 			rv = 0;
+		/* after spare is added, ping monitor for external metadata
+		 * so that it can eg. try to rebuild degraded array */
+		if (st->ss->external) {
+			ping_monitor(devname);
+			free(devname);
+		}
 		return rv;
 	}
 

