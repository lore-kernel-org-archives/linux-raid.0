From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] Partitions could be meaningful on single-drive RAID0
Date: Fri, 25 Feb 2011 07:30:51 +0100
Message-ID: <20110225063051.24710.33725.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If we create a single-drive RAID0 array on partitioned drive,
we do not lose information about disk structure after operation
(partitions are visible on created array)
Warning message:

mdadm: partition table exists on /dev/sdX but will be lost or
       meaningless after creating array"

is not necessary during creation single-drive RAID0 array.
This patch removes the message.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Create.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Create.c b/Create.c
index 1cadbcc..bbd25e5 100644
--- a/Create.c
+++ b/Create.c
@@ -381,7 +381,8 @@ int Create(struct supertype *st, char *mddev,
 			    st->minor_version >= 1)
 				/* metadata at front */
 				warn |= check_partitions(fd, dname, 0);
-			else if (level == 1 || level == LEVEL_CONTAINER)
+			else if (level == 1 || level == LEVEL_CONTAINER
+				    || (level == 0 && raiddisks == 1))
 				/* partitions could be meaningful */
 				warn |= check_partitions(fd, dname, freesize*2);
 			else

