From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 06/22] FIX: Initialize reshape structure
Date: Thu, 02 Jun 2011 16:49:00 +0200
Message-ID: <20110602144900.27355.65493.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

It can occurs that reshape structure can contain random values.
Due to this fact analyse_change() can disallow for grow start
without real cause (e.g. check of uninitialized new_chunk).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7a8ffdb..11b2214 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1745,6 +1745,7 @@ static int reshape_array(char *container, int fd, char *devname,
 		info->component_size = array_size / array.raid_disks;
 	}
 
+	memset(&reshape, 0, sizeof(reshape));
 	if (info->reshape_active) {
 		int new_level = info->new_level;
 		info->new_level = UnSet;

