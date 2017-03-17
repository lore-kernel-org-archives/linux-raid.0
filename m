From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 2/3] mdadm: Add Wimplicit-fallthrough=0 in Makefile
Date: Fri, 17 Mar 2017 19:55:42 +0800
Message-ID: <1489751743-11397-3-git-send-email-xni@redhat.com>
References: <1489751743-11397-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489751743-11397-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, ncroxon@redhat.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

There are many errors like 'error: this statement may fall through'.
But the logic is right. So add the flag Wimplicit-fallthrough=0
to disable the error messages. The method I use is from
https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
#index-Wimplicit-fallthrough-375

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Makefile b/Makefile
index a6f464c..d1a6ac4 100644
--- a/Makefile
+++ b/Makefile
@@ -48,6 +48,11 @@ ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O3
 endif
 
+FALLTHROUGH := $(shell gcc -v --help 2>&1 | grep "implicit-fallthrough" | wc -l)
+ifneq "$(FALLTHROUGH)"  "0"
+CWFLAGS += -Wimplicit-fallthrough=0
+endif
+
 ifdef DEBIAN
 CPPFLAGS += -DDEBIAN
 endif
-- 
2.7.4

