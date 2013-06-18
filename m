From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 2/6] Makefile: Allow the user to pass EXTRA_CFLAGS
Date: Tue, 18 Jun 2013 11:09:21 +0200
Message-ID: <20130618090921.1161109.54531.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Users might want to compile with optimization levels and
CXFLAGS as suggested in the Makefile comment does not work.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 8cb8d51..09e08fa 100644
--- a/Makefile
+++ b/Makefile
@@ -27,8 +27,8 @@
 #           Australia
 #
 
-# define "CXFLAGS" to give extra flags to CC.
-# e.g.  make CXFLAGS=-O to optimise
+# define "EXTRA_CFLAGS" to give extra flags to CC.
+# e.g.  make EXTRA_CFLAGS=-O to optimise
 TCC = tcc
 UCLIBC_GCC = $(shell for nm in i386-uclibc-linux-gcc i386-uclibc-gcc; do which $$nm > /dev/null && { echo $$nm ; exit; } ; done; echo false No uclibc found )
 #DIET_GCC = diet gcc
@@ -41,7 +41,7 @@ KLIBC=/home/src/klibc/klibc-0.77
 KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32
 
 CC = $(CROSS_COMPILE)gcc
-CXFLAGS = -ggdb
+CXFLAGS = -ggdb $(EXTRA_CFLAGS)
 CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
 ifdef WARN_UNUSED
 CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O

