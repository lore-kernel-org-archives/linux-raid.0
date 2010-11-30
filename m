From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] fix: assemble for external metadata generates segfault if
 invalid device found
Date: Tue, 30 Nov 2010 23:49:52 +0000
Message-ID: <66C59AD0932712458090B447266D638C0109FA94F2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

An attempt to invoke super_by_fd() on device that has
metadata_version="none" always matches super0 (as test_version is "").
In Assemble() it results in segfault when load_container is invoked
(=null for super0).
As of now load_container is only started if it points to valid pointer.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Assemble.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 5e71a43..5e4296c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -332,7 +332,7 @@ int Assemble(struct supertype *st, char *mddev,
 					fprintf(stderr, Name ": not a recognisable container: %s\n",
 						devname);
 				tmpdev->used = 2;
-			} else if (tst->ss->load_container(tst, dfd, NULL)) {
+			} else if (!tst->ss->load_container || tst->ss->load_container(tst, dfd, NULL)) {
 				if (report_missmatch)
 					fprintf(stderr, Name ": no correct container type: %s\n",
 						devname);
-- 
1.7.1

