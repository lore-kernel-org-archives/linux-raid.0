From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/21] imsm: FIX: Cannot create volume
Date: Wed, 08 Jun 2011 18:09:41 +0200
Message-ID: <20110608160941.24327.74788.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Clearing info structure causes mdadm is not able to create workable volume.

During volume creation info structure passed to getinfo() function
contains some information already and cannot be cleared.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b8d8b4e..471dbd2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2075,7 +2075,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	unsigned int component_size_alligment;
 	int map_disks = info->array.raid_disks;
 
-	memset(info, 0, sizeof(*info));
 	if (prev_map)
 		map_to_analyse = prev_map;
 

