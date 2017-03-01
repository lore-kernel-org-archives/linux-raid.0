From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 1/2] Add Wimplicit-fallthrough=0 in Makefile
Date: Wed,  1 Mar 2017 14:12:45 +0800
Message-ID: <1488348766-31087-2-git-send-email-xni@redhat.com>
References: <1488348766-31087-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488348766-31087-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, ncroxon@redhat.com
List-Id: linux-raid.ids

There are many errors like 'error: this statement may fall through'. 
But the logic is right. So add the flag Wimplicit-fallthrough=0 
to disable the error messages. The method I use is from 
https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
#index-Wimplicit-fallthrough-375
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index a6f464c..b9f52e0 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,7 @@ KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIB
 
 CC ?= $(CROSS_COMPILE)gcc
 CXFLAGS ?= -ggdb
-CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
+CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wimplicit-fallthrough=0
 ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O3
 endif
-- 
2.7.4

