From: "majianpeng" <majianpeng@gmail.com>
Subject: Compiler mdadm-3.2.5 error
Date: Mon, 21 May 2012 09:51:19 +0800
Message-ID: <201205210951075780388@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi neil:
	I git-pull mdadm and compiled but met error like this:

In file included from super0.c:27:
sha1.h:29:22: error: ansidecl.h: No such file or directory
make: *** [super0.o] Error 1
 				
uname -a
Linux nfs-server.example.com 2.6.18-194.el5 #1 SMP Fri Apr 2 14:58:14 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux

gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-libgcj-multifile --enable-languages=c,c++,objc,obj-c++,java,fortran,ada --enable-java-awt=gtk --disable-dssi --enable-plugin --with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre --with-cpu=generic --host=x86_64-redhat-linux
Thread model: posix
gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)


I remove the ansidecl.h in shal.h.Then compile success.
In shal.h:
#include "ansidecl.h"
So the ansidecl.h may in mdadm, not a system head-file.
But I rewrite it:
 #include <ansidecl.h>
But compiled error too.


--------------
majianpeng
2012-05-21

