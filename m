From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: not all disks are released in free_imsm_disks()
Date: Fri, 28 Jan 2011 14:37:51 +0100
Message-ID: <20110128133750.16213.62160.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Adding spare disks to imsm container fails due to problem with writing
new_dev to sysfs. This problem was caused by not closed handle
(opened exclusively) in Manage.c:803.

Disk handle was not closed by free_imsm().
This is due to not released disk_mgmt_list in free_imsm_disks().

Proper release of imsm metadata allows for spare adding without problems.
Memory leak was fixed also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 958a02b..8bb21dd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2687,6 +2687,11 @@ static void free_imsm_disks(struct intel_super *super)
 		super->disks = d->next;
 		__free_imsm_disk(d);
 	}
+	while (super->disk_mgmt_list) {
+		d = super->disk_mgmt_list;
+		super->disk_mgmt_list = d->next;
+		__free_imsm_disk(d);
+	}
 	while (super->missing) {
 		d = super->missing;
 		super->missing = d->next;

