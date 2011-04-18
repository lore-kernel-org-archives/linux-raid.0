From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Check correctly raid disks during reshape restart
Date: Mon, 18 Apr 2011 11:43:30 +0200
Message-ID: <20110418094329.5842.46551.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During reshape restart info->array.raid_disks contains new raid_disks number
It cannot be compared against old disks number. Such check will always fail.

Check raid disks array field against final disks number for restart.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9c1f096..643d3c4 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1692,7 +1692,8 @@ static int reshape_array(char *container, int fd, char *devname,
 	if (restart &&
 	    (reshape.level != info->array.level ||
 	     reshape.before.layout != info->array.layout ||
-	     reshape.before.data_disks + reshape.parity != info->array.raid_disks)) {
+	     reshape.after.data_disks + reshape.parity !=
+						info->array.raid_disks)) {
 		fprintf(stderr, Name ": reshape info is not in native format -"
 			" cannot continue.\n");
 		goto release;

