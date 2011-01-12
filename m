From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/8] imsm: FIX: spares are not counted
Date: Wed, 12 Jan 2011 14:55:10 +0100
Message-ID: <20110112135510.15045.78096.stgit@gklab-128-013.igk.intel.com>
References: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Field info->array.spare_disks is used on begin of reshape_array() to check
if there is enough number of spares to process reshape.
During container_content_imsm() call spare disks are not counted.
This causes that reshape_array() reports that there is not enough spares
to execute reshape.

Patch adds spares counting for reshape process.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c3ff365..0c70fda 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4632,9 +4632,13 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			if (map2) {
 				if (slot < map2->num_members)
 					info_d->disk.state = (1 << MD_DISK_ACTIVE);
+				else
+					this->array.spare_disks++;
 			} else {
 				if (slot < map->num_members)
 					info_d->disk.state = (1 << MD_DISK_ACTIVE);
+				else
+					this->array.spare_disks++;
 			}
 			if (info_d->recovery_start == MaxSector)
 				this->array.working_disks++;

