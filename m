From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/13] imsm: FIX: update disks status in container_contents()
Date: Mon, 10 Jan 2011 12:28:15 +0100
Message-ID: <20110110112815.10776.44824.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Based on status information disks are added to array during grow (in reshape_array()).
This information currently is not present and all disks (old and new) were added to md.
To avoid adding already present disks, disk.state has to be set.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9687993..2700401 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4541,6 +4541,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev;
 		struct imsm_map *map;
+		struct imsm_map *map2;
 		struct mdinfo *this;
 		int slot;
 		char *ep;
@@ -4551,6 +4552,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 
 		dev = get_imsm_dev(super, i);
 		map = get_imsm_map(dev, 0);
+		map2 = get_imsm_map(dev, 1);
 
 		/* do not publish arrays that are in the middle of an
 		 * unsupported migration
@@ -4632,7 +4634,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			info_d->disk.minor = d->minor;
 			info_d->disk.raid_disk = slot;
 			info_d->recovery_start = recovery_start;
-
+			if (map2 && (map2->num_members > slot))
+				info_d->disk.state = (1 << MD_DISK_ACTIVE);
 			if (info_d->recovery_start == MaxSector)
 				this->array.working_disks++;
 

