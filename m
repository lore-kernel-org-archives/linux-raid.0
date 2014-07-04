From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: [PATCH] Grow: Do not use grow-continue unit file if reshape is
 starting
Date: Fri, 4 Jul 2014 08:59:00 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F19CC0430@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Mdadm should use mdadm-grow-continue unit file only if
reshape is going to be continued. Otherwise, array specific
reshape with IMSM metadata will fail to start, due to
missing information about ongoing migration -
grow-continue will try to start again the reshape process.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index a2f4f14..0cd9442 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3272,7 +3272,7 @@ started:
 		return 1;
 	}
 
-	if (!forked && !check_env("MDADM_NO_SYSTEMCTL"))
+	if (restart && !forked && !check_env("MDADM_NO_SYSTEMCTL"))
 		if (continue_via_systemd(container ?: sra->sys_name)) {
 			free(fdlist);
 			free(offsets);
-- 
1.9.3

