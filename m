From: Goetz Bock <bock@blacknet.de>
Subject: mdadm 1.0.1 on uClibc 0.9.15
Date: Mon, 9 Sep 2002 16:45:23 +0200
Sender: uclibc-admin@uclibc.org
Message-ID: <20020909164523.A28586@zealot.blacknet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <uclibc-admin@uclibc.org>
Content-Disposition: inline
Errors-To: uclibc-admin@uclibc.org
List-Help: <mailto:uclibc-request@uclibc.org?subject=help>
List-Post: <mailto:uclibc@uclibc.org>
List-Subscribe: <http://codepoet.org/mailman/listinfo/uclibc>,
	<mailto:uclibc-request@uclibc.org?subject=subscribe>
List-Unsubscribe: <http://codepoet.org/mailman/listinfo/uclibc>,
	<mailto:uclibc-request@uclibc.org?subject=unsubscribe>
List-Archive: <http://codepoet.org/lists/uclibc/>
To: uclibc <uclibc@uclibc.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi all,

sorry for crosspositng this to the uClibc and the linux-raid mailing
list, but I don't know whom to ask (first). OTOH I'm subscribed to both
lists, so there is no need for massive crossposting and once a
colclusion is reached I'll post a summary (unless told otherwise).

I've sucessfully uses uClibc on i386 and arm for quite some time (mostly
with busybox), and I'm using mdadm on multiple x86 boxes with glibc. For
my install and rescue sustem, I'd like to compile mdadm it with uClibc
(busybox, lvm-utils, e2fs-tools, fdisk work flawless), but building
mdadm 1.0.1 with uClibc results in:

...
util.c:379:17: ftw.h: No such file or directory
cc1: warnings being treated as errors
util.c:382: warning: `struct FTW' declared inside parameter list
util.c:382: warning: its scope is only this definition or declaration,
which is probably not what you want
util.c: In function `map_dev':
util.c:402: warning: implicit declaration of function `nftw'
util.c:402: `FTW_PHYS' undeclared (first use in this function)
util.c:402: (Each undeclared identifier is reported only once
util.c:402: for each function it appears in.)
make: *** [util.o] Error 1

(n)ftw is apparently used to scan the devices in /dev for useable
devices.

My knowledge of C is somewhat limited and I don't know wether adding ftw
to uClib or making it a patch to mdadm (or perhapes removing the need
for ftw from mdadm) ...
you got it, I'm stuck and appriciate any pointers.

Thanks,
    Goetz.


BTW: you can get mdadm from 
       http://www.cse.unsw.edu.au/~neilb/source/mdadm/
     and uclibc from
       http://www.uclibc.org/
