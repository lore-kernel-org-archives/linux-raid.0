From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/14] imsm: FIX: Update function imsm_num_data_members() for Raid1/10
Date: Fri, 13 Apr 2012 16:51:55 +0200
Message-ID: <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Function imsm_num_data_members() returns wrong value for raid 1 and 10.
It returns all data member but it should return number of unique data
members (excluding mirror devices)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b087b32..3aabcc0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2032,9 +2032,11 @@ static __u8 imsm_num_data_members(struct imsm_dev *dev, int second_map)
 
 	switch (get_imsm_raid_level(map)) {
 	case 0:
+		return map->num_members;
+		break;
 	case 1:
 	case 10:
-		return map->num_members;
+		return map->num_members/2;
 	case 5:
 		return map->num_members - 1;
 	default:
-- 
1.6.4.2

