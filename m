From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] FIX: resolve make everything compilation error
Date: Mon, 16 Apr 2012 16:12:55 +0200
Message-ID: <20120416141254.23627.54905.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When mdadm is compiled using e.g. 'everything' option, mdassemble
compilation is broken.

Change code to enable mdassemble compilation.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ed7792d..3bfeda6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -910,6 +910,7 @@ static unsigned long long blocks_per_member(struct imsm_map *map)
 	return join_u32(map->blocks_per_member_lo, map->blocks_per_member_hi);
 }
 
+#ifndef MDASSEMBLE
 static unsigned long long num_data_stripes(struct imsm_map *map)
 {
 	if (map == NULL)
@@ -921,6 +922,7 @@ static void set_total_blocks(struct imsm_disk *disk, unsigned long long n)
 {
 	split_ull(n, &disk->total_blocks_lo, &disk->total_blocks_hi);
 }
+#endif
 
 static void set_pba_of_lba0(struct imsm_map *map, unsigned long long n)
 {

