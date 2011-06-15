From: Jim Paradis <jparadis@redhat.com>
Subject: [PATCH/RFC] Fix resync hang after surprise removal
Date: Wed, 15 Jun 2011 12:02:15 -0400
Message-ID: <20110615160117.31326.31562.sendpatchset@localhost.localdomain>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jim Paradis <jparadis@redhat.com>
List-Id: linux-raid.ids

We ran into a situation where surprise removal of a non-boot 2-disk raid1
array with I/O running can result in a tight loop in which md claims to be
resyncing the array.

It appears that remove_add_spares() in md.c contains two sets of conditions
used to determine if there is a spare available.  The disk that was pulled
has been marked 'faulty' in rdev->flags and its raid_disk value is >= 0.
Since it is neither In_Sync nor Blocked, spares gets incremented and so md
thinks there is a spare when in fact there is not.

One of my colleagues at Stratus proposed this patch, which rearranges the
order of the tests and makes them mutually exclusive.  Running with this
patch resolves the problem in our lab: we were able to run stress tests
with surprise removals without incident.

Since neither of us is an md expert, we'd like feedback as to whether
this patch is reasonable and whether it can be pushed upstream.

Jim Paradis
Onsite Red Hat Partner Engineer
Stratus Technologies, Inc.

 md.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Signed-off-by: Jim Paradis <james.paradis@stratus.com>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4332fc2..cdc5276 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7086,10 +7086,6 @@ static int remove_and_add_spares(mddev_t *mddev)
 
 	if (mddev->degraded && !mddev->recovery_disabled) {
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    !test_bit(Blocked, &rdev->flags))
-				spares++;
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
@@ -7100,11 +7096,18 @@ static int remove_and_add_spares(mddev_t *mddev)
 					if (sysfs_create_link(&mddev->kobj,
 							      &rdev->kobj, nm))
 						/* failure here is OK */;
-					spares++;
+						spares++;
 					md_new_event(mddev);
 					set_bit(MD_CHANGE_DEVS, &mddev->flags);
-				} else
-					break;
+				}
+			}
+			else if (rdev->raid_disk >= 0 &&
+			    !test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Blocked, &rdev->flags)) {
+				spares++;
+			}
+			else {
+				break;
 			}
 		}
 	}
