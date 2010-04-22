From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 01/13] fix: memory leak in mdmon_pid()
Date: Thu, 22 Apr 2010 23:10:32 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3B2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

devnum2devname() returns pointer to memory allocated with strdup.
It must be released to prevent memory leak.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 util.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index d292a66..423b66f 100644
--- a/util.c
+++ b/util.c
@@ -1502,7 +1502,11 @@ int mdmon_pid(int devnum)
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
+	char *devname = devnum2devname(devnum);
+
+	sprintf(path, "%s/%s.pid", pid_dir, devname);
+	free(devname);
+
 	fd = open(path, O_RDONLY | O_NOATIME, 0);
 
 	if (fd < 0)
-- 
1.6.4.2

--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


