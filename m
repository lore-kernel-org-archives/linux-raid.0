From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6/9] mdmon: fix, close spare activation race
Date: Thu, 25 Aug 2011 19:14:29 -0700
Message-ID: <20110826021429.28015.70970.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following test fails when the md_check_recovery() event triggered by
the ro->rw transition causes remove_and_add_spares() to run while mdmon
is attempting spare activation.

Result is that the kernel races to set the slot immediately after
sysfs_add_disk() writes new_dev.  mdmon thinks the spare activation
failed and declines to send the monitor a new acitve_array.  We show
degraded after the wait because the monitor cannot notify the metadata
that all disks are in_sync.

#!/bin/bash
i=0
false
while [ $? == 1 ]
do
	i=$((i+1))
	mdadm -Ss
	mdadm -CR /dev/md0 /dev/loop[0-2] -n 3 -e imsm
	mdadm -CR /dev/md1 /dev/loop[01] missing -n 3 -l 5
	mdadm --wait /dev/md1
	mdadm -E /dev/loop2 | grep -i degraded
done
echo "failed: $i"

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 managemon.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/managemon.c b/managemon.c
index 6662f67..d020f82 100644
--- a/managemon.c
+++ b/managemon.c
@@ -498,7 +498,10 @@ static void manage_member(struct mdstat_ent *mdstat,
 		newa = duplicate_aa(a);
 		if (!newa)
 			goto out;
-		/* Cool, we can add a device or several. */
+		/* prevent the kernel from activating the disk(s) before we
+		 * finish adding them
+		 */
+		sysfs_set_str(&a->info, NULL, "sync_action", "frozen");
 
 		/* Add device to array and set offset/size/slot.
 		 * and open files for each newdev */

