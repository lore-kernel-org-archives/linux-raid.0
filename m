From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] sha1.h: remove ansidecl.h header inclusion
Date: Mon, 13 Aug 2012 14:20:43 +0200
Message-ID: <20120813122043.25583.21352.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

Inclusion of the 'ansidecl.h' header requires the 'binutils-devel'
package to be installed but is not needed.

Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 sha1.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sha1.h b/sha1.h
index 5473f91..a601d96 100644
--- a/sha1.h
+++ b/sha1.h
@@ -26,8 +26,6 @@
 # include <limits.h>
 #endif
 
-#include "ansidecl.h"
-
 /* The following contortions are an attempt to use the C preprocessor
    to determine an unsigned integral type that is 32 bits wide.  An
    alternative approach is to use autoconf's AC_CHECK_SIZEOF macro, but

