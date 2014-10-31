From: Or Sagi <ors@reduxio.com>
Subject: [PATCH] mdadm: fix --detail for cases where device count >  max_devices/2
Date: Fri, 31 Oct 2014 11:10:33 +0200
Message-ID: <CCCA52F1-B747-4762-8D07-12B543996470@reduxio.com>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm misreports (less devices then there are, and as a result decides the array is degraded) in cases where there are > max_devices/2 devices.

This seems to fix it.

---
Detail.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Detail.c b/Detail.c
index c4fcad9..62e5867 100644
--- a/Detail.c
+++ b/Detail.c
@@ -72,7 +72,7 @@ int Detail(char *dev, struct context *c)
	int failed = 0;
	struct supertype *st;
	char *subarray = NULL;
-	int max_disks = MD_SB_DISKS; /* just a default */
+	int max_disks = MD_SB_DISKS * 2; /* just a default */
	struct mdinfo *info = NULL;
	struct mdinfo *sra;
	struct mdinfo *subdev;
@@ -124,7 +124,7 @@ int Detail(char *dev, struct context *c)
	rv = 0;

	if (st)
-		max_disks = st->max_devs;
+		max_disks = st->max_devs * 2;

	if (subarray) {
		/* This is a subarray of some container.
-- 
1.7.9.5


--

Or Sagi | Chief System Architect
Reduxio Systems