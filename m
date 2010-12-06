From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] fix: incremental on invalid container causes segfault
Date: Mon, 6 Dec 2010 06:40:40 +0000
Message-ID: <66C59AD0932712458090B447266D638C010A080454@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

counterpart of 417f346ee0 for incremental.
If md device has metadata_version="none" super_by_fd() matches supertype=super0. 
Call of load_container() dereferences null, so we have to forbid it.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Incremental.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 8cae1ee..9399f5b 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -134,7 +134,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	if (must_be_container(dfd)) {
 		if (!st)
 			st = super_by_fd(dfd, NULL);
-		if (st)
+		if (st && st->ss->load_container)
 			rv = st->ss->load_container(st, dfd, NULL);
 
 		close(dfd);
-- 
1.7.1

