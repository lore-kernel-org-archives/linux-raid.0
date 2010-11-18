From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 07/13] Grow: add missing raid4 geometries to geo_map()
Date: Thu, 18 Nov 2010 10:22:17 +0100
Message-ID: <20101118092217.29508.33761.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

They are equivalent to their raid5 versions and let the reshape code
optionally use either.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 restripe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/restripe.c b/restripe.c
index 3074693..c2fbe5b 100644
--- a/restripe.c
+++ b/restripe.c
@@ -46,6 +46,7 @@ static int geo_map(int block, unsigned long long stripe, int raid_disks,
 	switch(level*100 + layout) {
 	case 000:
 	case 400:
+	case 400 + ALGORITHM_PARITY_N:
 	case 500 + ALGORITHM_PARITY_N:
 		/* raid 4 isn't messed around by parity blocks */
 		if (block == -1)
@@ -75,6 +76,7 @@ static int geo_map(int block, unsigned long long stripe, int raid_disks,
 		if (block == -1) return pd;
 		return (pd + 1 + block) % raid_disks;
 
+	case 400 + ALGORITHM_PARITY_0:
 	case 500 + ALGORITHM_PARITY_0:
 		return block + 1;
 

