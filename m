From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] imsm: fix: thunderdome may drop 2tb attribute
Date: Mon, 2 Apr 2012 20:59:03 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A212E6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

Spare superblock doesn't depend on other spares in container.
When loading container metadata thunderdome
may pick a small disk for the champion. This will result in incorrect
interpretation of sizes of other disks in container when joint superblock
is returned. If any disk in container has the 2TB attribute set, the result
must have it set too.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ed13542..869a39c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4079,6 +4079,8 @@ imsm_thunderdome(struct intel_super **super_list, int len)
 		if (s == champion)
 			continue;
 
+		mpb->attributes |= s->anchor->attributes & MPB_ATTRIB_2TB_DISK;
+
 		for (i = 0; i < mpb->num_disks; i++) {
 			struct imsm_disk *disk;
 
-- 
1.6.4.2

