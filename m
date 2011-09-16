From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/14] Perform restore backup for reshape continuation
Date: Fri, 16 Sep 2011 13:55:03 +0200
Message-ID: <20110916115503.5201.11096.stgit@gklab-128-013.igk.intel.com>
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

It can happen that reshape is broken by different reason than reboot.
this means that on reshape continuation start we cannot be sure
that critical section has been restored already.

Restore data from checkpoint before reshape continuation to avoid
data corruption.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0b96f7a..da8b72d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3652,6 +3652,9 @@ int Grow_continue_command(char *devname, int fd,
 	char container[20];
 	int cfd = -1;
 	int fd2 = -1;
+	int spares;
+	int working_disks;
+	struct mdinfo *dev;
 
 	dprintf("Grow continue from command line called for %s\n",
 		devname);
@@ -3753,7 +3756,20 @@ int Grow_continue_command(char *devname, int fd,
 
 	/* continue reshape
 	 */
-	ret_val = Grow_continue(fd, st, content, backup_file);
+	dev = content->devs;
+	spares = 0;
+	working_disks = 0;
+	while (dev) {
+		if (dev->disk.raid_disk == -1)
+			spares++;
+		else
+			working_disks++;
+		dev = dev->next;
+	}
+	ret_val = restore_backup(st, content, working_disks, spares,
+				 backup_file, verbose);
+	if (!ret_val)
+		ret_val = Grow_continue(fd, st, content, backup_file);
 
 Grow_continue_command_exit:
 	if (fd2 > -1)

