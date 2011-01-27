From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/2] FIX: Remove disks in mdmon for external metadata
Date: Thu, 27 Jan 2011 17:46:50 +0100
Message-ID: <20110127164650.11703.76382.stgit@gklab-128-111.igk.intel.com>
References: <20110127154905.11703.56960.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110127154905.11703.56960.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

For raid10 -> raid0 takeover operation we should reject disks
in mirror by marking them as 'failed' and then remove them from
array by writing "remove" to disk state.

For external metadata second action is executed by mdmon.
According the description in monitor.c:175 when monitor detect
"faulty" in device state, it blocks the device, mark it as failed
in metadata, unblocks the device and finally writes "remove"
to device state.
For external case writing "remove" to device state in mdadm
is not necessary and harmful.
It may cause following issues:
1. "remove" operation for external case in mdadm is not finish
with successful result because monitor may block the device or disk
has been already removed by monitor.
2. If disk is removed by mdadm earlier than mdmon catch "failed" state,
metadata is not properly updated- is not marked as failed.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index c7e40c0..8c6ff23 100644
--- a/Grow.c
+++ b/Grow.c
@@ -719,7 +719,9 @@ int remove_disks_for_takeover(struct supertype *st,
 
 		sysfs_set_str(sra, sd, "state", "faulty");
 		sysfs_set_str(sra, sd, "slot", "none");
-		sysfs_set_str(sra, sd, "state", "remove");
+		/* for external metadata disks should be removed in mdmon */
+		if (!st->ss->external)
+			sysfs_set_str(sra, sd, "state", "remove");
 		sd->disk.state |= (1<<MD_DISK_REMOVED);
 		sd->disk.state &= ~(1<<MD_DISK_SYNC);
 		sd->next = sra->devs;

