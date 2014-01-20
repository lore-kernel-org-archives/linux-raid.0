From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: [PATCH] Allow to check mdadm with clangs static checker (scan-build)
Date: Mon, 20 Jan 2014 17:14:12 +0100
Message-ID: <52DD4B54.4060809@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Clangs scan-build tool (static checker) set the environmental variable CC,
so Makefile should allow to use that value.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 043bcea..63cc3ac 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,7 @@ KLIBC=/home/src/klibc/klibc-0.77
 
 KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32
 
-CC = $(CROSS_COMPILE)gcc
+CC ?= $(CROSS_COMPILE)gcc
 CXFLAGS ?= -ggdb
 CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
 ifdef WARN_UNUSED
