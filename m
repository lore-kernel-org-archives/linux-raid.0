From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] init/do_mounts_md.c must #include <linux/delay.h>
Date: Thu, 16 Oct 2008 23:29:21 +0300
Message-ID: <20081016202921.GD22554@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Arjan van de Ven <arjan@linux.intel.com>
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch fixes the following compile error caused by
commit 589f800bb12c5cd6c9167bbf9bf3cb70cd8e422c
(fastboot: make the raid autodetect code wait for all devices to init):

<--  snip  -->

...
  CC      init/do_mounts_md.o
init/do_mounts_md.c: In function 'autodetect_raid':
init/do_mounts_md.c:285: error: implicit declaration of function 'msleep'
make[2]: *** [init/do_mounts_md.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 48b3fad..4c87ee1 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,5 +1,6 @@
 
 #include <linux/raid/md.h>
+#include <linux/delay.h>
 
 #include "do_mounts.h"
 

