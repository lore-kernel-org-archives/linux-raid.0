From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 19/19] ARM: Add drivers/dma to arch/arm/Kconfig
Date: Tue, 26 Jun 2007 18:52:10 -0700
Message-ID: <20070627015210.18962.99133.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 50d9f3e..0cb2d4f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1034,6 +1034,8 @@ source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/dma/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
