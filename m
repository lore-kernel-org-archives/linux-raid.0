From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 13/14] FIX: Size change is possible as standalone change only
Date: Fri, 13 Apr 2012 16:52:07 +0200
Message-ID: <1334328728-12544-14-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-10-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-11-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-12-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-13-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-13-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Size change is possible as standalone change only. To make sure size change
is not requested pass '-1' as size parameter.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1b45199..389992e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1973,7 +1973,7 @@ size_change_error:
 		/* Impose these changes on a single array.  First
 		 * check that the metadata is OK with the change. */
 
-		if (reshape_super(st, info.component_size, info.new_level,
+		if (reshape_super(st, -1, info.new_level,
 				  info.new_layout, info.new_chunk,
 				  info.array.raid_disks, info.delta_disks,
 				  backup_file, devname, APPLY_METADATA_CHANGES,
-- 
1.6.4.2

