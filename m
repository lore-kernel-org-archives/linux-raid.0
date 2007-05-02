From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/16] ARM: Add drivers/dma to arch/arm/Kconfig
Date: Tue, 01 May 2007 23:16:10 -0700
Message-ID: <20070502061610.7066.25982.stgit@dwillia2-linux.ch.intel.com>
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2992788AbXEBGQ3@vger.kernel.org>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e7baca2..74077e3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -997,6 +997,8 @@ source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/dma/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
