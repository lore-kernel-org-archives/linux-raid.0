From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: Software RAID Stopped Working With Aurora Kernel
Date: Mon, 20 May 2002 13:25:10 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAEEMHCPAA.kc130iseo@coastalnet.com>
References: <15592.56683.75251.569129@notabene.cse.unsw.edu.au>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15592.56683.75251.569129@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you for the excellent information and suggestions. I would like to try
using mdadm, but had some trouble compiling it. Also, please see notes on
raid5 modules below.

> -----Original Message-----
> From: Neil Brown [mailto:neilb@notabene]On Behalf Of Neil Brown
> Sent: Monday, May 20, 2002 5:27 AM
> To: cwebster@ec.rr.com
> Cc: linux-raid
> Subject: Re: Software RAID Stopped Working With Aurora Kernel
>
>
> On Sunday May 19, cwebster@ec.rr.com wrote:
> > Looking for help from list members in resolving software RAID problems.
>
> Here is the help:
>
> 1/  You seem to have two copies of raid5.o which seems to be confusing
>     modprobe.
>     I don't know why, but in one instance it tried to load
>       /lib/raid5.o
>     and gets :unresolved symbol md_unregister_thread_R4ba824f9
>
>     The other time it correctly loads
>       /lib/modules/2.4.18-0.92sparc/kernel/drivers/md/raid5.o
>
>     I suggest removing /lib/raid5.c

Strangely, the only time this error occurred was when I tried to boot with
"md0" devices listed in /etc/fstab. I don't know why it reported this path.
There are no modules directly under /lib. Here's where all the modules are.
I will remove all but the current kernel modules. In fact, I'll be removing
all the 2.2 kernels since I can't boot them any more anyway.

[root@winggear redhat]# find /lib -name raid5.o
/lib/modules/2.2.14-5.0/block/raid5.o
/lib/modules/2.2.19-6.2.1/block/raid5.o
/lib/modules/2.2.19-6.2.12/block/raid5.o
/lib/modules/2.2.19-6.2.16/block/raid5.o
/lib/modules/2.4.18-0.91sparc/kernel/drivers/md/raid5.o
/lib/modules/2.4.18-0.92sparc/kernel/drivers/md/raid5.o

>    Alternately, if you are feeling adventurous, you could download
>    and compile mdadm 1.0.1 from
>      http://www.cse.unsw.edu.au/~neilb/source/mdadm/
>

Using your source RPM:

[root@winggear redhat]# rpm -bc --target sparc-redhat-linux SPECS/mdadm.spec
Building target platforms: sparc-redhat-linux
Building for target sparc-redhat-linux
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.90707
+ umask 022
+ cd /usr/src/redhat/BUILD
+ cd /usr/src/redhat/BUILD
+ rm -rf mdadm-1.0.1
+ /bin/gzip -dc /usr/src/redhat/SOURCES/mdadm-1.0.1.tgz
+ tar -xf -

gzip: /usr/src/redhat/SOURCES/mdadm-1.0.1.tgz: decompression OK, trailing
garbag
e ignored
+ STATUS=0
+ '[' 0 -ne 0 ']'
+ cd mdadm-1.0.1
++ /usr/bin/id -u
+ '[' 0 = 0 ']'
+ /bin/chown -Rhf root .
++ /usr/bin/id -u
+ '[' 0 = 0 ']'
+ /bin/chgrp -Rhf root .
+ /bin/chmod -Rf a+rX,g-w,o-w .
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.90717
+ umask 022
+ cd /usr/src/redhat/BUILD
+ cd mdadm-1.0.1
+ make 'CXFLAGS=-O2 -m32 -mtune=ultrasparc' SYSCONFDIR=/etc
gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -O2 -m3
2 -m
tune=ultrasparc   -c -o mdadm.o mdadm.c
cc1: warnings being treated as errors
In file included from mdadm.h:57,
                 from mdadm.c:30:
md_p.h: In function `md_event':
md_p.h:168: warning: left shift count >= width of type
make: *** [mdadm.o] Error 1
error: Bad exit status from /var/tmp/rpm-tmp.90717 (%build)


RPM build errors:
    Bad exit status from /var/tmp/rpm-tmp.90717 (%build)

============= Compilers and Libraries ================

gcc-2.96-101
gcc-sparc32-2.96-101gcc-c++-2.96-101
gcc-g77-2.96-101
gcc3-g77-3.0.1-3
gcc-c++-sparc32-2.96-101
gcc3-3.0.1-3
libgcc-3.0.1-3
gcc3-c++-3.0.1-3
gcc-objc-2.96-101
gcc-chill-2.96-101
glib-1.2.10-5
glibc-2.2.4-19
glib-devel-1.2.10-5
compat-glibc-6.2-2.1.3.2
glibc-profile-2.2.4-19
glib10-1.0.6-10
glibc-devel-2.2.4-19
glibc-common-2.2.4-19

