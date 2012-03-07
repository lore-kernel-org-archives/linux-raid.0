From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] Reset bad flag on map update
Date: Wed, 7 Mar 2012 12:51:30 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B915714B17@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

Map file may miss an entry if bad flag is not cleared on update.

This happens for example when an old entry exists in map that
has no mdstat counterpart and we create a new array with the same devnum.
Newly created array will not appear in map if update doesnt clear bad flag.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 mapfile.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mapfile.c b/mapfile.c
index 0bfecd0..9e2c893 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -246,6 +246,7 @@ int map_update(struct map_ent **mpp, int devnum, char *metadata,
 			memcpy(mp->uuid, uuid, 16);
 			free(mp->path);
 			mp->path = path ? strdup(path) : NULL;
+			mp->bad = 0;
 			break;
 		}
 	if (!mp)
-- 
1.7.1

