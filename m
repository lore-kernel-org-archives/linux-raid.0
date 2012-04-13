From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/14] imsm: Add function imsm_get_free_size()
Date: Fri, 13 Apr 2012 16:52:04 +0200
Message-ID: <1334328728-12544-11-git-send-email-adam.kwolek@intel.com>
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
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-10-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Add function imsm_imsm_get_free_size() using part of code from function
reserve_space().

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2a050fc..7161fc5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6110,7 +6110,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	return 1;
 }
 
-static int reserve_space(struct supertype *st, int raiddisks,
+static int imsm_get_free_size(struct supertype *st, int raiddisks,
 			 unsigned long long size, int chunk,
 			 unsigned long long *freesize)
 {
@@ -6188,9 +6188,32 @@ static int reserve_space(struct supertype *st, int raiddisks,
 
 	*freesize = size;
 
+	dprintf("imsm: imsm_get_free_size() returns : %llu\n", size);
+
 	return 1;
 }
 
+static int reserve_space(struct supertype *st, int raiddisks,
+			 unsigned long long size, int chunk,
+			 unsigned long long *freesize)
+{
+	struct intel_super *super = st->sb;
+	struct dl *dl;
+	int cnt;
+	int rv = 0;
+
+	rv = imsm_get_free_size(st, raiddisks, size, chunk, freesize);
+	if (rv) {
+		cnt = 0;
+		for (dl = super->disks; dl; dl = dl->next)
+			if (dl->e)
+				dl->raiddisk = cnt++;
+		rv = 1;
+	}
+
+	return rv;
+}
+
 static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 				  int raiddisks, int *chunk, unsigned long long size,
 				  char *dev, unsigned long long *freesize,
-- 
1.6.4.2

