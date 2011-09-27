From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/8] Verify reshape restart position
Date: Tue, 27 Sep 2011 14:05:22 +0200
Message-ID: <20110927120522.4890.83002.stgit@gklab-128-013.igk.intel.com>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Check if reshape restart position is the same as set in md.
If position doesn't match this means that we cannot restart reshape.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index afe4c72..3ff249d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3653,6 +3653,8 @@ int Grow_continue_command(char *devname, int fd,
 	char buf[40];
 	int cfd = -1;
 	int fd2 = -1;
+	char *ep;
+	unsigned long long position;
 
 	dprintf("Grow continue from command line called for %s\n",
 		devname);
@@ -3754,6 +3756,36 @@ int Grow_continue_command(char *devname, int fd,
 		}
 	}
 
+	/* verify that array under reshape is started from
+	 * correct position
+	 */
+	ret_val = sysfs_get_str(content, NULL, "sync_max", buf, 40);
+	if (ret_val <= 0) {
+		fprintf(stderr, Name
+			": cannot open verify reshape progress for %s (%i)\n",
+			content->sys_name, ret_val);
+		ret_val = 1;
+		goto Grow_continue_command_exit;
+	}
+	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
+	errno = 0;
+	position = strtoull(buf, &ep, 0);
+	if (errno || ep == buf || (*ep != 0 && *ep != '\n' && *ep != ' ')) {
+		fprintf(stderr, Name ": md is not allowed to finish reshape "
+			"wihout mdadm assistance.\n");
+		ret_val = 1;
+		goto Grow_continue_command_exit;
+	}
+	position *= get_data_disks(map_name(pers, mdstat->level),
+				   content->new_layout,
+				   content->array.raid_disks);
+	if (position != content->reshape_progress) {
+		fprintf(stderr, Name ": md is not allowed to finish reshape "
+			"wihout mdadm assistance.\n");
+		ret_val = 1;
+		goto Grow_continue_command_exit;
+	}
+
 	/* continue reshape
 	 */
 	ret_val = Grow_continue(fd, st, content, backup_file,

