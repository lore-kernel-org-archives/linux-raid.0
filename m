From: "Calvin D. Webster" <cwebster@ec.rr.com>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Mon, 20 May 2002 17:33:03 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CE96B8F.2BD45CC3@ec.rr.com>
References: <15592.56683.75251.569129@notabene.cse.unsw.edu.au>
		<NDBBIAKEEKGGEIKCBKNAEEMHCPAA.kc130iseo@coastalnet.com> <15593.26098.199785.56464@notabene.cse.unsw.edu.au>
Reply-To: cwebster@ec.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> On Monday May 20, kc130iseo@coastalnet.com wrote:
> > >     I don't know why, but in one instance it tried to load
> > >       /lib/raid5.o
> > >     and gets :unresolved symbol md_unregister_thread_R4ba824f9
> > >
> > >     The other time it correctly loads
> > >       /lib/modules/2.4.18-0.92sparc/kernel/drivers/md/raid5.o
> > >
> > >     I suggest removing /lib/raid5.c
> >
> > Strangely, the only time this error occurred was when I tried to boot with
> > "md0" devices listed in /etc/fstab. I don't know why it reported this path.
> > There are no modules directly under /lib. Here's where all the modules are.
> > I will remove all but the current kernel modules. In fact, I'll be removing
> > all the 2.2 kernels since I can't boot them any more anyway.
> 
> Odd.... you could do an "nm" of each raid5.o and see which one
> mentions
>    md_unregister_thread_R4ba824f9

Both of the 2.4 raid5.o modules show this. None of the 2.2 modules do.

> > Using your source RPM:
> ...
> > gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -O2 -m3
> > 2 -m
> > tune=ultrasparc   -c -o mdadm.o mdadm.c
> > cc1: warnings being treated as errors
> > In file included from mdadm.h:57,
> >                  from mdadm.c:30:
> > md_p.h: In function `md_event':
> > md_p.h:168: warning: left shift count >= width of type
> > make: *** [mdadm.o] Error 1
> > error: Bad exit status from /var/tmp/rpm-tmp.90717 (%build)
> 
> Even odder.  It seems to think that __u64 is only 32bits wide.
> Sounds like a compiler error, or an include file error.
> I suspect __u64 is defined in /usr/include/asm/types.h to be
>   typedef unsigned long __u64;
> 

This is probably my fault. I've had to rearrange the "asm" links in the
include directories to get some packages to build while upgrading to
Aurora. The RHL 6.2 "include/asm*" links and directories were different.
I think I lost track of which were supposed to be where in the 2.4
kernel.

Tom "Spot" Callaway was good enough to build mdadm for me on his machine
and upload it to the Aurora site. So, I've got a good package to use
until this gets fixed.

Here's what I've got now. What do they need to look like? I know, its a
mess.

[root@winggear rpms]# ls -l /usr/include/ | grep asm
lrwxrwxrwx    1 root     root           34 May 20 14:09 asm ->
/usr/src/linux/include/asm-sparc64
lrwxrwxrwx    1 root     root           34 May 11 16:54 asm-generic ->
/usr/src/linux/include/asm-generic
drwxr-xr-x    2 root     root         4096 May 20 14:09 asm.sav
lrwxrwxrwx    1 root     root           32 May 11 16:56 asm-sparc ->
/usr/src/linux/include/asm-sparc
lrwxrwxrwx    1 root     root           34 May 11 16:56 asm-sparc64 ->
/usr/src/linux/include/asm-sparc64

[root@winggear rpms]# ls -l /usr/include/asm.sav/
total 0
lrwxrwxrwx    1 root     root           34 May 11 17:01 asm-generic ->
/usr/src/linux/include/asm-generic
lrwxrwxrwx    1 root     root           32 Apr  5 17:38 asm-sparc ->
/usr/src/linux/include/asm-sparc
lrwxrwxrwx    1 root     root           34 Apr  5 17:39 asm-sparc64 ->
/usr/src/linux/include/asm-sparc64

[root@winggear rpms]# ls -l /usr/src/ | grep linux
lrwxrwxrwx    1 root     root           22 May 11 14:36 linux ->
linux-2.4.18-0.92sparc
drwxr-xr-x    5 root     root         4096 May  6 02:47 linux-2.2.19
lrwxrwxrwx    1 root     root           22 May  7 18:41 linux-2.4 ->
linux-2.4.18-0.92sparc
drwxr-xr-x   15 root     root         4096 May 15 12:57
linux-2.4.18-0.92sparc

[root@winggear rpms]# ls -l /usr/src/linux-2.4.18-0.92sparc/include/ |
grep asm
lrwxrwxrwx    1 root     root           11 May 15 12:25 asm ->
asm-sparc64
drwxr-xr-x    2 root     root         4096 May  7 18:41 asm-generic
drwxr-xr-x    2 root     root         4096 May  7 18:41 asm-sparc
drwxr-xr-x    2 root     root         4096 May 11 14:12 asm-sparc64

/usr/src/linux-2.4.18-0.92sparc/include/asm-generic
/usr/src/linux-2.4.18-0.92sparc/include/asm
/usr/src/linux-2.4.18-0.92sparc/include/asm-sparc
/usr/src/linux-2.4.18-0.92sparc/include/asm-sparc64

Thanks!

I'm working on the RAID now, using your mdadm tool.

--Cal Webster
