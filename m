From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 3/5] drivers/md: Fix a dead URL to ftp.kernel.org
Date: Mon, 27 Mar 2017 14:47:29 +0900
Message-ID: <20170327054731.31882-4-sj38.park@gmail.com>
References: <20170327054731.31882-1-sj38.park@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170327054731.31882-1-sj38.park@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rml@tech9.net, axboe@fb.com, shli@kernel.org, raven@themaw.net, yamada.masahito@socionext.com, mmarek@suse.com
Cc: linux-raid@vger.kernel.org, autofs@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
List-Id: linux-raid.ids

As ftp.kernel.org is closed [0], this commit fixes a dead URL to
ftp.kernel.org in drivers/md/ to use www.kernel.org instead.

[0] https://www.kernel.org/shutting-down-ftp-services.html

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/md/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5c5ed97c9fda..6a41633460ba 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -115,7 +115,7 @@ config MD_RAID10
 
 	  RAID-10 requires mdadm-1.7.0 or later, available at:
 
-	  ftp://ftp.kernel.org/pub/linux/utils/raid/mdadm/
+	  https://www.kernel.org/pub/linux/utils/raid/mdadm/
 
 	  If unsure, say Y.
 
-- 
2.10.0

