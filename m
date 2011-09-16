From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/14] Stop container reshape while using initramfs
Date: Fri, 16 Sep 2011 13:54:02 +0200
Message-ID: <20110916115402.5201.39634.stgit@gklab-128-013.igk.intel.com>
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

When first array in container is set for later reshape mdadm
has exit for remaining container operations. Do not wait for
current reshape finalization as it will be performed manually later.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 420177c..cec32d7 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2435,6 +2435,12 @@ int reshape_container(char *container, char *devname,
 				   content, force, NULL,
 				   backup_file, quiet, 1, restart);
 		close(fd);
+
+		if (initramfs_is_in_use() == INITRAMFS_IS_IN_USE) {
+			sysfs_free(cc);
+			exit(0);
+		}
+
 		restart = 0;
 		if (rv)
 			break;

