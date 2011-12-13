From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/3] FIX: Do not allow for multiple reshape_array() execution
	during reshape_container() call
Date: Tue, 13 Dec 2011 11:12:10 +0100
Message-ID: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

It can happen during reshape restart that reshape_array() can exit without
error (e.g. Grow.c:1915) and reshape is not moved to next array.
reshape_array() is called again for the same device.
Do not allow for such execution and check if last reshaped array is not
the current one.
This patch can be treat not as solution, but it allows for such errors
detection.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 184a973..1828f83 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2462,6 +2462,7 @@ int reshape_container(char *container, char *devname,
 {
 	struct mdinfo *cc = NULL;
 	int rv = restart;
+	int last_devnum = -1;
 
 	/* component_size is not meaningful for a container,
 	 * so pass '-1' meaning 'no change'
@@ -2546,6 +2547,17 @@ int reshape_container(char *container, char *devname,
 		if (!adev)
 			adev = content->text_version;
 
+		if (last_devnum == mdstat->devnum) {
+			/* do not allow for reentry reshape_array()
+			 * for the same device. It can happen when resahpe_array
+			 */
+			printf(Name ": Multiple reshape execution detected for "
+			       "device  %s.", adev);
+			close(fd);
+			break;
+		}
+		last_devnum = mdstat->devnum;
+
 		sysfs_init(content, fd, mdstat->devnum);
 
 		rv = reshape_array(container, fd, adev, st,

