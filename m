From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 4/5] fs/autofs4: Fix a dead URL to ftp.kernel.org
Date: Mon, 27 Mar 2017 14:47:30 +0900
Message-ID: <20170327054731.31882-5-sj38.park@gmail.com>
References: <20170327054731.31882-1-sj38.park@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170327054731.31882-1-sj38.park@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rml@tech9.net, axboe@fb.com, shli@kernel.org, raven@themaw.net, yamada.masahito@socionext.com, mmarek@suse.com
Cc: linux-raid@vger.kernel.org, autofs@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
List-Id: linux-raid.ids

As ftp.kernel.org is closed [0], this commit fixes a dead URL to
ftp.kernel.org in fs/autofs4/ to use www.kernel.org instead.

[0] https://www.kernel.org/shutting-down-ftp-services.html

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 fs/autofs4/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d6384d39..44727bf18297 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -7,7 +7,7 @@ config AUTOFS4_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
+	  <https://www.kernel.org/pub/linux/daemons/autofs/v4/>; you also
 	  want to answer Y to "NFS file system support", below.
 
 	  To compile this support as a module, choose M here: the module will be
-- 
2.10.0

