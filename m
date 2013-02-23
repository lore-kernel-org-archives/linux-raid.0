From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Date: Fri, 22 Feb 2013 23:40:01 -0800
Message-ID: <20130223074001.GA5199@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Alasdair G Kergon <agk@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-raid.ids

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 7cdf359..0cc3a3d 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -158,7 +158,6 @@ config MULTICORE_RAID456
 	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
 	depends on MD_RAID456
 	depends on SMP
-	depends on EXPERIMENTAL
 	---help---
 	  Enable the raid456 module to dispatch per-stripe raid operations to a
 	  thread pool.
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
