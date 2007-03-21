From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: BLK_DEV_MD with CONFIG_NET
Date: Tue, 20 Mar 2007 20:05:38 -0700
Message-ID: <20070320200538.5270d636.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


drivers/md/md.c calls csum_partial().

IF CONFIG_NET=n and BLK_DEV_MD=y, if arch/*/lib/Makefile
puts csum-partial.o or checksum.o into lib-y, the function
is present.  (Of course, if the function is placed in
obj-y, there is no problem.)

If CONFIG_NET=n and BLK_DEV_MD=n, if arch/*/lib/Makefile
puts csum-partial.o or checksum.o into lib-y, the function
is removed from the kernel image due to having no built-in
callers.

Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
Unless csum_partial() is built and kept by some arch Makefile,
the result is:
ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


Any suggested solutions?


Recorded for posterity here:
  http://bugzilla.kernel.org/show_bug.cgi?id=8242

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
