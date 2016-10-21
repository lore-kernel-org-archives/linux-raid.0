From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Lib.c: Fix geting devname for devices with long path
Date: Fri, 21 Oct 2016 11:37:51 +0200
Message-ID: <1477042671-12934-4-git-send-email-pawel.baldysiak@intel.com>
References: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

In scenario where VMD is enabled, and "x8" type of NVMe drive is
plugged into PCIe switch - the path will be longer than 200 chars
(additional VMD domain + 2 level of PCIe switches).
This patch makes the buffer big enough to handle this kind of
configurations.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib.c b/lib.c
index 057ee52..b640634 100644
--- a/lib.c
+++ b/lib.c
@@ -64,7 +64,7 @@ int get_mdp_major(void)
 char *devid2kname(int devid)
 {
 	char path[30];
-	char link[200];
+	char link[PATH_MAX];
 	static char devnm[32];
 	char *cp;
 	int n;
-- 
2.7.4

