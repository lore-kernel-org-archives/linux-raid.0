From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/2] Migration of externally managed arrays need major
 version to be set.
Date: Thu, 21 Apr 2011 23:56:51 +0100
Message-ID: <66C59AD0932712458090B447266D638C012892FC27@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

without this, array.major/minor defaults to 0/9 and we lack of continuous
suspends.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9c63036..e3150ee 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1912,7 +1912,7 @@ started:
 
 	sra = sysfs_read(fd, 0,
 			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|GET_CHUNK|
-			 GET_CACHE);
+			 GET_CACHE|GET_VERSION);
 	if (!sra) {
 		fprintf(stderr, Name ": %s: Cannot get array details from sysfs\n",
 			devname);
-- 
1.7.3.4

