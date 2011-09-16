From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/14] Check and run mdmon
Date: Fri, 16 Sep 2011 13:54:32 +0200
Message-ID: <20110916115432.5201.77432.stgit@gklab-128-013.igk.intel.com>
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

Reshape can be run for external metadata for monitored array/container
only. In case when array/container is not monitored run mdmon for it.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 2b2cb5a..4d2c361 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3672,6 +3672,21 @@ int Grow_continue_command(char *devname, int fd,
 		}
 
 		sysfs_init(content, fd2, mdstat->devnum);
+
+		/* start mdmon in case it is not run
+		 */
+		if (!mdmon_running(container_dev))
+			start_mdmon(container_dev);
+		ping_monitor(container);
+
+		if (mdmon_running(container_dev))
+			st->update_tail = &st->updates;
+		else {
+			fprintf(stderr, Name ":  No mdmon found. "
+				"Grow cannot continue.\n");
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
 	}
 
 	/* continue reshape

