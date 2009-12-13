From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/2] md: rcu_read_lock() walk of mddev->disks in md_do_sync()
Date: Sat, 12 Dec 2009 21:17:06 -0700
Message-ID: <20091213041706.12532.19054.stgit@dwillia2-linux.ch.intel.com>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Other walks of this list are either under rcu_read_lock() or the list
mutation lock (mddev_lock()).  This protects against the improbable case of a
disk being removed from the array at the start of md_do_sync().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/md.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b182f86..3e8fb67 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6342,12 +6342,14 @@ void md_do_sync(mddev_t *mddev)
 		/* recovery follows the physical size of devices */
 		max_sectors = mddev->dev_sectors;
 		j = MaxSector;
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rcu_read_lock();
+		list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags) &&
 			    rdev->recovery_offset < j)
 				j = rdev->recovery_offset;
+		rcu_read_unlock();
 	}
 
 	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
@@ -6516,12 +6518,14 @@ void md_do_sync(mddev_t *mddev)
 		} else {
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 				mddev->curr_resync = MaxSector;
-			list_for_each_entry(rdev, &mddev->disks, same_set)
+			rcu_read_lock();
+			list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Faulty, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
 				    rdev->recovery_offset < mddev->curr_resync)
 					rdev->recovery_offset = mddev->curr_resync;
+			rcu_read_unlock();
 		}
 	}
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);

