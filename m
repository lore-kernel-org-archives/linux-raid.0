From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 13/14] Check if md allows to control reshape
Date: Fri, 16 Sep 2011 13:55:25 +0200
Message-ID: <20110916115525.5201.42756.stgit@gklab-128-013.igk.intel.com>
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

It can happen that there is no mdadm in memory and 'max' was already
set to sync_max. Such array cannot be put under check pointing control
again.

Verify such situation and refuse to control array in such condition.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index d54b8a8..04e6679 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3656,6 +3656,7 @@ int Grow_continue_command(char *devname, int fd,
 	int spares;
 	int working_disks;
 	struct mdinfo *dev;
+	char buf[40];
 
 	dprintf("Grow continue from command line called for %s\n",
 		devname);
@@ -3769,6 +3770,24 @@ int Grow_continue_command(char *devname, int fd,
 		}
 	}
 
+	/* verify that array under reshape is stopped
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
+	if (strncmp(buf, "max", 3) == 0) {
+		fprintf(stderr, Name ": md is not allowed to finish reshape "
+			"wihout mdadm assistance.\n");
+		ret_val = 1;
+		goto Grow_continue_command_exit;
+	}
+
 	/* continue reshape
 	 */
 	dev = content->devs;

