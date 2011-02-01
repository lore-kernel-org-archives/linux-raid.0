From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: size have to be calculated based on first map
Date: Tue, 01 Feb 2011 15:24:54 +0100
Message-ID: <20110201142454.16252.58382.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Before reshape finalization migration is still present in metadata.
After patch 'imsm: FIX: crash during getting map'
function get_imsm_map() returns correct value,
this means in our case from second (start) map.

We should calculate map size basing on first (final) map.
For this we should request it by setting second function parameter to '0'

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c70d44b..4565d80 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5188,7 +5188,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				int used_disks;
 				struct mdinfo *mdi;
 
-				used_disks = imsm_num_data_members(dev, -1);
+				used_disks = imsm_num_data_members(dev, 0);
 				if (used_disks > 0) {
 					array_blocks =
 						map->blocks_per_member *

