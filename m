From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: delta_disk can have UnSet value
Date: Thu, 27 Jan 2011 10:28:28 +0100
Message-ID: <20110127092828.6759.86014.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Delta_disk can be set to UnSet value.
This can a cause to pass wrong parameter to reshape_super().

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index daf310b..bc015c6 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1575,7 +1575,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 		if (reshape_super(st, info.component_size, info.new_level,
 				  info.new_layout, info.new_chunk,
-				  info.array.raid_disks + info.delta_disks,
+				  info.delta_disks == UnSet ?
+				     info.array.raid_disks :
+				     info.array.raid_disks + info.delta_disks,
 				  backup_file, devname, quiet)) {
 			rv = 1;
 			goto release;

