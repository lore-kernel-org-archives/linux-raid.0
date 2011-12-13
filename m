From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/3] FIX: Add error message in container_reshape()
Date: Tue, 13 Dec 2011 11:12:18 +0100
Message-ID: <20111213101218.15703.22577.stgit@gklab-128-013.igk.intel.com>
References: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Add proper error message for container reshape when device cannot be opened.
fd variable operation is moved down to display information what particular
device cannot be opened.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1828f83..97f6973 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2538,15 +2538,19 @@ int reshape_container(char *container, char *devname,
 		if (!content)
 			break;
 
-		fd = open_dev(mdstat->devnum);
-		if (fd < 0)
-			break;
 		adev = map_dev(dev2major(mdstat->devnum),
 			       dev2minor(mdstat->devnum),
 			       0);
 		if (!adev)
 			adev = content->text_version;
 
+		fd = open_dev(mdstat->devnum);
+		if (fd < 0) {
+			printf(Name ": Device %s cannot be opened for reshape.",
+			       adev);
+			break;
+		}
+
 		if (last_devnum == mdstat->devnum) {
 			/* do not allow for reentry reshape_array()
 			 * for the same device. It can happen when resahpe_array

