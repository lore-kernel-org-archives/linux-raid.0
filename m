From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] imsm: FIX: Add spare disks information to array
	description
Date: Thu, 10 Feb 2011 14:56:34 +0100
Message-ID: <20110210135634.9276.67316.stgit@gklab-128-013.igk.intel.com>
References: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Spares that are specified on container can be used by any array in container.
this means that for every array in container they should be reported.
This let caller know how many spare devices (not used in any array)
are still available.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fed831d..e06a6f4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4731,11 +4731,19 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	struct mdinfo *rest = NULL;
 	unsigned int i;
 	int bbm_errors = 0;
+	struct dl *d;
+	int spare_disks = 0;
 
 	/* check for bad blocks */
 	if (imsm_bbm_log_size(super->anchor))
 		bbm_errors = 1;
 
+	/* count spare devices, not used in maps
+	 */
+	for (d = super->disks; d; d = d->next)
+		if (d->index == -1)
+			spare_disks++;
+
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev;
 		struct imsm_map *map;
@@ -4852,6 +4860,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		}
 		/* now that the disk list is up-to-date fixup recovery_start */
 		update_recovery_start(dev, this);
+		this->array.spare_disks += spare_disks;
 		rest = this;
 	}
 

